function [HHData] = singlePipeline(neuralData,nexFileData,parameters,sessionLoop)

lowPass = parameters.Filters.lowPass;
notchFilter = parameters.Filters.notchFilter;
fs = neuralData.MetaTags.SamplingFreq;
tWin = parameters.Choices.trialWindow;

%% Processing Raw/Spike/LFP data
% Process Spike Data AND Extract Behavior Timepoints

fprintf('Now Processing Spikes\n');
parameters = humanDataSpikeProcessing(nexFileData,parameters);

% Raw data
if nargin == 4
RawData = neuralData.Data{1,sessionLoop}(parameters.Channels.sChannels, :);
else
RawData = neuralData.Data(parameters.Channels.sChannels, :);
end

% LFP Data
fprintf('Now Extracting LFP\n');
LFP_Data = extractLFP(RawData,parameters);

% Match data, both raw and LFP, with trial intervals
parameters = makeIntervals(parameters,tWin);

RawData_Sampled = sampleData(RawData,parameters.Intervals.Trials,parameters);
LFP_Sampled = sampleData(LFP_Data,parameters.Intervals.Trials,parameters);

% 3. Create spectrograms for full session
fprintf('Now Creating Spectrograms\n');
[LFP_Spectrum time] = makeSpectrum(LFP_Data,parameters);

fprintf('Now Creating Band Data\n');
LFP_Bands = bandLFP(LFP_Spectrum,parameters,LFP_Data);


% Optional Sections
if parameters.Optional.NonTrials
RawData_SampledNT = sampleData(RawData,parameters.Intervals.NonTrials,parameters);
LFP_SampledNT = sampleData(LFP_Data,parameters.Intervals.NonTrials,parameters);
end

if parameters.Optional.ZScore
    fprintf('Now Creating ZScore Data\n');
frequencyMu = mean(LFP_Data');
frequencySigma = std(LFP_Data');
LFP_Signal_ZScore = (LFP_Data-frequencyMu')./frequencySigma';
for channel = 1:size(LFP_Spectrum,3)
frequencyMu = mean(squeeze(LFP_Spectrum(:,:,channel))');
frequencySigma = std(squeeze(LFP_Spectrum(:,:,channel))');
LFP_Spectrum_ZScore(:,:,channel) = (squeeze(LFP_Spectrum(:,:,channel))-frequencyMu')./frequencySigma';
end
LFP_Bands_ZScore = bandLFP(LFP_Spectrum_ZScore,parameters,LFP_Signal_ZScore);
end

%% Save data structure
% Initialization
HHData = struct; % Human Hippo Data

% Recording information
HHData.RecordTime = neuralData.MetaTags.DateTime; % Recording Date
HHData.SamplingFrequency = neuralData.MetaTags.SamplingFreq; % Recording Sampling Frequency

% Session/Trials information
HHData.start = parameters.Times.FOCUS_ON(1); % Session start
HHData.end = max(parameters.Times.MATCH_RESPONSE); % Session end

HHData.Events = struct; % Experimental Behavorial Info
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


% Interval Information
HHData.IntervalInformation.Times = parameters.Intervals.Trials;
for ii = 1:length(parameters.Times.MATCH_RESPONSE)
HHData.IntervalInformation.Outcome(ii) = ismember(round(parameters.Times.MATCH_RESPONSE(ii)),round(parameters.Times.CORRECT_RESPONSE));
end

% Raw Data information
HHData.RawData = RawData; % Original Raw Data 
HHData.RawData_Sampled = RawData_Sampled; % Raw data signals matched with trials in time domain

% Spike Data information
HHData.Spikes = parameters.Neuron; % Original Neuron Spike Data

% LFP Data information
HHData.LFP = struct; % LFP data with different frequency bands
HHData.LFP.LFPData = LFP_Data;
HHData.LFP.Sampled = LFP_Sampled; % Orignal LFP data filtered with [1 100] Hz | Range is tunable in loadParameters.m
HHData.LFP.Spectrum = LFP_Spectrum;
HHData.LFP.TimeforSpectra = time;
HHData.LFP.Theta.Signal = LFP_Bands.Theta.Signal; 
HHData.LFP.Theta.Spectrum = LFP_Bands.Theta.Spectrum; 
HHData.LFP.Alpha.Signal = LFP_Bands.Alpha.Signal;
HHData.LFP.Alpha.Spectrum = LFP_Bands.Alpha.Spectrum; 
HHData.LFP.Beta.Signal = LFP_Bands.Beta.Signal; 
HHData.LFP.Beta.Spectrum = LFP_Bands.Beta.Spectrum; 
HHData.LFP.Gamma_Low.Signal = LFP_Bands.LowGamma.Signal; 
HHData.LFP.Gamma_Low.Spectrum = LFP_Bands.LowGamma.Spectrum; 
HHData.LFP.Gamma_High.Signal = LFP_Bands.HighGamma.Signal; 
HHData.LFP.Gamma_High.Spectrum = LFP_Bands.HighGamma.Spectrum; 

% Zscore Inclusion
if parameters.Optional.ZScore
HHData.LFP.Zscore = LFP_Bands_ZScore;
HHData.LFP.Zscore.Signal = LFP_Signal_ZScore;
HHData.LFP.Zscore.Spectrum = LFP_Spectrum_ZScore;
end

% Nontrial Inclusion
if parameters.Optional.NonTrials
HHData.Nontrials.RawData_Sampled = RawData_SampledNT;
HHData.Nontrials.LFP_SampledNT = LFP_SampledNT;
HHData.Nontrials.IntervalInformation = parameters.Intervals.NonTrials;
end

% Just In Case This Might Want to Be Referenced
parametersTrans.Choices = parameters.Choices;
parametersTrans.SpectralAnalysis = parameters.SpectralAnalysis;
parametersTrans.Derived = parameters.Derived;
parametersTrans.Name = parameters.Directories.dataName;

HHData.Parameters = parametersTrans;


fprintf('Now Saving ProcessedData.mat (this might take a while...)\n');
if nargin == 4
save([parameters.Directories.filePath, '/', parameters.Directories.dataName, '_processedData_Session',num2str(sessionLoop),'.mat'], 'HHData','-v7.3');
else
save([parameters.Directories.filePath, '/', parameters.Directories.dataName, '_processedData.mat'], 'HHData','-v7.3');
end
end