function [outMCCs] = trainClassifiers(dataML,learnerTypes)

if nargin == 1
    learnerTypes = [1 1 1 1 1 1 1 0];
end

wrong = dataML.WrongResponse;

if isfield(dataML,'PCA')
    allVec = 1:size(dataML.PCA,1);
    matrixToProcess = dataML.PCA(allVec~=wrong,:);
else
    allVec = 1:size(dataML.Data,1);
    matrixToProcess = dataML.Data(allVec~=wrong,:);
end
    
%% Begin Label Loop
fields = fieldnames(dataML.Labels);
fieldLabels = erase(fields,'Label_');
labels = cell(size(dataML.Labels.(fields{1}),1),1);
numTrials = size(dataML.Labels.(fields{1}),1);
labelMaker;

% BTW Linear is Lasso
learnerNames = {'linear','kernel','knn','naivebayes','svm','tree','RUSBoost'};
for learner = 1:sum(learnerTypes)
    learnerChoices = find(learnerTypes);
    fprintf(['Learner: ',learnerNames{learnerChoices(learner)},'\n']);
    for categoriesToTrain = 1:length(fieldLabels)
        fprintf(['\t',fields{categoriesToTrain},'\n']);
        labelCache = cell(numTrials,1);
        currentCategory = dataML.Labels.(fields{categoriesToTrain});
        currentField = fieldLabels{categoriesToTrain};
        for qq = 1:numTrials;
            if strfind(labels{qq},currentField)
                labelCache{qq} = currentField;
            else
                labelCache{qq} = ['Not ' currentField];
            end
        end
        
        labelCache = categorical(labelCache(allVec~=wrong));
        classifier = [];
        %% Custom Loss Function
        binaryLabels = labelCache == 
              crossEntropy = @(~,S,~,~)mean(min(-S,[],2));
        
        %% Begin Model Testing
        if ~strcmp(learnerNames{learnerChoices(learner)},'kernel') && ~strcmp(learnerNames{learnerChoices(learner)},'naivebayes')
            % Lasso
            if strcmp(learnerNames{learnerChoices(learner)},'linear')
                ourLinear = templateLinear('Learner','svm','Regularization','lasso');
                classifier = fitcecoc(matrixToProcess', labelCache, ...
                    'Learners', ourLinear,'ObservationsIn', 'columns','Kfold',10);
                clear ourLinear
                % KNN
            elseif strcmp(learnerNames{learnerChoices(learner)},'knn')
                ourKNN = templateKNN('NSMethod','exhaustive','Distance','cosine');
                classifier = fitcecoc(matrixToProcess', labelCache, ...
                    'Learners', ourKNN,'ObservationsIn', 'columns','Kfold',10);
                clear ourKNN
                % RusBoost (unbalanced classes)
            elseif strcmp(learnerNames{learnerChoices(learner)},'RUSBoost')
                N = ceil(length(labelCache)/10);         % Number of observations in training samples
                t = templateTree('MaxNumSplits',N);
                classifier = fitcensemble(matrixToProcess,labelCache,'Method',learnerNames{learnerChoices(learner)}, ...
                    'NumLearningCycles',1000,'Learners',t,'LearnRate',0.1,'nprint',100,'KFold',10);
                clear t
            else
                % SVM or Trees
                classifier = fitcecoc(matrixToProcess', labelCache, ...
                    'Learners', learnerNames{learnerChoices(learner)},'ObservationsIn', 'columns','Kfold',10);
            end
            % Pass features to trained classifier
            %predictedLabels = predict(classifier, matrixToProcess', 'ObservationsIn', 'columns');
            predictedLabels = kfoldPredict(classifier);
            
            % Get the known labels
            testLabels =  labelCache;
            
            % Tabulate the results using a confusion matrix.
            %confusionchart(testLabels,predictedLabels,'Normalization','row-normalized','RowSummary','row-normalized');
            [confMat,categories] = confusionmat(testLabels, predictedLabels);
            %plotconfusion(testLabels, predictedLabels);
            saveMCC.(fieldLabels{categoriesToTrain}) = ML_MCC(confMat);
            
            %% Incorporate Models with Long Execution on Raw Data
            %  Due to the Size of our Inputs, Naive Bayes and Gaussian Are Not Feasible for Raw Data Analyses
        else
            if size(matrixToProcess,2) < 50
                % Naive Bayes or Gaussian
                classifier = fitcecoc(matrixToProcess', labelCache, ...
                    'Learners', learnerNames{learnerChoices(learner)},'ObservationsIn', 'columns','Kfold',10);
                predictedLabels = kfoldPredict(classifier);
                testLabels =  labelCache;
                [confMat,categories] = confusionmat(testLabels, predictedLabels);
                saveMCC.(fieldLabels{categoriesToTrain}) = ML_MCC(confMat);
            end
        end
        
        
        
    end
    if ~strcmp(learnerNames{learnerChoices(learner)},'kernel') && ~strcmp(learnerNames{learnerChoices(learner)},'naivebayes')
        outMCCs.(learnerNames{learnerChoices(learner)}) = saveMCC;
    else
        if size(matrixToProcess,2) < 50
            outMCCs.(learnerNames{learnerChoices(learner)}) = saveMCC;
        end
    end
end
end

