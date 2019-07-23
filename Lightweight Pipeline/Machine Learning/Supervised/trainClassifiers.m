function [outMCCs] = trainClassifiers(dataML,learnerTypes,resultsDir,typeML,pcaIter)

close all;

if nargin == 1
    learnerTypes = [1 0 0 0 0 0 0 0];
end

wrong = dataML.WrongResponse;

if isfield(dataML,'PCA')
    allVec = 1:size(dataML.PCA,1);
    dataML.PCA = permute(dataML.PCA,[1,3,2]);
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
learnerNames = {'LassoGLM','linear','kernel','knn','naivebayes','svm','tree','RUSBoost'};
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
                labelCache{qq} = ['~',currentField];
            end
        end
        
        labelCache = labelCache(allVec~=wrong);
        labelCacheCat = categorical(labelCache);
        classifier = [];
        %% Custom Loss Function
%         binaryLabels = ismember(labelCache,currentField);
%               crossEntropy = @(~,S,~,~)mean(min(-S,[],2));
        
        %% Begin Model Testing
        done = 0;
        if ~strcmp(learnerNames{learnerChoices(learner)},'kernel') && ~strcmp(learnerNames{learnerChoices(learner)},'naivebayes')
            if ~strcmp(learnerNames{learnerChoices(learner)},'LassoGLM')
            % Lasso
            if strcmp(learnerNames{learnerChoices(learner)},'linear')
                ourLinear = templateLinear('Learner','logistic','Regularization','lasso');
                classifier = fitcecoc(matrixToProcess', labelCacheCat, ...
                    'Learners', ourLinear,'ObservationsIn', 'columns','Kfold',10);
                clear ourLinear
                % KNN
            elseif strcmp(learnerNames{learnerChoices(learner)},'knn')
                ourKNN = templateKNN('NSMethod','exhaustive','Distance','cosine');
                classifier = fitcecoc(matrixToProcess', labelCacheCat, ...
                    'Learners', ourKNN,'ObservationsIn', 'columns','Kfold',10);
                clear ourKNN
                % RusBoost (unbalanced classes)
            elseif strcmp(learnerNames{learnerChoices(learner)},'RUSBoost')
                N = ceil(length(labelCacheCat)/10);         % Number of observations in training samples
                t = templateTree('MaxNumSplits',N);
                classifier = fitcensemble(matrixToProcess,labelCacheCat,'Method',learnerNames{learnerChoices(learner)}, ...
                    'NumLearningCycles',1000,'Learners',t,'LearnRate',0.1,'nprint',100,'KFold',10);
                clear t
            else
                % SVM or Trees
                classifier = fitcecoc(matrixToProcess', labelCacheCat, ...
                    'Learners', learnerNames{learnerChoices(learner)},'ObservationsIn', 'columns','Kfold',10);
            end
            % Pass features to trained classifier
            %predictedLabels = predict(classifier, matrixToProcess', 'ObservationsIn', 'columns');
            predictedLabels = kfoldPredict(classifier);
            
            % Get the known labels
            testLabels =  labelCacheCat;
            
            % Tabulate the results using a confusion matrix.
            [confMat,categories] = confusionmat(testLabels, predictedLabels);
            conf = confusionchart(testLabels,predictedLabels);
            
            % Lasso GLM
            else
                binaryLabels = ismember(labelCacheCat,currentField);
            [Coefficients, FitInfo] = lassoglm(matrixToProcess, binaryLabels, 'binomial','MaxIter',100,'CV', 10);
            indx = FitInfo.IndexMinDeviance;
            cnst = FitInfo.Intercept(indx);
            B0 = Coefficients(:,indx);
            nonzeros = sum(B0 ~= 0);
B1 = [cnst;B0];
preds = glmval(B1,matrixToProcess,'logit');
histogram(binaryLabels - preds); % plot residuals
title('Residuals from lassoglm model');

            predictors = find(B0); % indices of nonzero predictors
            
    indices = crossvalind('Kfold',labelCacheCat,10);
    cp = classperf(labelCache);
       for i = 1:10
    test = (indices == i); 
    train = ~test;
    %class = classify(matrixToProcess(test,:),matrixToProcess(train,:),labelCache(train,:)); 
            
            classifier = fitglm(matrixToProcess(train,:),labelCacheCat(train),'linear',...
             'Distribution','binomial','PredictorVars',predictors);
         
         predictions = (round(predict(classifier,matrixToProcess(test,:))) == 0);
         
         realPredicts = [];
            for ii = 1:length(predictions)
         if predictions(ii)
             realPredicts{ii} = currentField;
         else
             realPredicts{ii} = ['~',currentField];
         end
            end
            
            classperf(cp,realPredicts,test); 
%             
%             [confMat,categories] = confusionmat(labelCache, catPredicts);
%             conf = confusionchart(labelCache,catPredicts);

       end    
       confMat = cp.DiagnosticTable;
            %plotResiduals(classifier);
        end
            done = 1;
            %% Incorporate Models with Long Execution on Raw Data
            %  Due to the Size of our Inputs, Naive Bayes and Gaussian Are Not Feasible for Raw Data Analyses
        else
            if size(matrixToProcess,2) < 1000
                % Naive Bayes or Gaussian
                classifier = fitcecoc(matrixToProcess', labelCache, ...
                    'Learners', learnerNames{learnerChoices(learner)},'ObservationsIn', 'columns','Kfold',10);
                predictedLabels = kfoldPredict(classifier);
                testLabels =  labelCache;
                [confMat,categories] = confusionmat(testLabels, predictedLabels);
                conf = confusionchart(testLabels,predictedLabels);
                saveMCC.(fieldLabels{categoriesToTrain}) = ML_MCC(confMat);
                done = 1;
            end
        end
     
        if ~done
            fprintf('Not Done\n');
        else
            if nargin > 4
                title(['PCA',num2str(pcaIter),' ',learnerNames{learnerChoices(learner)},' ',typeML,' ',currentField]);
            saveas(conf,fullfile(resultsDir,['PCA',num2str(pcaIter),'_',learnerNames{learnerChoices(learner)},'_',typeML,'_',currentField,'.png']));
            close all
            else
                title(['Raw ',learnerNames{learnerChoices(learner)},' ',typeML,' ',currentField]);
            saveas(conf,fullfile(resultsDir,['Raw_',learnerNames{learnerChoices(learner)},'_',typeML,'_',currentField,'.png']));
            close all
             end
            saveMCC.(fieldLabels{categoriesToTrain}) = ML_MCC(confMat);
        end
        
        
    end
    if ~strcmp(learnerNames{learnerChoices(learner)},'kernel') && ~strcmp(learnerNames{learnerChoices(learner)},'naivebayes')
        outMCCs.(learnerNames{learnerChoices(learner)}) = saveMCC;
    else
        if size(matrixToProcess,2) < 1000
            outMCCs.(learnerNames{learnerChoices(learner)}) = saveMCC;
        end
    end
end
end

