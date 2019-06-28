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

norm = 1;
add_bands = 0;
PCA = 0;

SINGLE_CHANNEL_ANALYSIS = 1;
MULTI_CHANNEL_ANALYSIS = 0; 
CHOICE_CHANNEL_ANALYSIS = 0;

K_MEANS = 1;


%% Create Data Structure
%  Make Sure To Tune Data Structure Parameters in loadParameters.m
if ~exist(fullfile('C:\SuperUser\Xiwei Results',[parameters.Directories.dataName, '_processedData.mat']),'file')
HHDataStructure();
    
    %% Process Data
    
    % Extract Intervals Around SAMPLE_RESPONSE
[HHData.ML.Data, HHData.ML.Times] = makeIntervals(HHData.Data.LFP.Spectrum,HHData.Events.SAMPLE_RESPONSE,HHData.Data.Parameters.Choices.trialWindow,HHData.Data.Parameters.SpectrumTime); 

if norm
    % Do Normalization
    HHData.Data.Normalized = normalize({HHData.Data.LFP.LFP, HHData.Data.LFP.Spectrum},'STFT','ZScore');
    [HHData.ML.Data] = makeIntervals(HHData.Data.Normalized.Spectrum,HHData.Events.SAMPLE_RESPONSE,HHData.Data.Parameters.Choices.trialWindow,HHData.Data.Parameters.SpectrumTime);
end
    
    
    
    
if add_bands
    % Add Bands
    fprintf('Now Creating Band Data\n');
    HHData.Data.Bands.Signal_Bands = bandSignal(HHData.Data.LFP.LFP,HHData.Data.Parameters.SpectrumFrequencies,HHData.Data.Parameters.SamplingFrequency);
    HHData.Data.Bands.Spectral_Bands =bandSpectrum(HHData.Data.Intervals.Normalized,HHData.Data.Parameters.SpectrumFrequencies);
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
dataML.Directory = parameters.Directories.filePath
clear HHData
end

%% Process Data for Classification THEN Classify
% Reshape Matrices
temp = dataML.Data;
dataML.Data = [];

for channels = 1:size(temp,3)
dataML.Data(:,:,channels) = reshape(permute(squeeze(temp(:,:,channels,:)),[3,2,1]),size(temp,4),size(temp,2)*size(temp,1));
end

if PCA
% Do PCA (not yet)


end

methodML = [SINGLE_CHANNEL_ANALYSIS MULTI_CHANNEL_ANALYSIS CHOICE_CHANNEL_ANALYSIS];
    
    if K_MEANS
    % Do KMeans Clustering
    [dataML] = kMeansClustering(dataML,methodML);
    end


    
    
    %timeForSpectra = linspace(HHData.start,HHData.end,length(HHData.LFP.Downsampled))
    %freq = linspace(HHData.Parameters.Choices.freqMin,HHData.Parameters.Choices.freqMax,size(spectralData,1));
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    %% If More Than One Session, Just Save Structures

    
%     HHMult = HHData
%     for session = 1:length(fieldnames(HHData))
%         HHData = HHMult.(['Session',num2str(session)])
%         save(fullfile(parameters.Directories.filePath, [parameters.Directories.dataName, '_processedData_Session',num2str(session),'.mat']), 'HHData','-v7.3');
%     end
 