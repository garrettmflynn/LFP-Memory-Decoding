
clear; clc; close all;

norm = [0 1];


for iter = 1:length(norm)
%% Setup

% Data Paths
addpath(genpath('E:\NPMK'));
addpath(genpath('E:\Standardized_LFP_Code\Back End\nexManipulation'));
addpath(genpath('C:\SuperUser\Documents\GitHub\LFP-Memory-Decoding'));

% Define data path here for extracting LFP data
parameters.Directories.filePath = strcat('E:\ClipArt_2');

% Choose the testing data
parameters.Directories.dataName = 'ClipArt_2';



%% HHDataStructre Section (modified for iteration)
% Agreed-Upon Parameters
parameters.Channels.sChannels = [1:10, 17:26, 33:42];
parameters.Channels.CA1_Channels = [7:10, 23:26, 39:42];
parameters.Channels.CA3_Channels = [1:6, 17:22, 33:38];

% Processing | Binning & Windows
parameters.Optional.methods = 'Hanning'; % Either Morlet or STFT Window (such as Hanning)
parameters.Choices.freqMin = 1; % Minimum Frequency of Interest (Hz)
parameters.Choices.freqMax = 150; % Maximum Frequency of Interest (Hz)
parameters.Choices.freqBin = .5; % Frequency Bin Width (Hz)
parameters.Choices.timeBin = .1;  % Time Bin Width (s)
parameters.Choices.trialWindow = [-1 1]; % Trial Interval Window
parameters.Filters.lowPass = 250; % Low Pass Filter Frequency (Hz)
parameters.Choices.downSample = 500; % Samples/s

% Load Data
% Neural Data collected from BlackRock Microsystem
neuralData = extractNSx(parameters.Directories.filePath,parameters.Directories.dataName); % Fixed for all .nsX files

% Spike and Experimental Behavioral Data collectred from DMS memory task
nexFileData = readNexFile(fullfile(parameters.Directories.filePath,[parameters.Directories.dataName, '.nex']));


% Derive Certain Parameters from NSx Data

parameters.Derived.samplingFreq = neuralData.MetaTags.SamplingFreq;

parameters.Filters.notchFilter = designfilt('bandstopiir','FilterOrder',2, ...
    'HalfPowerFrequency1',59,'HalfPowerFrequency2',61, ...
    'DesignMethod','butter','SampleRate',neuralData.MetaTags.SamplingFreq); % Notch Filter to Remove Powerline Noise (Hz)
parameters.Derived.freq = linspace(parameters.Choices.freqMin, parameters.Choices.freqMax, ((parameters.Choices.freqMax-parameters.Choices.freqMin)+1)/parameters.Choices.freqBin);
parameters.Derived.overlap = round((parameters.Choices.timeBin * parameters.Derived.samplingFreq)/2);

% (1) Multi-Session Configuration
if size(neuralData.Data,1) == 1
    
    
    for session = 1:size(neuralData.Data,2)
        sessionPointLength = size(neuralData.Data{1,session},2);
        parameters.Derived.durationSeconds = sessionPointLength/parameters.Derived.samplingFreq;
        parameters.Derived.time = linspace(0,parameters.Derived.durationSeconds,((1/parameters.Choices.timeBin)*4)-1);
        [HHData] = singlePipeline(neuralData,nexFileData,parameters,session);
        fprintf(['Session' , num2str(session), 'Created\n']);
        HHDataMultiple.(['Session',num2str(session)]) = HHData;
        clear HHData
    end
    
fprintf('Done\n');

% (2) Single-Session Configuration
else
    sessionPointLength = size(neuralData.Data,2);
    parameters.Derived.durationSeconds = sessionPointLength/parameters.Derived.samplingFreq;
    parameters.Derived.time = linspace(0,parameters.Derived.durationSeconds,((1/parameters.Choices.timeBin)*4)-1);
    
        % Create Data Structure
        [HHData] = singlePipeline(neuralData,nexFileData,parameters);
        
        fprintf('Done\n');

end

clear neuralData
clear nexFileData

%% ADDITIONAL PROCESSING SECTION
    
% Extract Intervals Around SAMPLE_RESPONSE
[HHData.ML.Data, HHData.ML.Times] = makeIntervals(HHData.Data.LFP.Spectrum,HHData.Events.SAMPLE_RESPONSE,HHData.Data.Parameters.Choices.trialWindow,HHData.Data.Parameters.SpectrumTime);
[HHData.Data.Intervals.Signal,~] = makeIntervals(HHData.Data.LFP.LFP,HHData.Events.SAMPLE_RESPONSE,HHData.Data.Parameters.Choices.trialWindow,HHData.Data.Parameters.SamplingFrequency); 


if norm(iter)
    % Do Normalization
    HHData.Data.Voltage = [];
    HHData.Data.Spikes = [];
    HHData.Data.Normalized = normalize({HHData.Data.LFP.LFP, HHData.Data.LFP.Spectrum},'STFT','ZScore');
    [HHData.ML.Data] = makeIntervals(HHData.Data.Normalized.Spectrum,HHData.Events.SAMPLE_RESPONSE,HHData.Data.Parameters.Choices.trialWindow,HHData.Data.Parameters.SpectrumTime);
end

% But Only Keep A Small Part
dataML.Data = HHData.ML.Data;
dataML.Channels = HHData.Channels;
dataML.Directory = parameters.Directories.filePath;
dataML.Labels = HHData.Labels;
clear HHData


%% K-MEANS SECTION
% Reshape Matrices
temp = dataML.Data;
dataML.Data = [];

for channels = 1:size(temp,3)
dataML.Data(:,:,channels) = reshape(permute(squeeze(temp(:,:,channels,:)),[3,2,1]),size(temp,4),size(temp,2)*size(temp,1));
end


fprintf('Conducting Raw Clustering\n');
%% SCA KMeans
% 
% fprintf('\nSCA\n');
% CCAChoices = dataML.Channels.sChannels;
% clusterSCA = kMeansClustering(dataML,[1 0 0]);
% clusterSCA = numberClusters(clusterSCA);
% 
% [F1(channel,kVal),MCC(channel,kVal)] = correctnessIndex(currentClusters,intervalRange(end),kVal);
% dominantClusters
% 
% [~,SCA.Raw.MCC,SCA.Raw.dominantClusters,prevalence.SCA,SCA.Raw.clusterIndices] = parseClusterAssignments(dataML,clusterSCA, [1 0 0]);

%% MCA KMeans
fprintf('\nMCA\n');
CCAChoices = dataML.Channels.sChannels;
MCAMatrix = dataML;
MCAMatrix.Data = [];
for channels = 1:length(CCAChoices)
   MCAMatrix.Data = [MCAMatrix.Data dataML.Data(:,:,channels)];
end

[clusterMCA] = kMeansClustering(MCAMatrix,[0 1 0]);
[clusterMCA] = numberClusters(MCAMatrix,clusterMCA);

%% CCA KMeans for CA1
fprintf('\nCCA1\n');
CCAChoices = dataML.Channels.CA1_Channels;
MCAMatrix = dataML;
MCAMatrix.Data = [];
for channels = 1:length(CCAChoices)
   MCAMatrix.Data = [MCAMatrix.Data dataML.Data(:,:,channels)];
end

[clusterCCA1] = kMeansClustering(MCAMatrix,[0 1 0]);
clusterCCA1 = numberClusters(clusterCCA1);
[~,CCA.CA1.Raw.MCC,CCA.CA1.Raw.dominantClusters,prevalence.CCA1,CCA.CA1.Raw.clusterIndices] = parseClusterAssignments(MCAMatrix,clusterCCA1, [0 1 0]);

%% CCA KMeans for CA3
fprintf('\nCCA3\n');
CCAChoices = dataML.Channels.CA3_Channels;
MCAMatrix = dataML;
MCAMatrix.Data = [];
for channels = 1:length(CCAChoices)
    MCAMatrix.Data  = [MCAMatrix.Data dataML.Data(:,:,channels)];
end

[clusterCCA3] = kMeansClustering(MCAMatrix,[0 1 0]);
clusterCCA3 = numberClusters(clusterCCA3);
[~,CCA.CA3.Raw.MCC,CCA.CA3.Raw.dominantClusters,prevalence.CCA3,CCA.CA3.Raw.clusterIndices] = parseClusterAssignments(MCAMatrix,clusterCCA3, [0 1 0]);


%% PCA SCA
fprintf('Now Conducting PCA on SCA\n');
fPCA = figure
for channel = 1:length(dataML.Channels.sChannels)
[~,scoreSCA(:,:,channel),~,~,explained(:,:,channel),~] = pca(dataML.Data(:,:,channel,:));
  subplot(ceil(sqrt(length(dataML.Channels.sChannels))),round(sqrt(length(dataML.Channels.sChannels))),channel);bar(explained(:,:,channel));hold on;
  title(num2str(dataML.Channels.sChannels(channel)))
sgtitle('Channel-Specific Scree Plot','FontSize',30);
end
saveas(fPCA, fullfile(parameters.Directories.filePath,'ChannelSpecificScree.png'));

%% PCA MCA
fprintf('\nMCA\n');
CCAChoices = dataML.Channels.sChannels;
MCAMatrix = [];
for channels = 1:length(CCAChoices)
   MCAMatrix = [MCAMatrix dataML.Data(:,:,channels)];
end

fPCA2 =  figure;
[~,scoreMCA,~,~,explained,~] = pca(MCAMatrix);
 bar(explained);
  sgtitle('MCA Scree Plot','FontSize',30);
saveas(fPCA2, fullfile(parameters.Directories.filePath,'MCAScree.png'));

%% PCA CCA1
fprintf('\nCCA1\n');
CCAChoices = dataML.Channels.CA1_Channels;
MCAMatrix = [];
for channels = 1:length(CCAChoices)
   MCAMatrix = [MCAMatrix dataML.Data(:,:,channels)];
end

 fPCA3 = figure;
[~,scoreCCA1,~,~,explained,~] = pca(MCAMatrix);
 bar(explained);hold on;
  sgtitle('CA1 Scree Plot','FontSize',30);
  saveas(fPCA3, fullfile(parameters.Directories.filePath,'CA1Scree.png'));

%% PCA CCA3
fprintf('\nCCA3\n');
CCAChoices = dataML.Channels.CA3_Channels;
MCAMatrix = [];
for channels = 1:length(CCAChoices)
   MCAMatrix = [MCAMatrix dataML.Data(:,:,channels)];
end

fPCA4 =  figure;
[~,scoreCCA3,~,~,explained,~] = pca(MCAMatrix);
 bar(explained);hold on;
  sgtitle('CA3 Scree Plot','FontSize',30);
  saveas(fPCA2, fullfile(parameters.Directories.filePath,'CA3Scree.png'));

%% Iterate Through PCA Components
for coeffs_to_retain = [2,3,5,10]

dataML.PCA = scoreSCA(:,1:coeffs_to_retain,:);

%% Do SCA KMeans on PCA
fprintf('\Now Clustering SCA\n');
[clusterSCA] = kMeansClustering(dataML,[1 0 0]);
clusterSCA = numberClusters(clusterSCA);
[~,SCA.PCA.MCC,SCA.PCA.dominantClusters,prevalence.PCA.SCA,SCA.PCA.clusterIndices] = parseClusterAssignments(dataML,clusterSCA,[1 0 0]);

%% Do MCA KMeans on PCA
fprintf('\nMCA\n');
dataML.PCA = scoreMCA(:,1:coeffs_to_retain,:);
[clusterMCA] = kMeansClustering(dataML,[0 1 0]);
clusterMCA = numberClusters(clusterMCA);
[~,MCA.PCA.MCC,MCA.PCA.dominantClusters,prevalence.PCA.MCA,MCA.PCA.clusterIndices] = parseClusterAssignments(dataML,clusterMCA,[0 1 0]);

%% Do CCA KMeans for CA1 and PCA
fprintf('\nCCA1\n');
dataML.PCA = scoreCCA1(:,1:coeffs_to_retain,:);
[clusterCCA1] = kMeansClustering(dataML,[0 1 0]);
clusterCCA1 = numberClusters(clusterCCA1);
[~,CCA.CA1.PCA.MCC,CCA.CA1.PCA.dominantClusters,prevalence.PCA.CCA1,CCA.CA1.PCA.clusterIndices] = parseClusterAssignments(dataML,clusterCCA1, [0 1 0]);

%% Do CCA KMeans for CA3 and PCA
fprintf('\nCCA3\n');
 dataML.PCA = scoreCCA3(:,1:coeffs_to_retain,:);
[clusterCCA3] = kMeansClustering(dataML,[0 1 0]);
clusterCCA3 = numberClusters(clusterCCA3);
[~,CCA.CA3.PCA.MCC,CCA.CA3.PCA.dominantClusters,prevalence.PCA.CCA3,CCA.CA3.PCA.clusterIndices] = parseClusterAssignments(dataML,clusterCCA3, [0 1 0]);


consistency = prevalenceDetection2(prevalence);

    results = struct();
    results.SCA = SCA;
    results.MCA = MCA;
    results.CCA = CCA;
    results.consistency = consistency;

if norm(iter) == 1
save(fullfile(parameters.Directories.filePath,[parameters.Directories.dataName, 'ResultsNorm',num2str(coeffs_to_retain),'.mat']),'results');
else
save(fullfile(parameters.Directories.filePath,[parameters.Directories.dataName, 'Results',num2str(coeffs_to_retain),'.mat']),'results');
end
end
clear MCA
clear SCA
clear CCA
clear dataML
end