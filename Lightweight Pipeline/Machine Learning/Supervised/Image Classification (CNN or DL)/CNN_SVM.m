function [MCC,STD] = CNN_SVM(imds)


%% Balance Test Set

tbl =  countEachLabel(imds);

% Determine the smallest amount of images in a category
minSetCount = min(tbl{:,2}); 

% Use splitEachLabel method to trim the set.
imds = splitEachLabel(imds, minSetCount, 'randomize');

%% Load Network
% Load pretrained network
net = resnet50();
% Visualize the first section of the network. 
% figure
% plot(net)
% title('First section of ResNet-50')
% set(gca,'YLim',[150 170]);
% % % Inspect the first layer
% % net.Layers(1)
% % % Inspect the last layer
% % net.Layers(end)

%% Prepare Training and Test Sets
% Use splitEachLabel method to trim the set.
[imd1 imd2 imd3 imd4 imd5 imd6 imd7 imd8 imd9 imd10] = splitEachLabel(imds,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,'randomize');
partStores{1} = imd1.Files ;
labelStores{1} = imd1.Labels ;
partStores{2} = imd2.Files ;
labelStores{2} = imd2.Labels ;
partStores{3} = imd3.Files ;
labelStores{3} = imd3.Labels ;
partStores{4} = imd4.Files ;
labelStores{4} = imd4.Labels ;
partStores{5} = imd5.Files ;
labelStores{5} = imd5.Labels ;
partStores{6} = imd6.Files ;
labelStores{6} = imd6.Labels ;
partStores{7} = imd7.Files ;
labelStores{7} = imd7.Labels ;
partStores{8} = imd8.Files ;
labelStores{8} = imd8.Labels ;
partStores{9} = imd9.Files ;
labelStores{9} = imd9.Labels ;
partStores{10} = imd10.Files; 
labelStores{10} = imd10.Labels ;
folds = 1:10;
for ii = folds
    displayNice(ii, folds(end),'\t10 Fold Cross-Validation: ');
    test_idx = ii;
    train_idx = find(folds ~= ii);
    trainStore = [];
    tLabelStore = [];
    for store_idx = train_idx
        if isempty(trainStore)
            trainStore = partStores{store_idx};
            tLabelStore = labelStores{store_idx};
        else
    trainStore = [trainStore;partStores{store_idx}];
    tLabelStore = [tLabelStore;labelStores{store_idx}];
        end
    end
      trainingSet = imageDatastore(trainStore,'FileExtensions','.jpg');
      trainingSet.Labels = tLabelStore;
      testSet = imageDatastore(cat(1, partStores{test_idx}),'FileExtensions','.jpg');
      testSet.Labels = labelStores{test_idx};

% Create augmentedImageDatastore from training and test sets to resize
% images in imds to the size required by the network.
imageSize = net.Layers(1).InputSize;
augmentedTrainingSet = augmentedImageDatastore(imageSize, trainingSet, 'ColorPreprocessing', 'gray2rgb');
augmentedTestSet = augmentedImageDatastore(imageSize, testSet, 'ColorPreprocessing', 'gray2rgb');


%% Extract Training Features

featureLayer = 'fc1000';
trainingFeatures = activations(net, augmentedTrainingSet, featureLayer, ...
    'MiniBatchSize', 32, 'OutputAs', 'columns');

% Get training labels from the trainingSet
trainingLabels = trainingSet.Labels;

% Train multiclass SVM classifier using a fast linear solver, and set
% 'ObservationsIn' to 'columns' to match the arrangement used for training
% features.
classifier = fitcecoc(trainingFeatures, trainingLabels, ...
    'Learners', 'svm', 'Coding', 'onevsall', 'ObservationsIn', 'columns');


%% Evaluate Classifier
% Extract test features using the CNN
testFeatures = activations(net, augmentedTestSet, featureLayer, ...
    'MiniBatchSize', 32, 'OutputAs', 'columns');

% Pass CNN image features to trained classifier
predictedLabels = predict(classifier, testFeatures, 'ObservationsIn', 'columns');

% Get the known labels
testLabels = testSet.Labels;

% Tabulate the results using a confusion matrix.
[confMat,categories] = confusionmat(testLabels, predictedLabels);

savedMCC(ii) = ML_MCC(confMat);

% % Convert confusion matrix into percentage form
% confMat = bsxfun(@rdivide,confMat,sum(confMat,2));
% 
% % Display the mean accuracy
% meanAccuracy = mean(diag(confMat))
end

MCC = nanmean(savedMCC);
STD = nanstd(savedMCCC);
end