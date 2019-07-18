function [MCCs] = gKernel(dataML,passedMLType)

matrixToProcess = dataML.Data;

%% Begin Label Loop
fields = fieldnames(dataML.Labels);
fieldLabels = erase(fields,'Label_');
labels = cell(size(dataML.Labels.(fields{1}),1),1);
numTrials = size(dataML.Labels.(fields{1}),1);
labelMaker;

for categoriesToTrain = 1:length(fields)
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
    
labelCache = categorical(labelCache);

%% Balance Test Set (not done yet)
%% Start Cross Validation
indices = crossvalind('Kfold',labelCache,10);
folds = 1:10;
for ii = folds
    displayNice(ii, folds(end),'\t10 Fold Cross-Validation: ');
    test = (indices == ii); 
    train = ~test;
    trainingLabels = labelCache(train);
    classifier = fitcecoc(matrixToProcess(train,:), trainingLabels, ...
    'Learners', 'kernel', 'Coding', 'onevsall', 'ObservationsIn', 'columns');
    % Pass features to trained classifier
predictedLabels = predict(classifier, matrixToProcess(test), 'ObservationsIn', 'columns');

% Get the known labels
testLabels =  labelCache(test);

% Tabulate the results using a confusion matrix.
[confMat,categories] = confusionmat(testLabels, predictedLabels);

saveMCC(categoriesToTrain,ii) = ML_MCC(confMat);
end

end
MCCs = nanmean(MCCs);
end