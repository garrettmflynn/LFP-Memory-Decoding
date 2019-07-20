%% This script is written for building data structures for recorded Human Hippocampal neural signals.
% Project: USC RAM
% Author: Xiwei She and Garrett Flynn
% Date: 2019 June 14

%% Load Correct File Specifications 
if ~other
    
if dataChoice == 1 && dataChoices(dataChoice)        

% Define data path here for extracting LFP data
parameters.Directories.filePath = strcat('E:\LFP\Data2_Recording'); %'/media/gflynn/Seagate Backup Plus Drive/LFP Decoding/ClipArt_2');
addpath(genpath(parameters.Directories.filePath));

% Choose the testing data
parameters.Directories.dataName = 'Data2_Recording003'; %'ClipArt_2';

% Agreed-Upon Parameters
parameters.Channels.sChannels = [1:6,7:10,17:22,23:26];
parameters.Channels.CA1_Channels =  [7:10,23:26]; 
parameters.Channels.CA3_Channels =  [1:6,17:22]; 

elseif dataChoice == 2 && dataChoices(dataChoice)  

% Define data path here for extracting LFP data
parameters.Directories.filePath = strcat('E:\LFP\ClipArt_2');

% Choose the testing data
parameters.Directories.dataName = 'ClipArt_2';

% Channel Parameters
parameters.Channels.sChannels = [1:10, 17:26, 33:42];
parameters.Channels.CA1_Channels = [7:10, 23:26, 39:42];
parameters.Channels.CA3_Channels = [1:6, 17:22, 33:38];
end


elseif dataChoice == 3 && dataChoices(dataChoice)  
% Define data path here for extracting LFP data
parameters.Directories.filePath = input('What is the directory containing all data? (e.g. E:\LFP\ClipArt_2)? \n Directory: ','s');
parameters.Directories.dataName = input('What is the standardized name of all data files (e.g. ClipArt_2)?\n Directory: ','s');
addpath(genpath(parameters.Directories.filePath));
parameters.Channels.sChannels = input('What channels are valid (specify as vector)\n Channel Vector: ');
parameters.Channels.CA1_Channels =  input('What channels are located in CA1 (specify as vector)?\n Channel Vector: ');
parameters.Channels.CA3_Channels =  input('What channels are located in CA3 (specify as vector)?\n Channel Vector: ');
end


if exist('parameters','var')

%% HHDataStructure Primary Section
% Processing | Binning & Windows
parameters.Optional.methods = 'Hanning'; % Either Morlet or STFT Window (such as Hanning)
parameters.Choices.freqMin = 1; % Minimum Frequency of Interest (Hz)
parameters.Choices.freqMax = 150; % Maximum Frequency of Interest (Hz)
parameters.Choices.freqBin = .5; % Frequency Bin Width (Hz)
parameters.Choices.timeBin = .1;  % Time Bin Width (s)
parameters.Choices.trialWindow = [-range range]; % Trial Interval Window
parameters.Filters.lowPass = 250; % Low Pass Filter Frequency (Hz)
parameters.Choices.downSample = 500; % Samples/s

% Load Data
% Neural Data collected from BlackRock Microsystem
neuralData = extractNSx(parameters.Directories.filePath,parameters.Directories.dataName); % Fixed for all .nsX files

% Spike and Experimental Behavioral Data collectred from DMS memory task
nexFileData = readNexFile(fullfile(parameters.Directories.filePath,[parameters.Directories.dataName, '.nex']));


if ~isstruct(neuralData)
    neuralData = load('E:\LFP\Data2_Recording\NS4.mat');
end



% Derive Certain Parameters from NSx Data
if isfield(neuralData.MetaTags,'SamplingFreq')
parameters.Derived.samplingFreq = neuralData.MetaTags.SamplingFreq;
elseif isfield(neuralData.MetaTags,'SampleRes')
    parameters.Derived.samplingFreq = neuralData.MetaTags.SampleRes;
else
    error('No Sampling Frequency Found in Neural Data Structure');
end


parameters.Filters.notchFilter = designfilt('bandstopiir','FilterOrder',2, ...
    'HalfPowerFrequency1',59,'HalfPowerFrequency2',61, ...
    'DesignMethod','butter','SampleRate',parameters.Derived.samplingFreq); % Notch Filter to Remove Powerline Noise (Hz)
parameters.Derived.freq = linspace(parameters.Choices.freqMin, parameters.Choices.freqMax, ((parameters.Choices.freqMax-parameters.Choices.freqMin)+1)/parameters.Choices.freqBin);
parameters.Derived.overlap = round((parameters.Choices.timeBin * parameters.Derived.samplingFreq)/2);
nData = neuralData.Data;

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
    parameters.Derived.durationSeconds = double(sessionPointLength/parameters.Derived.samplingFreq);
    parameters.Derived.time = linspace(0,parameters.Derived.durationSeconds,((1/parameters.Choices.timeBin)*4)-1);
    
        % Create Data Structure
        [HHData] = singlePipeline(neuralData,nexFileData,parameters);
        
        fprintf('Done\n');

end
clear neuralData
clear nexFileData

% Saves Data Structure with Exhaustive Variables
prepareForML();
end
