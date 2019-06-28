% CLASSIFICATIONPIPELINE uses Human Hippocampal Data Structures to Classify
% Related Trials using LFP
clear; clc; close all;

%% Data Paths
addpath(genpath('E:\NPMK'));
addpath(genpath('E:\Standardized_LFP_Code\Back End\nexManipulation'));
addpath(genpath('C:\SuperUser\Documents\GitHub\LFP-Memory-Decoding'));

% Define data path here for extracting LFP data
parameters.Directories.filePath = strcat('E:\ClipArt_2');

% Choose the testing data
parameters.Directories.dataName = 'ClipArt_2';

%% Create Data Structure
%  Make Sure To Tune Data Structure Parameters in loadParameters.m
if ~exist(fullfile('C:\SuperUser\Xiwei Results',[parameters.Directories.dataName, '_processedData.mat']),'file')
HHDataStructure();
fprintf('Now Saving ProcessedData.mat (this might take a while...)\n');
save(fullfile('C:\SuperUser\Xiwei Results',[parameters.Directories.dataName, '_processedData.mat']),'HHData','-v7.3');
else

fprintf('Loading Data Structure\n');
load(fullfile('C:\SuperUser\Xiwei Results',[parameters.Directories.dataName, '_processedData.mat']));
end

 
% The Rest Only Works with Single Session Files
if ~exist('HHDataMultiple','var')
    %% Extract Intervals Around SAMPLE_RESPONSE
    [HHData.Data.Intervals.Spectrum, HHData.Data.Intervals.Times] = makeIntervals(HHData.Data.LFP.Spectrum,HHData.Events.SAMPLE_RESPONSE,HHData.Data.Parameters.Choices.trialWindow,HHData.Data.Parameters.Choices.downSample); % HHData.SamplingFrequency);
    
    
    for interval = [26,32,40] %1:size(HHData.Intervals.Data,ndims(HHData.Intervals.Data))
    for channel = [7,38] %1:size(HHData.RawData,1)
            standardImage(HHData.Data.Intervals.Spectrum(:,:,(HHData.Channels.sChannels == channel),interval),HHData.Events,HHData.Data.Parameters, HHData.Data.Parameters.Choices.downSample, ['Spectrum_Interval' ,num2str(interval)], channel,interval,HHData.Data.Intervals.Times(:,interval),'dB', [-100 100], fullfile(parameters.Directories.filePath,'Intervals',['Channel',num2str(channel)]), 'Spectrum',1);
    end
    end
    
    %% Process Data
    % Do Normalization
    HHData.Data.Normalized = normalize({HHData.Data.LFP.LFP, HHData.Data.LFP.Spectrum},'Morlet','dB');
    [HHData.Data.Intervals.Normalized, HHData.Data.Intervals.Times] = makeIntervals(HHData.Data.Normalized.Spectrum,HHData.Events.SAMPLE_RESPONSE,HHData.Data.Parameters.Choices.trialWindow,HHData.Data.Parameters.Choices.downSample); % HHData.SamplingFrequency);
    
    
    for interval = [26,32,40] %1:size(HHData.Intervals.Data,ndims(HHData.Intervals.Data))
    for channel = [7,38] %1:size(HHData.RawData,1)
            standardImage(HHData.Data.Intervals.Normalized(:,:,(HHData.Channels.sChannels == channel),interval),HHData.Events,HHData.Data.Parameters, HHData.Data.Parameters.Choices.downSample, ['Spectrum_Interval' ,num2str(interval)], channel,interval,HHData.Data.Intervals.Times(:,interval),'dB', [-100 100], fullfile(parameters.Directories.filePath,'NormIntervals',['Channel',num2str(channel)]), 'Spectrum',0);
    end
    end

    % Add Bands
    fprintf('Now Creating Band Data\n');
    Signal_Bands = bandSignal(HHData.Data.LFP.LFP,HHData.Data.Parameters.SpectrumFrequencies,HHData.Data.Parameters.SamplingFrequency);
    Spectral_Bands =bandSpectrum(HHData.Data.Intervals.Normalized,HHData.Data.Parameters.SpectrumFrequencies);
    
    % Do PCA
    
    %% Classify Data
    
    
    
    %timeForSpectra = linspace(HHData.start,HHData.end,length(HHData.LFP.Downsampled))
    %freq = linspace(HHData.Parameters.Choices.freqMin,HHData.Parameters.Choices.freqMax,size(spectralData,1));
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    %% If More Than One Session, Just Save Structures
else
    
    HHMult = HHData
    for session = 1:length(fieldnames(HHData))
        HHData = HHMult.(['Session',num2str(session)])
        save(fullfile(parameters.Directories.filePath, [parameters.Directories.dataName, '_processedData_Session',num2str(session),'.mat']), 'HHData','-v7.3');
    end
end