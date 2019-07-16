function [HHData] = singlePipeline(neuralData,nexFileData,parameters,sessionLoop)

%% Spike Data AND Behavior Timepoints

fprintf('Now Processing Spikes\n');
parameters = humanDataSpikeProcessing(nexFileData,parameters);

if isstruct(neuralData.Data)
    nData = neuralData.Data.Spikes.Waveform;
    % Initialization
    HHData = struct;
    HHData.RecordTime = neuralData.MetaTags.DateTime; % Recording Date
    clear neuralData
else
    % Initialization
    HHData = struct;
    nData = neuralData.Data;
    HHData.RecordTime = neuralData.MetaTags.DateTime; % Recording Date
    clear neuralData
end

%% Raw data
if nargin == 4
RawData = nData{1,sessionLoop}(parameters.Channels.sChannels, :);
else
RawData = nData(parameters.Channels.sChannels, :);
end
clear nData

%% LFP Data
fprintf('Now Extracting LFP\n');
LFP_Data = extractLFP(RawData,parameters);

% Raw Voltage Information
HHData.Data.Voltage = struct;
HHData.Data.Voltage.Raw = RawData; % Original Raw Data 
HHData.Data.Voltage.Sampled = RawData(:,1:parameters.Derived.samplingFreq/parameters.Choices.downSample:end); % Downsampled to 500 S/s
clear RawData

% LFP Data information
HHData.Data.LFP = struct;
HHData.Data.LFP.LFP = LFP_Data;
HHData.Data.LFP.Sampled = LFP_Data(:,1:parameters.Derived.samplingFreq/parameters.Choices.downSample:end); % Downsampled to 500 S/s
clear LFP_Data

% 3. Create spectrograms for full session
fprintf('Now Creating Spectrograms\n');

% Downsample to Make Morelet Feasible
if strncmp(parameters.Optional.methods,'Morlet',4) 
[LFP_Spectrum, time, freq] = makeSpectrum(HHData.Data.LFP.Sampled,parameters);

% Save LFP Data information
HHData.Data.LFP.Spectrum = LFP_Spectrum;
clear LFP_Spectrum

% Or Do STFT Normally
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
HHData.Events.FOCUS_ON = parameters.Times.FOCUS_ON;
HHData.Events.SAMPLE_ON = parameters.Times.SAMPLE_ON;
HHData.Events.SAMPLE_RESPONSE = parameters.Times.SAMPLE_RESPONSE;
HHData.Events.MATCH_ON = parameters.Times.MATCH_ON;
HHData.Events.MATCH_RESPONSE = parameters.Times.MATCH_RESPONSE;
HHData.Events.CORRECT_RESPONSE = parameters.Times.CORRECT_RESPONSE;

% Channel mapping information
HHData.Channels = struct; % Channels information
HHData.Channels.sChannels = parameters.Channels.sChannels;
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