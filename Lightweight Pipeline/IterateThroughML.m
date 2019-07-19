

if exist('dataML', 'var') || exist('HHData','var')
    if exist('HHData','var') && ~exist('dataML', 'var')
        dataML = HHData.ML;
    end

if Kmeans || allBasicClassifiers
%% K-MEANS SECTION
% Reshape Matrices
temp = dataML.Data;
dataML.Data = [];
count = 1;

for channels = 1:size(temp,3)
dataML.Data(:,:,channels) = reshape(permute(squeeze(temp(:,:,channels,:)),[3,2,1]),size(temp,4),size(temp,2)*size(temp,1));
end

% Make Real Clusters Vector
realCluster = realClusters(dataML.Labels);


fprintf('Conducting Raw Clustering\n');
saveBars = fullfile(parameters.Directories.filePath,'MCC Bar Plots');

if Raw
% Do SCA KMeans

% fprintf('\nSCA\n');
% CCAChoices = dataML.Channels.sChannels;
% [SCA.Raw.clusterIndices] = kMeansClustering(dataML,[1 0 0]);
% [SCA.Raw.MCC,SCA.Raw.MCC_Categories,orderedClustersSCA] = parseClusterAssignments(dataML,SCA.Raw.clusterIndices, [1 0 0]);
% 
% 
% if ~exist(fullfile(saveBars,'SCA'),'dir');
%     mkdir(fullfile(saveBars,'SCA'));
% end
% makeMCCBars(SCA.Raw.MCC,SCA.Raw.MCC_Categories,dataML.Labels,[],'SCA',norm(iter),fullfile(saveBars,'SCA'));

% Do MCA (non-CNN)
fprintf('\nMCA\n');
CCAChoices = dataML.Channels.sChannels;
MCAMatrix = dataML;
MCAMatrix.Data = [];
for channels = 1:length(CCAChoices)
   MCAMatrix.Data = [MCAMatrix.Data dataML.Data(:,:,channels)];
end

if Kmeans
[MCA.Raw.clusterIndices] = kMeansClustering(MCAMatrix,[0 1 0]);
saveBarsMCA= fullfile(saveBars,'MCA');
[MCA.Raw.MCC,MCA.Raw.MCC_Categories,collectedClusterings(:,count),excluded{count}] = parseClusterAssignments(MCAMatrix,MCA.Raw.clusterIndices, [0 1 0],{MCAMatrix.Labels,[],'MCA',norm(iter),saveBarsMCA});
count = count + 1;
end
if allBasicClassifiers
    name = 'MCA';
cMCA.Raw = trainClassifiers(MCAMatrix,learnerTypes,name);
end

% Do CCA (non-CNN) for CA1
fprintf('\nCCA1\n');
CCAChoices = dataML.Channels.CA1_Channels;
MCAMatrix = dataML;
MCAMatrix.Data = [];
for channels = 1:length(CCAChoices)
   MCAMatrix.Data = [MCAMatrix.Data dataML.Data(:,:,channels)];
end

if Kmeans
[CCA.CA1.Raw.clusterIndices] = kMeansClustering(MCAMatrix,[0 1 0]);
saveBarsCA1= fullfile(saveBars,'CA1');
[CCA.CA1.Raw.MCC,CCA.CA1.Raw.MCC_Categories,collectedClusterings(:,count),excluded{count}] = parseClusterAssignments(MCAMatrix,CCA.CA1.Raw.clusterIndices, [0 1 0],{MCAMatrix.Labels,[],'CA1',norm(iter),saveBarsCA1});
count = count + 1;
end
if allBasicClassifiers
    name = 'CA1';
    cCA1.Raw = trainClassifiers(MCAMatrix,learnerTypes,name);
end

% Do CCA (non-CNN) for CA3
fprintf('\nCCA3\n');
CCAChoices = dataML.Channels.CA3_Channels;
MCAMatrix = dataML;
MCAMatrix.Data = [];
for channels = 1:length(CCAChoices)
    MCAMatrix.Data  = [MCAMatrix.Data dataML.Data(:,:,channels)];
end

if Kmeans
[CCA.CA3.Raw.clusterIndices] = kMeansClustering(MCAMatrix,[0 1 0]);
saveBarsCA3= fullfile(saveBars,'CA3');
[CCA.CA3.Raw.MCC,CCA.CA3.Raw.MCC_Categories,collectedClusterings(:,count),excluded{count}] = parseClusterAssignments(MCAMatrix,CCA.CA3.Raw.clusterIndices, [0 1 0],{MCAMatrix.Labels,[],'CA3',norm(iter),saveBarsCA3});
count = count + 1;
end
if allBasicClassifiers
    name = 'CA3';
    cCA3.Raw = trainClassifiers(MCAMatrix,learnerTypes,name);
end

%% Organize Results
    results = struct();
if KMeans
%     results.SCA = SCA;
    results.MCA = MCA;
    results.CCA = CCA;
    %results.consistency = consistency;
    resultsDir = fullfile(parameters.Directories.filePath,'Results');  
    
end
if allBasicClassifiers
    %results.SCA = cSCA;
    results.MCC.MCA = cMCA;
    results.MCC.CC1 = cCA1;
    results.MCC.CA3 = cCA3;
    resultsDir = fullfile(parameters.Directories.filePath,'Classifier Results');
   visualizeClassifierPerformance(results,norm,fullfile(resultsDir,'MCCs'));
end

if ~PCA
if norm(iter) == 1
save(fullfile(resultsDir,[parameters.Directories.dataName, 'ResultsNorm.mat']),'results');
else
save(fullfile(resultsDir,[parameters.Directories.dataName, 'Results.mat']),'results');
end
end

end

%% Do Everything Again While Iterating Through PCA
if PCA
savePCA = fullfile(parameters.Directories.filePath,'Scree Plots');
    if ~exist(savePCA,'dir');
    mkdir(savePCA);
    end
    
savePCAViz = fullfile(parameters.Directories.filePath,'PCA Scatter Plots');
%% PCA SCA
% fprintf('Now Conducting PCA on SCA\n');
% fPCA = figure('visible','off','units','normalized','outerposition',[0 0 1
% 1]);
% for channel = 1:length(dataML.Channels.sChannels)
% [~,scoreSCA(:,:,channel),~,~,explained(:,:,channel),~] = pca(dataML.Data(:,:,channel,:));
%   subplot(ceil(sqrt(length(dataML.Channels.sChannels))),round(sqrt(length(dataML.Channels.sChannels))),channel);bar(explained(:,:,channel));hold on;
%   title(num2str(dataML.Channels.sChannels(channel)))
% end
% if norm(iter)
% sgtitle('Normalized Channel-Specific Scree Plot','FontSize',30);
% % saveas(fPCA, fullfile(savePCA,'NormChannelSpecificScree.png'));
% % else
% sgtitle('Channel-Specific Scree Plot','FontSize',30);
%     saveas(fPCA, fullfile(savePCA,'ChannelSpecificScree.png'));
% end
%% PCA MCA
fprintf('\nMCA\n');
CCAChoices = dataML.Channels.sChannels;
MCAMatrix = [];
for channels = 1:length(CCAChoices)
   MCAMatrix = [MCAMatrix dataML.Data(:,:,channels)];
end

fPCA2 =  figure('visible','off','units','normalized','outerposition',[0 0 1 1]);
[~,scoreMCA,~,~,explained,~] = pca(MCAMatrix);
 bar(explained);
  sgtitle('MCA Scree Plot','FontSize',30);
if norm(iter)
    sgtitle('Normalized MCA Scree Plot','FontSize',30);
saveas(fPCA2, fullfile(savePCA,'NormMCAScree.png'));
else
    sgtitle('MCA Scree Plot','FontSize',30);
saveas(fPCA2, fullfile(savePCA,'MCAScree.png'));
end

%% PCA CCA1
fprintf('\nCCA1\n');
CCAChoices = dataML.Channels.CA1_Channels;
MCAMatrix = [];
for channels = 1:length(CCAChoices)
   MCAMatrix = [MCAMatrix dataML.Data(:,:,channels)];
end

 fPCA3 = figure('visible','off','units','normalized','outerposition',[0 0 1 1]);
[~,scoreCA1,~,~,explained,~] = pca(MCAMatrix);
 bar(explained);hold on;
  sgtitle('CA1 Scree Plot','FontSize',30);
if norm(iter)
    sgtitle('Normalized CA1 Scree Plot','FontSize',30);
  saveas(fPCA3, fullfile(savePCA,'NormCA1Scree.png'));
else
    sgtitle('CA1 Scree Plot','FontSize',30);
  saveas(fPCA3, fullfile(savePCA,'CA1Scree.png'));
end

%% PCA CCA3
fprintf('\nCCA3\n');
CCAChoices = dataML.Channels.CA3_Channels;
MCAMatrix = [];
for channels = 1:length(CCAChoices)
   MCAMatrix = [MCAMatrix dataML.Data(:,:,channels)];
end

fPCA4 =  figure('visible','off','units','normalized','outerposition',[0 0 1 1]);
[~,scoreCA3,~,~,explained,~] = pca(MCAMatrix);
 bar(explained);hold on;
  if norm(iter)
      sgtitle('Normalized CA3 Scree Plot','FontSize',30);
  saveas(fPCA4, fullfile(savePCA,'NormCA3Scree.png'));
  else 
      sgtitle('CA3 Scree Plot','FontSize',30);
      saveas(fPCA4, fullfile(savePCA,'CA3Scree.png'));
  end

%% Iterate Through PCA Components
for coeffs_to_retain = [2,3,5,10]

% dataML.PCA = scoreSCA(:,1:coeffs_to_retain,:);
%saveDuringML;

%% Do SCA KMeans on PCA
% fprintf('\Now Clustering SCA\n');
% [SCA.PCA.clusterIndices] = kMeansClustering(dataML,[0 1 0]);
% [SCA.PCA.MCC,SCA.PCA.MCC_Categories,SCA.PCA.dominantClusters,prevalence.PCA.SCA] = parseClusterAssignments(dataML, SCA.PCA.clusterIndices,[0 1 0]);

% if ~exist(fullfile(saveBars,'SCA'),'dir');
%     mkdir(fullfile(saveBars,'SCA'));
% end

% makeMCCBars(SCA.PCA.MCC,SCA.PCA.MCC_Categories,dataML.Labels,coeffs_to_retain,'SCA',norm(iter), fullfile(saveBars,'SCA'));
% if ~exist(fullfile(savePCAViz,'SCA'),'dir');
%     mkdir(fullfile(savePCAViz,'SCA'));
% end
% if coeffs_to_retain ==  2 
% orderedClustersSCA_PCA{1} = analyzeClusters(dataML,SCA.PCA.clusterIndices)
% elseif coeffs_to_retain ==  3
% orderedClustersSCA_PCA{2} = analyzeClusters(dataML,SCA.PCA.clusterIndices)
% createPCAVisualizations(scoreSCA,orderedClustersSCA_PCA,'SCA',norm(iter),fullfile(savePCAViz,'SCA'));
% end
%% Do MCA (non-CNN) on PCA
fprintf('\nMCA\n');
dataML.PCA = scoreMCA(:,1:coeffs_to_retain,:);
if KMeans
[MCA.PCA.clusterIndices] = kMeansClustering(dataML,[0 1 0]);
nIters = size(MCA.PCA.clusterIndices,3);

saveBarsMCA = fullfile(saveBars,'MCA');
[MCA.PCA.MCC,MCA.PCA.MCC_Categories,collectedClusterings(:,count),excluded{count}] = parseClusterAssignments(dataML, MCA.PCA.clusterIndices,[0 1 0],{dataML.Labels,coeffs_to_retain,'MCA',norm(iter),saveBarsMCA});
if coeffs_to_retain ==  2 
    PCA2CountMCA = count;
elseif coeffs_to_retain ==  3
    for len = 1:size(collectedClusterings,1)
        orderedClustersMCA_PCA = [collectedClusterings(len,PCA2CountMCA) , collectedClusterings(len,count)];
        excludedMCA_PCA = {excluded{PCA2CountMCA} , excluded{count}};
        label = 'All Above';
createPCAVisualizations(scoreMCA,orderedClustersMCA_PCA,['MCA ' ,label,' ', num2str(nIters-(len-1))],norm(iter),fullfile(savePCAViz,['MCA_' label]),excludedMCA_PCA);
 createPCAVisualizations_RealClusters(scoreMCA,realCluster,'MCA Correct Cluster',norm(iter),fullfile(savePCAViz,['CorrectMCA_' label]),fieldnames(dataML.Labels));
  
    end
end
count = count + 1;
end
if allBasicClassifiers
       name = 'MCA';
       pcaName = ['PCA',num2str(coeffs_to_retain)];
    cMCA.(pcaName).MCC = trainClassifiers(dataML,learnerTypes,name);
end




%% Do CCA (non-CNN) for CA1 and PCA
fprintf('\nCCA1\n');
dataML.PCA = scoreCA1(:,1:coeffs_to_retain,:);
if Kmeans
[CCA.CA1.PCA.clusterIndices] = kMeansClustering(dataML,[0 1 0]);
nIters = size(CCA.CA1.PCA.clusterIndices,3);

saveBarsCA1= fullfile(saveBars,'CA1');
[CCA.CA1.PCA.MCC,CCA.CA1.PCA.MCC_Categories,collectedClusterings(:,count),excluded{count}] = parseClusterAssignments(dataML,CCA.CA1.PCA.clusterIndices, [0 1 0],{dataML.Labels,coeffs_to_retain,'CA1',norm(iter),saveBarsCA1});

if coeffs_to_retain ==  2 
PCA2CountCA1 = count;
elseif coeffs_to_retain ==  3
for len = 1:size(collectedClusterings,1)
        orderedClustersCA1_PCA = [collectedClusterings(len,PCA2CountCA1) , collectedClusterings(len,count)];
        excludedCA1_PCA = {excluded{PCA2CountCA1} , excluded{count}};
                label = 'All Above';
createPCAVisualizations(scoreCA1,orderedClustersCA1_PCA,['CA1 ' ,label,' ', num2str(nIters-(len-1))],norm(iter),fullfile(savePCAViz,['CA1_' label]),excludedCA1_PCA);
createPCAVisualizations_RealClusters(scoreCA1,realCluster,'CA1 Correct Cluster',norm(iter),fullfile(savePCAViz,['CorrectCA1_' label]),fieldnames(dataML.Labels));

end
end
count = count + 1;
end
if allBasicClassifiers
       name = 'CA1';
       pcaName = ['PCA',num2str(coeffs_to_retain)];
    cCA1.(pcaName).MCC = trainClassifiers(dataML,learnerTypes,name);
end
%% Do CCA (non-CNN) for CA3 and PCA
fprintf('\nCCA3\n');
 dataML.PCA = scoreCA3(:,1:coeffs_to_retain,:);
 if Kmeans
[CCA.CA3.PCA.clusterIndices] = kMeansClustering(dataML,[0 1 0]);
nIters = size(CCA.CA3.PCA.clusterIndices,3);

saveBarsCA3= fullfile(saveBars,'CA3');
[CCA.CA3.PCA.MCC,CCA.CA3.PCA.MCC_Categories,collectedClusterings(:,count),excluded{count}] = parseClusterAssignments(dataML,CCA.CA3.PCA.clusterIndices, [0 1 0],{dataML.Labels,coeffs_to_retain,'CA3',norm(iter),saveBarsCA3});

if coeffs_to_retain ==  2 
PCA2CountCA3 = count;
elseif coeffs_to_retain ==  3
    for len = 1:size(collectedClusterings,1)
        orderedClustersCA3_PCA = [collectedClusterings(len,PCA2CountCA3) , collectedClusterings(len,count)];
        excludedCA3_PCA = {excluded{:,PCA2CountCA3} , excluded{count}};
                label = 'All Above';
    createPCAVisualizations(scoreCA3,orderedClustersCA3_PCA,['CA3 ' ,label,' ', num2str(nIters-(len-1))],norm(iter),fullfile(savePCAViz,['CA3_' label]),excludedCA3_PCA);
    createPCAVisualizations_RealClusters(scoreCA3,realCluster,'CA3 Correct Cluster',norm(iter),fullfile(savePCAViz,['CorrectCA3_' label]),fieldnames(dataML.Labels));
    end
end
count = count + 1;
end
if allBasicClassifiers
       name = 'CA3';
       pcaName = ['PCA',num2str(coeffs_to_retain)];
    cCA3.(pcaName) = trainClassifiers(dataML,learnerTypes,name);
end

%% Organize Results

    results = struct();
if KMeans
%     results.SCA = SCA;
    results.MCA = MCA;
    results.CCA = CCA;
    %results.consistency = consistency;
    resultsDir = fullfile(parameters.Directories.filePath,'Results');  
    
end
if allBasicClassifiers
    %results.SCA = SCA;
    results.MCC.MCA = cMCA;
    results.MCC.CC1 = cCA1;
    results.MCC.CA3 = cCA3;
    resultsDir = fullfile(parameters.Directories.filePath,'Classifier Results');
    visualizeClassifierPerformance(results,norm,fullfile(resultsDir,'MCCs'));
end
end

if ~exist(resultsDir,'dir');
    mkdir(resultsDir);
    end  
    
if norm(iter) == 1
save(fullfile(resultsDir,[parameters.Directories.dataName, 'ResultsNorm',num2str(coeffs_to_retain),'.mat']),'results');
else
save(fullfile(resultsDir,[parameters.Directories.dataName, 'Results',num2str(coeffs_to_retain),'.mat']),'results');
end
end

clear MCA
clear SCA
clear CCA
end
end





% CNN Methods Only
if CNN_SVM
    CNN_Pipeline;
    processAllClassestoResults(results,'CNN_SVM');
    supervisedDir = fullfile(parameters.Directories.filePath,'CNN Results');

if ~exist(supervisedDir,'dir');
    mkdir(supervisedDir);
    end  
if norm(iter) == 1
save(fullfile(supervisedDir,[parameters.Directories.dataName, 'ResultsNorm.mat']),'results');
else
save(fullfile(supervisedDir,[parameters.Directories.dataName, 'Results.mat']),'results');
end
end
