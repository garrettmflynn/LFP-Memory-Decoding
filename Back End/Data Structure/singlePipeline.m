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

RawData_Trials = sampleData(RawData,parameters.Intervals.Trials,parameters);
LFP_Trials = sampleData(LFP_Data,parameters.Intervals.Trials,parameters);

% 3. Create spectrograms for full session
fprintf('Now Creating Spectrograms\n');
[LFP_Spectrum time freq] = makeSpectrum(LFP_Data,parameters);
parameters.Derived.freq = freq;


if parameters.Choices.doBands 
fprintf('Now Creating Band Data\n');
LFP_Bands = bandLFP(LFP_Spectrum,parameters,LFP_Data);
end


%% Optional Sections for Z-Score and Nontrial Periods
if parameters.Optional.NonTrials
RawData_SampledNT = sampleData(RawData,parameters.Intervals.NonTrials,parameters);
LFP_SampledNT = sampleData(LFP_Data,parameters.Intervals.NonTrials,parameters);
end

if parameters.Optional.ZScore
Zstruct = zscore({LFP_Data,LFP_Spectrum},parameters);
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
HHData.RawData_Trials = RawData_Trials; % Raw data signals matched with trials in time domain
HHData.RawData_Sampled = RawData(:,1:parameters.Derived.samplingFreq/parameters.Choices.downSample:end); % Downsampled to 500 S/s

% Spike Data information
HHData.Spikes = parameters.Neuron; % Original Neuron Spike Data

% LFP Data information
HHData.LFP = struct; % LFP data with different frequency bands
HHData.LFP.LFPData = LFP_Data;

HHData.LFP.Trials = LFP_Trials;
HHData.LFP.Sampled = LFP_Data(:,1:parameters.Derived.samplingFreq/parameters.Choices.downSample:end); % Downsampled to 500 S/s
HHData.LFP.Spectrum = LFP_Spectrum;
HHData.LFP.TimeforSpectra = time;
HHData.LFP.FreqforSpectra = freq;
if parameters.Choices.doBands 
HHData.LFP.Theta.Signal = LFP_Bands.Theta.Signal; 
HHData.LFP.Theta.Spectrum = LFP_Bands.Theta.Spectrum; 
HHData.LFP.Alpha.Signal = LFP_Bands.Alpha.Signal;
HHData.LFP.Alpha.Spectrum = LFP_Bands.Alpha.Spectrum; 
HHData.LFP.Beta.Signal = LFP_Bands.Beta.Signal; 
HHData.LFP.Beta.Spectrum = LFP_Bands.Beta.Spectrum; 
HHData.LFP.Gamma_L.Signal = LFP_Bands.Gamma_L.Signal; 
HHData.LFP.Gamma_L.Spectrum = LFP_Bands.Gamma_L.Spectrum; 
HHData.LFP.Gamma_H.Signal = LFP_Bands.Gamma_H.Signal; 
HHData.LFP.Gamma_H.Spectrum = LFP_Bands.Gamma_H.Spectrum; 
end

% Zscore Inclusion
if parameters.Optional.ZScore
HHData.LFP.Zscore = Zstruct
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

if parameters.Optional.VizLoop
 fprintf(['Now Looping through Visualization', num2str(parameters.Optional.iteration),'\n']);
 
    visualizationSuite(HHData,fullfile(parameters.Directories.filePath,[parameters.Optional.methods{parameters.Optional.iteration},'_',num2str(parameters.Choices.freqBin),'_',num2str(parameters.Choices.timeBin),'_',num2str(round((parameters.Choices.timeBin * parameters.Derived.samplingFreq)/parameters.Derived.overlap))]));
 
    close all;
end
   
if ~parameters.Optional.VizLoop
fprintf('Now Saving ProcessedData.mat (this might take a while...)\n');
if nargin == 4
save(fullfile(parameters.Directories.filePath, [parameters.Directories.dataName, '_processedData_Session',num2str(sessionLoop),'.mat']), 'HHData','-v7.3');
else
save(fullfile(parameters.Directories.filePath,[parameters.Directories.dataName, '_processedData.mat']), 'HHData','-v7.3');
end
end

end