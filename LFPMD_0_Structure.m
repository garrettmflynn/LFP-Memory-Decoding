
%% Create HHData Structure
% This script is written for building data structures for recorded Human Hippocampal neural signals.

                                                                            % Project: USC RAM
                                                                            % Author: Xiwei She and Garrett Flynn
                                                                            % Date: 2019 June 14

%% Load Correct File Specifications 

if strcmp(dataChoices{chosenData},'Other')
    
% Define data path here for extracting LFP data
parameters.Directories.filePath = input('What is the directory containing all data? (e.g. E:\LFP\ClipArt_2)? \n Directory: ','s');
parameters.Directories.dataName = input('What is the standardized name of all data files (e.g. ClipArt_2)?\n Directory: ','s');
addpath(genpath(parameters.Directories.filePath));
parameters.Channels.sChannels = input('What channels are valid (specify as vector)\n Channel Vector: ');
parameters.Channels.CA1_Channels =  input('What channels are located in CA1 (specify as vector)?\n Channel Vector: ');
parameters.Channels.CA3_Channels =  input('What channels are located in CA3 (specify as vector)?\n Channel Vector: ');
parameters.isHuman = input('Is this session a human? Yes (1) or No (0)?\n Answer: ');
else
    
if strcmp(dataChoices{chosenData},'Keck08')

% Define data path here for extracting LFP data
parameters.Directories.filePath = strcat('G:\LFP Decoding\Keck08'); %('E:\LFP\Data2_Recording'); %'/media/gflynn/Seagate Backup Plus Drive/LFP Decoding/ClipArt_2');
addpath(genpath(parameters.Directories.filePath));

% Choose the testing data
parameters.Directories.dataName = 'Keck08'; 

% Agreed-Upon Parameters
parameters.Channels.sChannels = [1:6,7:10,17:22,23:26];
parameters.Channels.CA1_Channels =  [7:10,23:26]; 
parameters.Channels.CA3_Channels =  [1:6,17:22]; 

parameters.isHuman = 1;

elseif strcmp(dataChoices{chosenData},'Rancho03')

% Define data path here for extracting LFP data
parameters.Directories.filePath = strcat('G:\LFP Decoding\Rancho03'); %('E:\LFP\Data2_Recording'); %'/media/gflynn/Seagate Backup Plus Drive/LFP Decoding/ClipArt_2');
addpath(genpath(parameters.Directories.filePath));

% Choose the testing data
parameters.Directories.dataName = 'Rancho03'; %'ClipArt_2';

% Agreed-Upon Parameters
parameters.Channels.sChannels = [1:6,7:10,17:22,23:26];
parameters.Channels.CA1_Channels =  [7:10,23:26]; 
parameters.Channels.CA3_Channels =  [1:6,17:22]; 

parameters.isHuman = 1;

elseif strcmp(dataChoices{chosenData},'WFU18')

% Define data path here for extracting LFP data
parameters.Directories.filePath = strcat('G:\LFP Decoding\WFU18'); 
addpath(genpath(parameters.Directories.filePath));

% Choose the testing data
parameters.Directories.dataName = 'WFU18'; %'ClipArt_2';

% Agreed-Upon Parameters
parameters.Channels.sChannels = [1:6,7:10,17:22,23:26];
parameters.Channels.CA1_Channels =  [7:10,23:26]; 
parameters.Channels.CA3_Channels =  [1:6,17:22]; 

parameters.isHuman = 1;
    
elseif strcmp(dataChoices{chosenData},'WFU26')

% Define data path here for extracting LFP data
parameters.Directories.filePath = strcat('G:\LFP Decoding\WFU26'); 
addpath(genpath(parameters.Directories.filePath));

% Choose the testing data
parameters.Directories.dataName = 'WFU26'; %'ClipArt_2';

% Agreed-Upon Parameters
parameters.Channels.sChannels = [1:6,7:10,17:22,23:26];
parameters.Channels.CA1_Channels =  [7:10,23:26]; 
parameters.Channels.CA3_Channels =  [1:6,17:22]; 

parameters.isHuman = 1;

elseif strcmp(dataChoices{chosenData},'Recording003')

% Define data path here for extracting LFP data
parameters.Directories.filePath = strcat('G:\LFP Decoding\Data2_Recording'); %('E:\LFP\Data2_Recording'); %'/media/gflynn/Seagate Backup Plus Drive/LFP Decoding/ClipArt_2');
addpath(genpath(parameters.Directories.filePath));

% Choose the testing data
parameters.Directories.dataName = 'Data2_Recording003'; %'ClipArt_2';

% Agreed-Upon Parameters
parameters.Channels.sChannels = [1:6,7:10,17:22,23:26];
parameters.Channels.CA1_Channels =  [7:10,23:26]; 
parameters.Channels.CA3_Channels =  [1:6,17:22]; 

parameters.isHuman = 1;

elseif strcmp(dataChoices{chosenData},'ClipArt2')

% Define data path here for extracting LFP data
parameters.Directories.filePath = strcat('G:\LFP Decoding\ClipArt_2');

% Choose the testing data
parameters.Directories.dataName = 'ClipArt_2';

% Channel Parameters
parameters.Channels.sChannels = [1:10, 17:26, 33:42];
parameters.Channels.CA1_Channels =  [7:10, 23:26, 39:42];
parameters.Channels.CA3_Channels =  [1:6, 17:22, 33:38];

parameters.isHuman = 1;
elseif strcmp(dataChoices{chosenData},'Rat_Data')
    
    % Define data path here for extracting LFP data
parameters.Directories.filePath = strcat('G:\LFP Decoding\Rat_Data');

% Choose the testing data
parameters.Directories.dataName = 'Rat_Data';

parameters.isHuman = 0;

elseif strcmp(dataChoices{chosenData},'Rat2')
    
    % Define data path here for extracting LFP data
parameters.Directories.filePath = strcat('G:\LFP Decoding\Rat2');

% Choose the testing data
parameters.Directories.dataName = 'Rat2';

parameters.isHuman = 0;

elseif strcmp(dataChoices{chosenData},'Validation_Data')
    
% Define data path here for extracting LFP data
parameters.Directories.filePath = strcat('C:\Users\flynn\Documents\Downloads\multielectrode_grasp\datasets');

% Choose the testing data
parameters.Directories.dataName = 'i140703-001';

% Channel Parameters
parameters.Channels.sChannels = [1:3];

parameters.isHuman = 1;
end
end

if exist('parameters','var')
%% HHDataStructure Primary Section
% Processing | Binning & Windows
parameters.Optional.methods = tf_method{1}; % Either Morlet or STFT Window (such as Hanning)
parameters.Choices.freqMin = band_low; % Minimum Frequency of Interest (Hz)
parameters.Choices.freqMax = 150; % Maximum Frequency of Interest (Hz)
parameters.Choices.freqBin = fB(1); % Frequency Bin Width (Hz)
parameters.Choices.trialWindow = [-range range]; % Trial Interval Window
parameters.Filters.LFPFilter = [band_low band_high]; % Low Pass Filter Frequency (Hz)
parameters.Choices.downSample = downSample; % Samples/s

parameters.Choices.bandAveragedPower = bandAveragedPower;
parameters.Choices.reduceChannels = reduceChannels;

% Quick Debug Shortcuts
if quickDebug
parameters.Channels.CA1_Channels = [parameters.Channels.CA1_Channels(1) parameters.Channels.CA1_Channels(end)];
parameters.Channels.CA3_Channels = [parameters.Channels.CA3_Channels(1) parameters.Channels.CA3_Channels(end)];
parameters.Channels.sChannels = [parameters.Channels.CA3_Channels parameters.Channels.CA1_Channels];
parameters.Channels.quickDebug = 1;
else
parameters.Channels.quickDebug = 0;
end

% Load Data
if parameters.isHuman
% Neural Data collected from BlackRock Microsystem
neuralData = extractNSx(parameters.Directories.filePath,parameters.Directories.dataName); % Fixed for all .nsX files
% Spike and Experimental Behavioral Data collectred from DMS memory task
nexFileData = readNexFile(fullfile(parameters.Directories.filePath,[parameters.Directories.dataName, '.nex']));
else
nexFileData = readNexFile(fullfile(parameters.Directories.filePath,[parameters.Directories.dataName, '.nex']));
[neuralData,nexFileData] = replaceHumanWithRat(nexFileData);
parameters.Channels.sChannels = 1:neuralData.MetaTags.ChannelCount
parameters.Times.(centerEvent) = [1:2:neuralData.MetaTags.DataDurationSec-1]
end



% Catch Odd Formats
if ~isstruct(neuralData)
    neuralData = load('C:\Users\flynn\OneDrive - University of Southern California\Office\LFP Decoding\Data2_Recording\NS4.mat');
end



% Derive Certain Parameters from NSx Data
if isfield(neuralData.MetaTags,'SamplingFreq')
parameters.Derived.samplingFreq = neuralData.MetaTags.SamplingFreq;
elseif isfield(neuralData.MetaTags,'SampleRes')
    parameters.Derived.samplingFreq = neuralData.MetaTags.SampleRes;
else
    error('No Sampling Frequency Found in Neural Data Structure');
end

parameters.Choices.timeBin = .1;  % Time Bin Width (s) is hardcoded for 100ms
fprintf('Time Bin Width is hardcoded as 100ms');

if notchOn
parameters.Filters.notchFilter = designfilt('bandstopiir','FilterOrder',2, ...
    'HalfPowerFrequency1',59,'HalfPowerFrequency2',61, ...
    'DesignMethod','butter','SampleRate',parameters.Derived.samplingFreq); % Notch Filter to Remove Powerline Noise (Hz)
end

parameters.Derived.freq = parameters.Choices.freqMin:parameters.Choices.freqBin:parameters.Choices.freqMax;
%parameters.Derived.overlap = round((parameters.Choices.timeBin * parameters.Derived.samplingFreq))%/1.5);

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
        clear nexFileData
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
end

%% Pipeline One: Single Data Session
function [HHData] = singlePipeline(neuralData,nexFileData,parameters,sessionLoop)

%% Spike Data AND Behavior Timepoints

fprintf('Now Processing Spikes\n');
parameters = humanDataSpikeProcessing(nexFileData,parameters);


    % Initialization
    HHData = struct;
    nData = neuralData.Data;
    if isfield(neuralData.MetaTags,'DateTime')
    HHData.RecordTime = neuralData.MetaTags.DateTime; % Recording Date
    else
         HHData.RecordTime = 'Unspecified';
         fprintf('Record Data & Time is Unspecified\n');
    end
    clear neuralData

%% Raw data
if nargin == 4
RawData = double(nData{1,sessionLoop}(parameters.Channels.sChannels, :));
else
RawData = double(nData(parameters.Channels.sChannels, :));
end
clear nData

%% Convert Raw Data from uV to V 
RawData = RawData/(10^6);

%% LFP Data
fprintf('Now Extracting LFP\n');
LFP_Data = extractLFP(RawData,parameters);

% Raw Voltage Information
HHData.Data.Voltage = struct;
HHData.Data.Voltage.Raw = RawData;
clear RawData

% LFP Data information
HHData.Data.LFP = struct;
HHData.Data.LFP.LFP = LFP_Data;

if ~isempty(parameters.Choices.downSample)
HHData.Data.LFP.Sampled = LFP_Data(:,1:parameters.Derived.samplingFreq/parameters.Choices.downSample:end); % Downsampled to 500 S/s
end
clear LFP_Data

% 3. Create spectrograms for full session
fprintf('Now Creating Spectrograms\n');

% Morlet using Sampled LFP
if strncmp(parameters.Optional.methods,'Morlet',4) 
[LFP_Spectrum, time, freq] = makeWavelet(HHData.Data.LFP.LFP,parameters);
HHData.Data.LFP.Spectrum = LFP_Spectrum;
clear LFP_Spectrum

% Or STFT
else 
[LFP_Spectrum, time, freq] = makeSpectrum(HHData.Data.LFP.LFP,parameters);

% Save LFP Data information
HHData.Data.LFP.Spectrum = LFP_Spectrum;
clear LFP_Spectrum
end

%% Save Parameters

% Recording information
HHData.Session = parameters.Directories.dataName;

% Experimental Behavioral Information
HHData.Events = struct;
timeFields = fieldnames(parameters.Times);
for iFields = 1:length(timeFields)
field = timeFields{iFields};
HHData.Events.(field) = parameters.Times.(field);
end

% Channel mapping information
HHData.Channels = struct; % Channels information
HHData.Channels.sChannels = parameters.Channels.sChannels;

if parameters.isHuman
HHData.Channels.CA1_Channels = parameters.Channels.CA1_Channels;
HHData.Channels.CA3_Channels = parameters.Channels.CA3_Channels;

% Session/Trials information
HHData.Data.Timecourse = [parameters.Times.FOCUS_ON(1) max(parameters.Times.MATCH_RESPONSE)]; % Session start & end (in seconds)

% Spike Data information
HHData.Data.Spikes = parameters.Neuron; % Original Neuron Spike Data

% Interval Information
HHData.Data.Intervals = struct; 
for ii = 1:length(parameters.Times.MATCH_RESPONSE)
HHData.Data.Intervals.Outcome(ii) = ismember(round(parameters.Times.MATCH_RESPONSE(ii)),round(parameters.Times.CORRECT_RESPONSE));
end

else
HHData.Channels.CA1_Channels = [];
HHData.Channels.CA3_Channels = [];
HHData.Data.Timecourse = [0 size(HHData.Data.Voltage.Raw,2)/parameters.Derived.samplingFreq]; % Session start & end (in seconds)
HHData.Data.Spikes = []; % Original Neuron Spike Data
end 


if exist(fullfile(parameters.Directories.filePath,[parameters.Directories.dataName,'_labels.mat']),'file')
    HHData.Labels = load(fullfile(parameters.Directories.filePath,[parameters.Directories.dataName,'_labels.mat']));
end

% Just In Case This Might Want to Be Referenced
parametersTrans.Choices = parameters.Choices;
HHData.Session = parameters.Directories.dataName;
parametersTrans.SamplingFrequency = parameters.Derived.samplingFreq;
parametersTrans.SpectrumFrequencies = freq;
parametersTrans.SpectrumTime = time;
HHData.Data.Parameters = parametersTrans;



end

%% Extract NSx
function [neuralData] = extractNSx(filePath, dataName)
% Extracts data from native Blackrock .NSx files

% First Try
NSxPattern = fullfile(filePath, [dataName, '.ns*']);
NSxMatch = dir(NSxPattern);
if ~isempty(NSxMatch)
NSxName = NSxMatch.name;
NSxDir = fullfile(filePath, NSxName);
neuralData = openNSx(NSxDir);
else
fprintf('NEV File Found (only spike waveforms will be loaded.');
NSxPattern = fullfile(filePath, [dataName, '.nev']);
NSxMatch = dir(NSxPattern);
NSxName = NSxMatch.name;
if ~isempty(NSxMatch)
    NSxDir = fullfile(filePath, NSxName);
neuralData = openNEV(NSxDir);
else
    error('No Blackrock Data File Found');
end
end
end

%% Human Data Spike Processing
function [parameters] = humanDataSpikeProcessing(nexFileData,parameters)


% This file is used to extract data information from patients nex or nex5
% data can save them into mat file for Memory Decoding Project
% Written By Xiwei She - 02/08/2017
% Modified By Garrett Flynn - 06/14/19

% DIO_00001 SESSION_START
% DIO_00002 ITI_ON
% DIO_00004 FOCUS_ON
% DIO_00008 SAMPLE_ON
% DIO_00016 SAMPLE_RESPONSE
% DIO_00032 MATCH_ON
% DIO_00064 MATCH_RESPONSE
% DIO_00128 CORRECT_RESPONSE
% DIO_00256 END_SESSION

%% Extract Information - Change according to different patient
% For Events TimeStamps
for i = 1:length(nexFileData.events)
    if strcmp(nexFileData.events{i,1}.name, 'DIO_00002') || strcmp(nexFileData.events{i,1}.name, 'DIO_65533') % ITI_ON
        parameters.Times.ITI_ON = nexFileData.events{i,1}.timestamps;
    elseif strcmp(nexFileData.events{i,1}.name, 'DIO_00004') || strcmp(nexFileData.events{i,1}.name, 'DIO_65531') % FOCUS_ON
        parameters.Times.FOCUS_ON = nexFileData.events{i,1}.timestamps;
        parameters.Times.FOCUS_ON = [0; parameters.Times.FOCUS_ON(1:(end-1))]; % Shift and remove the last focus ring
    elseif strcmp(nexFileData.events{i,1}.name, 'DIO_00008') || strcmp(nexFileData.events{i,1}.name, 'DIO_65527') % SAMPLE_ON
       parameters.Times.SAMPLE_ON = nexFileData.events{i,1}.timestamps;
    elseif strcmp(nexFileData.events{i,1}.name, 'DIO_00016') || strcmp(nexFileData.events{i,1}.name, 'DIO_65519') % SAMPLE_RESPONSE
        parameters.Times.SAMPLE_RESPONSE = nexFileData.events{i,1}.timestamps;
    elseif strcmp(nexFileData.events{i,1}.name, 'DIO_00032') || strcmp(nexFileData.events{i,1}.name, 'DIO_65503') % MATCH_ON
        parameters.Times.MATCH_ON = nexFileData.events{i,1}.timestamps;
    elseif strcmp(nexFileData.events{i,1}.name, 'DIO_00064') || strcmp(nexFileData.events{i,1}.name, 'DIO_65471') % MATCH_RESPONSE
        parameters.Times.MATCH_RESPONSE = nexFileData.events{i,1}.timestamps;
    elseif strcmp(nexFileData.events{i,1}.name, 'DIO_00128') || strcmp(nexFileData.events{i,1}.name, 'DIO_65407') % END_SESSION
        parameters.Times.END_SESSION = nexFileData.events{i,1}.timestamps;
    elseif strcmp(nexFileData.events{i,1}.name, 'DIO_00256') || strcmp(nexFileData.events{i,1}.name, 'DIO_65279') % CORRECT_RESPONSE    
        parameters.Times.CORRECT_RESPONSE = nexFileData.events{i,1}.timestamps;
    elseif strcmp(nexFileData.events{i,1}.name, 'DIO_Changed') % DIO_Changed 
        parameters.Times.DIO_Changed = nexFileData.events{i,1}.timestamps;
    end
    
end

% For Neurons TimeStamps
if isfield(nexFileData,'neurons')
    
%     for jj = 1:length(nexFileData.neurons)
%     NameStr = nexFileData.neurons{jj,1}.name;
%     parameters.Neuron = nexFileData.neurons{jj,1};
    
else
for i = 1:length(nexFileData.events)
    NameStr = nexFileData.events{i,1}.name;
    if strcmp(NameStr(1:2), 'nr') && (NameStr(end) ~= '0') % Make sure those are REAL neurons
        channelNum = str2double(NameStr(4:6));
        if ismember(channelNum, parameters.Channels.CA1_Channels)
            parameters.Neuron.(['CA1_', NameStr]) = nexFileData.events{i,1}.timestamps;
        elseif ismember(channelNum, parameters.Channels.CA3_Channels)
            parameters.Neuron.(['CA3_', NameStr]) = nexFileData.events{i,1}.timestamps;
        end
    end
end
end
end

%% Extract LFP
function LFP = extractLFP(rawData, parameters)
% This file is used to extract LFP from raw NSx recordings

notchOn = isfield(parameters.Filters,'notchFilter');


LFPFilter = parameters.Filters.LFPFilter;

if notchOn
filterNotch = parameters.Filters.notchFilter;
end

% IF ONE SESSION IN THE FILE
if (size(rawData,2) > 5)
    % Fill Arrays with Data
    toProcess = (double(rawData))';
    clear rawData
    
    processedData = bandpass(toProcess,LFPFilter,parameters.Derived.samplingFreq);
        clear toProcess
        
    if notchOn    
    for ii = 1:size(processedData,2)
    % Added Notch Filter to get rid of line noise
    LFP(:,ii) = filtfilt(filterNotch,processedData(:,ii));
    end
    
    else
        
        LFP = processedData;
    end
    
% IF MANY SESSIONS IN THE FILE
elseif ~(size(rawData,2) > 5)
    % Process initial session
    toProcess = (double(rawData))';
    rawData{1,1} = [];
    processedData = bandpass(toProcess,LFPFilter,parameters.Derived.samplingFreq);
    clear toProcess
    
    if notchOn
    
        for ii = 1:size(processedData,2)
    LFP(:,ii) = filtfilt(filterNotch,processedData(:,ii));
        end
    
    else
        
        LFP = processedData
    end
    
    % Process subsequent sessions & append to initial array
    for i = 2:size(rawData,2)
        tempData = double(rawData{1,i})';
        rawData{1,i} = [];
        tempData = bandpass(tempData,LFPFilter,parameters.Derived.samplingFreq);
        
        if notchOn
            for ii = 1:size(processedData,2)
    tempDataEnd(:,ii) = filtfilt(filterNotch,tempData(:,ii));
            end
            
        else
            tempDataEnd = tempData;
        end
        
        LFP = [LFP; tempDataEnd];
    end    
end

LFP = LFP';
end

%% Make Spectrum
function [spectrum,time,freq] = makeSpectrum(inputData,parameters)

freq = parameters.Derived.freq;
winSize = parameters.Choices.timeBin * parameters.Derived.samplingFreq;
%overlap = (parameters.Derived.overlap);

numChannels = size(inputData,1);

for channels = 1:numChannels
    % Hanning Window
            [~,~,t, PSDs, ~, ~] = spectrogram(inputData(1,:)*10^6,hann(winSize),[],freq, parameters.Derived.samplingFreq,'yaxis');
            % PSDs in (uV^2)/Hz
            spectrum(:,:,channels) = PSDs;
            clear PSDs
            if channels == 1 
                if (t(1) ~= 0)
                    t = t - t(1);
                end
            time = t;
            end
            clear t
            
inputData = inputData(2:end,:);
end

end

%% Make Wavelet
function [spectrum,time,freq] = makeWavelet(inputData,parameters)

freq = parameters.Derived.freq;
numChannels = size(inputData,1);

for channels = 1:numChannels
    fprintf('Calculating Morlet Wavelets')
    toProcess = inputData(1,:);
            [cfs,freq] = cwt(toProcess,'amor',parameters.Derived.samplingFreq);
            tmp1 = abs(cfs); % Convert to real numbers
            t = 0:length(toProcess)-1;
            spectrum(:,:,channels) = 10*log10(tmp1);
            if channels == 1  
            time = linspace(0,(length(inputData)-1)/parameters.Derived.samplingFreq,length(tmp1));
            end
            clear tmp1
            clear t
            
inputData = inputData(2:end,:);
end

end


%% Replace Human with Rat
function [neuralData,nexFileData] = replaceHumanWithRat(nexFileData)


%% Create Artificial Neural Data Structure
neuralData = struct();

% Channels
neuralData.MetaTags.ChannelCount = size(nexFileData.contvars,1);

% Sampling
realSampling = nexFileData.freq;
downSample = 2000; % Hardcoded downsample frequency
sRatio = downSample/realSampling;
sIter = realSampling/downSample;


neuralData.MetaTags.SamplingFreq = downSample;


% Data
neuralData.MetaTags.DataPoints = size(nexFileData.contvars{neuralData.MetaTags.ChannelCount, 1}.data,1)*sRatio;

neuralData.MetaTags.DataDurationSec = neuralData.MetaTags.DataPoints/neuralData.MetaTags.SamplingFreq;
neuralData.MetaTags.DataPointsSec = neuralData.MetaTags.DataDurationSec;

neuralData.Data = zeros(neuralData.MetaTags.ChannelCount,neuralData.MetaTags.DataPoints);

for ii = 1:neuralData.MetaTags.ChannelCount
    neuralData.Data(ii,:) = nexFileData.contvars{ii, 1}.data(1:sIter:end);
end

% Remove ContVars
nexFileData.contvars = [];
end




