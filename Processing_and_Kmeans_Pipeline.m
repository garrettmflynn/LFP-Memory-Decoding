% PROCESSING_AND_KMEANS_PIPELINE uses Human Hippocampal Data Structures to Classify
% Trials (as well as create zscore and band data)

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

% Specify Save Name for HHDataStructure
fullSaveName = fullfile(parameters.Directories.filePath,[parameters.Directories.dataName, '_processedData.mat']);
mlSaveName = fullfile(parameters.Directories.filePath,[parameters.Directories.dataName, '_dataML.mat']);


%% Structure Parameters
norm = 0;
add_bands = 0;

%% Classification Parameters
SINGLE_CHANNEL_ANALYSIS = 1;
MULTI_CHANNEL_ANALYSIS = 0; 
CHOICE_CHANNEL_ANALYSIS = 0;

K_MEANS = 1;
normal = 0;
    PCA = 1;
        coeffs_to_retain = 5;


%% Create Data Structure
%  Make Sure To Tune Data Structure Parameters in loadParameters.m
if ~exist(fullSaveName,'file')
HHDataStructure();
    
%% Process Data
    
% Extract Intervals Around SAMPLE_RESPONSE
[HHData.ML.Data, HHData.ML.Times] = makeIntervals(HHData.Data.LFP.Spectrum,HHData.Events.SAMPLE_RESPONSE,HHData.Data.Parameters.Choices.trialWindow,HHData.Data.Parameters.SpectrumTime);
[HHData.Data.Intervals.Signal,~] = makeIntervals(HHData.Data.LFP.LFP,HHData.Events.SAMPLE_RESPONSE,HHData.Data.Parameters.Choices.trialWindow,HHData.Data.Parameters.SamplingFrequency); 


if norm
    % Do Normalization
    HHData.Data.Normalized = normalize({HHData.Data.LFP.LFP, HHData.Data.LFP.Spectrum},'STFT','ZScore');
    [HHData.ML.Data] = makeIntervals(HHData.Data.Normalized.Spectrum,HHData.Events.SAMPLE_RESPONSE,HHData.Data.Parameters.Choices.trialWindow,HHData.Data.Parameters.SpectrumTime);
end

% % % Visualize Quickly
%   for interval = 1:size(HHData.ML.Data,ndims(HHData.ML.Data))
%       for channel = [7,18,38] %1:size(HHData.RawData,1)
%               standardImage(HHData.ML.Data(:,:,(HHData.Channels.sChannels == channel),interval),HHData.Events,HHData.Data.Parameters, HHData.Data.Parameters.Choices.downSample, ['Spectrum_Interval' ,num2str(interval)], channel,interval,HHData.ML.Times(:,interval),'Zscore', [-10 10], fullfile(parameters.Directories.filePath,'All Intervals',['Channel',num2str(channel)]), 'Spectrum',0);
%      end
% end
    
if add_bands
    % Add Bands
    fprintf('Now Creating Band Data\n');
    
    % Whole Session
%     HHData.Data.Bands.Signal_Bands = bandSignal(HHData.Data.LFP.LFP,HHData.Data.Parameters.SpectrumFrequencies,HHData.Data.Parameters.SamplingFrequency);
%     HHData.Data.Bands.Spectral_Bands =bandSpectrum(HHData.ML.Data,HHData.Data.Parameters.SpectrumFrequencies);
    
    % Intervals Only
    HHData.Data.Bands.Signal_Bands = bandSignal(HHData.Data.Intervals.Signal,HHData.Data.Parameters.SpectrumFrequencies,HHData.Data.Parameters.SamplingFrequency);
    HHData.Data.Bands.Spectral_Bands =bandSpectrum(HHData.ML.Data,HHData.Data.Parameters.SpectrumFrequencies);
end



%% Save Data
fprintf('Now Saving ProcessedData.mat (this might take a while...)\n');
save(fullSaveName,'HHData','-v7.3');

% But Only Keep A Small Part
dataML.Data = HHData.ML.Data;
dataML.Channels = HHData.Channels;
dataML.Directory = parameters.Directories.filePath
dataML.Labels = HHData.Labels;
clear HHData

else

%% Load Data If Created
fprintf('Loading Data Structure\n');
load(fullSaveName);

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

% Concatenate Channels for MCA and CCA
if methodML(2)
    MCAMatrix = []
        for channels = CCAChoices
        MCAMatrix = [MCAMatrix dataML.Data(:,:,channels)];
        end
        dataML.Data = MCAMatrix;
end

save(mlSaveName,'dataML','-v7.3');
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    %% If More Than One Session, Just Save Structures

    
%     HHMult = HHData
%     for session = 1:length(fieldnames(HHData))
%         HHData = HHMult.(['Session',num2str(session)])
%         save(fullfile(parameters.Directories.filePath, [parameters.Directories.dataName, '_processedData_Session',num2str(session),'.mat']), 'HHData','-v7.3');
%     end
 