%% This script is written for building data structures for recorded Human Hippocampal neural signals.
% Project: USC RAM
% Author: Xiwei She and Garrett Flynn
% Date: 2019 June 14

%% Agreed-Upon Parameters
parameters.Channels.sChannels = [1:10, 17:26, 33:42];
parameters.Channels.CA1_Channels = [7:10, 23:26, 39:42];
parameters.Channels.CA3_Channels = [1:6, 17:22, 33:38];

% The channel mapping is as below:
% 1-6 was implanted in LEFT CA3 Anterior, in which channel #1-3 were in the same depth and #4-6 in another depth. 
% 7-10 was implanted in LEFT CA1 Anterior, in which channel #7-8 were in the same depth and #9-10 in another depth.
% 17-22 was implanted in RIGHT CA3 Anterior, in which channel #17-19 were in the same depth and #20-22 in another depth.
% 23-26  was implanted in RIGHT CA1 Anterior, in which channel #23-24 were in the same depth and #25-26 in another depth.
% 33-38  was implanted in RIGHT CA3 Posterior, in which channel #33-35 were in the same depth and #36-38 in another depth.

% Processing | Binning & Windows
parameters.Optional.methods = 'Hanning'; % Either Morlet or STFT Window (such as Hanning)
parameters.Choices.freqMin = 1; % Minimum Frequency of Interest (Hz)
parameters.Choices.freqMax = 150; % Maximum Frequency of Interest (Hz)
parameters.Choices.freqBin = .5; % Frequency Bin Width (Hz)
parameters.Choices.timeBin = .1;  % Time Bin Width (s)
parameters.Choices.trialWindow = [-1 1]; % Trial Interval Window
parameters.Filters.lowPass = 250; % Low Pass Filter Frequency (Hz)
parameters.Choices.downSample = 500; % Samples/s

%% Load Data
% Neural Data collected from BlackRock Microsystem
neuralData = extractNSx(parameters.Directories.filePath,parameters.Directories.dataName); % Fixed for all .nsX files

% Spike and Experimental Behavioral Data collectred from DMS memory task
nexFileData = readNexFile(fullfile(parameters.Directories.filePath,[parameters.Directories.dataName, '.nex']));


%% Derive Certain Parameters from NSx Data

parameters.Derived.samplingFreq = neuralData.MetaTags.SamplingFreq;

parameters.Filters.notchFilter = designfilt('bandstopiir','FilterOrder',2, ...
    'HalfPowerFrequency1',59,'HalfPowerFrequency2',61, ...
    'DesignMethod','butter','SampleRate',neuralData.MetaTags.SamplingFreq); % Notch Filter to Remove Powerline Noise (Hz)
parameters.Derived.freq = linspace(parameters.Choices.freqMin, parameters.Choices.freqMax, ((parameters.Choices.freqMax-parameters.Choices.freqMin)+1)/parameters.Choices.freqBin);
parameters.Derived.overlap = round((parameters.Choices.timeBin * parameters.Derived.samplingFreq)/2);

%% (1) Multi-Session Configuration
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

%% (2) Single-Session Configuration
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
