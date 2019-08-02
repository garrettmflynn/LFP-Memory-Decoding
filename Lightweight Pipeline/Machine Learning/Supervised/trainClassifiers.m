
function [collectMCC,usableAlgorithms,fieldLabels,caseNames] = trainClassifiers(featureMatrix,mlAlgorithms,collectMCC,pcaCoeff,bRes);
%% Train Classifiers
% This function uses supervised methods to classify LFP data

                                                                            % Project: USC RAM
                                                                            % Author: Garrett Flynn
                                                                            % Date: July 26th, 2019


close all;

wrong = featureMatrix.WrongResponse;

% Remove K-Means from Algorithm Choices
notK = find(~ismember(mlAlgorithms,'kMeans'));
sizeDiff = length(mlAlgorithms) - length(notK);
if sizeDiff > 0
    usableAlgorithms = cell(1,sizeDiff);
for ii = 1:length(notK)
usableAlgorithms{ii} = mlAlgorithms{notK(ii)};
end
else
    usableAlgorithms = mlAlgorithms;
end
    
caseNames = fieldnames(featureMatrix.Data);
numCases = length(caseNames);
for featureCase = 1:numCases 

currentCase = caseNames{featureCase};
currentData = featureMatrix.Data.(currentCase);

% Extract Correct Trials
allVec = 1:size(currentData,1);
matrixToProcess = currentData(allVec~=wrong,:);


%% Begin Label Loop
fields = fieldnames(featureMatrix.Labels);
fieldLabels = erase(fields,'Label_');
labels = cell(size(featureMatrix.Labels.(fields{1}),1),1);
numTrials = size(featureMatrix.Labels.(fields{1}),1);
labelMaker;

for learner = 1:length(usableAlgorithms)
    fprintf(['Learner: ',usableAlgorithms{learner},'\n']);
    for categoriesToTrain = 1:length(fieldLabels)
        fprintf(['\t',fields{categoriesToTrain},'\n']);
        labelCache = cell(numTrials,1);
        currentField = fieldLabels{categoriesToTrain};
        for qq = 1:numTrials
            if strfind(labels{qq},currentField)
                labelCache{qq} = currentField;
            else
                labelCache{qq} = ['~',currentField];
            end
        end
        
        labelCache = labelCache(allVec~=wrong);
        labelCacheCat = categorical(labelCache);
        clear classifier
        %% Custom Loss Function
        %         binaryLabels = ismember(labelCache,currentField);
        %               crossEntropy = @(~,S,~,~)mean(min(-S,[],2));
        
        %% Begin Model Testing
            if ~strcmpi(usableAlgorithms{learner},'LassoGLM')
                % Linear Lasso
                if strcmpi(usableAlgorithms{learner},'linear')
                    ourLinear = templateLinear('Learner','svm','Regularization','lasso');
                    classifier = fitcecoc(matrixToProcess', labelCacheCat, ...
                        'Learners', ourLinear,'ObservationsIn', 'columns','Kfold',10);
                    clear ourLinear
                    % KNN
                elseif strcmpi(usableAlgorithms{learner},'knn')
                    ourKNN = templateKNN('NSMethod','exhaustive','Distance','cosine');
                    classifier = fitcecoc(matrixToProcess', labelCacheCat, ...
                        'Learners', ourKNN,'ObservationsIn', 'columns','Kfold',10);
                    clear ourKNN
                    % RusBoost (unbalanced classes)
                elseif strcmpi(usableAlgorithms{learner},'RUSBoost')
                    N = ceil(length(labelCacheCat)/10);         % Number of observations in training samples
                    t = templateTree('MaxNumSplits',N);
                    classifier = fitcensemble(matrixToProcess,labelCacheCat,'Method',usableAlgorithms{learner}, ...
                        'NumLearningCycles',1000,'Learners',t,'LearnRate',0.1,'nprint',100,'KFold',10);
                    clear t
                else
                    % SVM, Trees, Kernel, or Bayes
                    classifier = fitcecoc(matrixToProcess', labelCacheCat, ...
                        'Learners', usableAlgorithms{learner},'ObservationsIn', 'columns','Kfold',10);
                end

                predictedLabels = kfoldPredict(classifier);
                testLabels =  labelCacheCat;
                
                % Confusion Matrix Results
                [confMat,~] = confusionmat(testLabels, predictedLabels);
                %conf = confusionchart(testLabels,predictedLabels);
                currentMCC  = ML_MCC(confMat);
                
                 disp([currentCase,'Case | Confusion matrix: ']);
                disp(confMat);
                disp([currentCase, 'Case | MCC = ', mat2str(currentMCC)]);
                
                % Lasso GLM
            else
                binaryLabels = ismember(labelCacheCat,currentField);
                [Coefficients, FitInfo] = lassoglm(matrixToProcess, binaryLabels, 'binomial','MaxIter',25,'CV', 10,'Lambda',power(10,0:-.1:-2));
                legend('show') % Show legend
                %lp = lassoPlot(Coefficients,FitInfo,'plottype','CV');
                
                % Predict
                indx = FitInfo.IndexMinDeviance;
                cnst = FitInfo.Intercept(indx);
                B0 = Coefficients(:,indx);
                B1 = [cnst;B0];
                predictions = glmval(B1,matrixToProcess,'logit');
                
                lassoPredictions = (predictions >= .5);
                predSize = length(predictions);
                realPredicts = cell(1,predSize);
                for ii = 1:predSize
                    if lassoPredictions(ii)
                        realPredicts{ii} = currentField;
                    else
                        realPredicts{ii} = ['~',currentField];
                    end
                end
                [confMat,~] = confusionmat(labelCache, realPredicts);
                currentMCC  = ML_MCC(confMat);
                
                 disp([currentCase,'Case | Confusion matrix: ']);
                disp(confMat);
                disp([currentCase, 'Case | MCC = ', mat2str(currentMCC)]);
                
                %conf = confusionchart(labelCache,realPredicts);
            end
        end

        %% Save MCC
% outMCCs STRUCTURE
%   1D = Learners;
%   2D = Labels;
%   3D = Input Feature Type;
%   4D = Current PCA Coefficient
%   5D = Current Bspline Resolution

            collectMCC(learner,categoriesToTrain,featureCase,pcaCoeff,bRes) = currentMCC;
            
    end
end
end


%% Lasso Visualization
%                 if nargin > 4 && pcaFlag == 1
%                     if ~isempty(resIter)
%                         lassoDir = fullfile(resultsDir,'Lasso Plots',typeML,['PCA' ,num2str(pcaIter)],['Resolution' ,num2str(resIter)]);
%                     else
%                         lassoDir = fullfile(resultsDir,'Lasso Plots',typeML,['PCA' num2str(pcaIter)]);
%                     end
%                 elseif nargin > 4 && pcaFlag == 0 && ~isempty(resIter)
%                     lassoDir = fullfile(resultsDir,'Lasso Plots',typeML,['Resolution' num2str(resIter)]);
%                 else
%                     lassoDir = fullfile(resultsDir,'Lasso Plots',typeML);
%                 end
%                 
%                 if ~exist(lassoDir,'dir')
%                     mkdir(lassoDir);
%                 end
%                 
%                 if nargin > 4 && pcaFlag == 1
%                     if ~isempty(resIter)
%                         title(['PCA',num2str(pcaIter),'Resolution',num2str(resIter),' ',usableAlgorithms{learner},' ',typeML,' ',currentField]);
%                         saveas(lp,fullfile(lassoDir,['PCA',num2str(pcaIter),'Resolution',num2str(resIter),'_',usableAlgorithms{learner},'_',typeML,'_',currentField,'.png']));
%                         close all
%                     else
%                         title(['PCA',num2str(pcaIter),' ',usableAlgorithms{learner},' ',typeML,' ',currentField]);
%                         saveas(lp,fullfile(lassoDir,['PCA',num2str(pcaIter),'_',usableAlgorithms{learner},'_',typeML,'_',currentField,'.png']));
%                         close all
%                     end
%                 elseif nargin > 4 && pcaFlag == 0 && ~isempty(resIter)
%                     title(['Raw Resolution',num2str(resIter),' ',usableAlgorithms{learner},' ',typeML,' ',currentField]);
%                     saveas(lp,fullfile(lassoDir,['Raw_Resolution',num2str(resIter),'_',usableAlgorithms{learner},'_',typeML,'_',currentField,'.png']));
%                     close all
%                 else
%                     title(['Raw ',usableAlgorithms{learner},' ',typeML,' ',currentField]);
%                     saveas(lp,fullfile(lassoDir,['Raw_',usableAlgorithms{learner},'_',typeML,'_',currentField,'.png']));
%                     close all
%                 end
%                 





%% Confusion Matrix Visualization
%             if nargin > 4 && pcaFlag == 1
%                 if ~isempty(resIter)
%                     confusionDir = fullfile(resultsDir,'Confusion Matrices',typeML,['PCA' ,num2str(pcaIter)],['Resolution' ,num2str(resIter)]);
%                 else
%                     confusionDir = fullfile(resultsDir,'Confusion Matrices',typeML,['PCA' num2str(pcaIter)]);
%                 end
%             elseif nargin > 4 && pcaFlag == 0 && ~isempty(resIter)
%                 confusionDir = fullfile(resultsDir,'Confusion Matrices',typeML,['Resolution' num2str(resIter)]);
%             else
%                 confusionDir = fullfile(resultsDir,'Confusion Matrices',typeML);
%             end
%             
%             if ~exist(confusionDir,'dir')
%                 mkdir(confusionDir);
%             end
%             
%             if nargin > 4 && pcaFlag == 1
%                 if ~isempty(resIter)
%                     title(['PCA',num2str(pcaIter),'Resolution',num2str(resIter),' ',usableAlgorithms{learner},' ',typeML,' ',currentField]);
%                     saveas(conf,fullfile(confusionDir,['PCA',num2str(pcaIter),'Resolution',num2str(resIter),'_',usableAlgorithms{learner},'_',typeML,'_',currentField,'.png']));
%                     close all
%                 else
%                     title(['PCA',num2str(pcaIter),' ',usableAlgorithms{learner},' ',typeML,' ',currentField]);
%                     saveas(conf,fullfile(confusionDir,['PCA',num2str(pcaIter),'_',usableAlgorithms{learner},'_',typeML,'_',currentField,'.png']));
%                     close all
%                 end
%             elseif nargin > 4 && pcaFlag == 0 && ~isempty(resIter)
%                 title(['Raw Resolution',num2str(resIter),' ',usableAlgorithms{learner},' ',typeML,' ',currentField]);
%                 saveas(conf,fullfile(confusionDir,['Raw_Resolution',num2str(resIter),'_',usableAlgorithms{learner},'_',typeML,'_',currentField,'.png']));
%                 close all
%             else
%                 title(['Raw ',usableAlgorithms{learner},' ',typeML,' ',currentField]);
%                 saveas(conf,fullfile(confusionDir,['Raw_',usableAlgorithms{learner},'_',typeML,'_',currentField,'.png']));
%                 close all
%             end
