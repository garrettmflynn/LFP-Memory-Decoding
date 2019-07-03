% CLASSIFICATIONPIPELINE uses Human Hippocampal Data Structures to Classify
% Related Trials using LFP.
% Only works with single session currently.


clear; clc; close all;

%% Data Paths
addpath(genpath('E:\NPMK'));
addpath(genpath('E:\Standardized_LFP_Code\Back End\nexManipulation'));
addpath(genpath('C:\SuperUser\Documents\GitHub\LFP-Memory-Decoding'));

% Define data path here for extracting LFP data
parameters.Directories.filePath = strcat('E:\ClipArt_2');

% Choose the testing data
parameters.Directories.dataName = 'ClipArt_2';


%% Structure Parameters
norm = 0;
add_bands = 0;

%% Classification Parameters
SINGLE_CHANNEL_ANALYSIS = 1;
MULTI_CHANNEL_ANALYSIS = 0; 
CHOICE_CHANNEL_ANALYSIS = 0;

K_MEANS = 1;
normal = 1;
    PCA = 1;
        coeffs_to_retain = 5


%% Create Data Structure
%  Make Sure To Tune Data Structure Parameters in loadParameters.m
if ~exist(fullfile('C:\SuperUser\Xiwei Results',[parameters.Directories.dataName, '_processedData.mat']),'file')
HHDataStructure();
    
    %% Process Data
    
% Extract Intervals Around SAMPLE_RESPONSE
[HHData.ML.Data, HHData.ML.Times] = makeIntervals(HHData.Data.LFP.Spectrum,HHData.Events.SAMPLE_RESPONSE,HHData.Data.Parameters.Choices.trialWindow,HHData.Data.Parameters.SpectrumTime);
[HHData.Data.Intervals.Signal,~] = makeIntervals(HHData.Data.LFP.LFP,HHData.Events.SAMPLE_RESPONSE,HHData.Data.Parameters.Choices.trialWindow,HHData.Data.Parameters.SamplingFrequency); 

% Visualize Quickly
% for interval = [26] %1:size(HHData.Intervals.Data,ndims(HHData.Intervals.Data))
%     for channel = [38] %1:size(HHData.RawData,1)
%             standardImage(HHData.ML.Data(:,:,(HHData.Channels.sChannels == channel),interval),HHData.Events,HHData.Data.Parameters, HHData.Data.Parameters.Choices.downSample, ['Spectrum_Interval' ,num2str(interval)], channel,interval,HHData.ML.Times(:,interval),'dB', [-100 100], fullfile(parameters.Directories.filePath,'Intervals',['Channel',num2str(channel)]), 'Spectrum',1);
%     end
% end


if norm
    % Do Normalization
    HHData.Data.Normalized = normalize({HHData.Data.LFP.LFP, HHData.Data.LFP.Spectrum},'STFT','ZScore');
    [HHData.ML.Data] = makeIntervals(HHData.Data.Normalized.Spectrum,HHData.Events.SAMPLE_RESPONSE,HHData.Data.Parameters.Choices.trialWindow,HHData.Data.Parameters.SpectrumTime);
end
    
if add_bands
    % Add Bands
    fprintf('Now Creating Band Data\n');
    HHData.Data.Bands.Signal_Bands = bandSignal(HHData.Data.Intervals.Signal,HHData.Data.Parameters.SpectrumFrequencies,HHData.Data.Parameters.SamplingFrequency);
    HHData.Data.Bands.Spectral_Bands =bandSpectrum(HHData.ML.Data,HHData.Data.Parameters.SpectrumFrequencies);
end



%% Save Data
fprintf('Now Saving ProcessedData.mat (this might take a while...)\n');
save(fullfile('C:\SuperUser\Xiwei Results',[parameters.Directories.dataName, '_processedData.mat']),'HHData','-v7.3');

% But Only Keep A Small Part
dataML.Data = HHData.ML.Data;
dataML.Channels = HHData.Channels;
dataML.Directory = parameters.Directories.filePath
clear HHData

else

%% Load Data If Created
fprintf('Loading Data Structure\n');
load(fullfile('C:\SuperUser\Xiwei Results',[parameters.Directories.dataName, '_processedData.mat']));

% But Only Keep A Small Part
dataML.Data = HHData.ML.Data;
dataML.Channels = HHData.Channels;
dataML.Directory = parameters.Directories.filePath;
clear HHData
end

%% Process Data for Classification THEN Classify
methodML = [SINGLE_CHANNEL_ANALYSIS MULTI_CHANNEL_ANALYSIS CHOICE_CHANNEL_ANALYSIS];

% Reshape Matrices
temp = dataML.Data;
dataML.Data = [];

for channels = 1:size(temp,3)
dataML.Data(:,:,channels) = reshape(permute(squeeze(temp(:,:,channels,:)),[3,2,1]),size(temp,4),size(temp,2)*size(temp,1));
end
%% Do KMeans Clustering
if K_MEANS
    
% Do Normal KMeans
if normal
[dataML] = kMeansClustering(dataML,methodML);
[F1,MCC,dominantClusters] = parseClusterAssignments(dataML, methodML);
end

% Do KMeans on PCA
if PCA
    
for channel = 1:length(dataML.Channels.sChannels)
[coeffs(:,:,channel),score(:,:,channel),~,~,explained(:,:,channel),~] = pca(dataML.Data(:,:,channel));
% plot(explained(:,:,channel));
% title(['channel = ', num2str(dataML.Channels.sChannels(channel))])
end
dataML.PCA = score(:,1:coeffs_to_retain,:);

[dataML] = kMeansClustering(dataML,methodML);
[F1_PCA,MCC_PCA,dominantClusters_PCA] = parseClusterAssignments(dataML, methodML);
end

end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    %% If More Than One Session, Just Save Structures

    
%     HHMult = HHData
%     for session = 1:length(fieldnames(HHData))
%         HHData = HHMult.(['Session',num2str(session)])
%         save(fullfile(parameters.Directories.filePath, [parameters.Directories.dataName, '_processedData_Session',num2str(session),'.mat']), 'HHData','-v7.3');
%     end
 