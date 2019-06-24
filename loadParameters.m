function [parameters] = loadParameters(parameters, samplingFreq,sessionPointLength)
%% Required External Functions
% readNexFile.m: BlackRock toolbox NMPK 
% nexManipulation.m: Supplied by Xiwei

addpath(genpath('D:\NPMK'));
addpath(genpath('D:\Standardized_LFP_Code\Back End\nexManipulation'));
addpath(genpath('C:\SuperUser\Documents\GitHub\LFP-Memory-Decoding'));

%% User-Defined Processing Parameters
% Define data path here for extracting LFP data
filePath = strcat('D:\ClipArt_2');

% Choose the testing data 
dataName = 'ClipArt_2';

% Data to Process (1 = "yes"; 0 = "no")
vizLoop = 1;
    Hamming = 0;
    Hanning = 1;
    Kaiser = 0;
    Taylor = 0;
    
    doBands = 1;
    doSignals = 0;
    doSpectrum = 1;
    
NonTrials = 0;
ZScore = 1;


intervalVec = [];

% Hardware | Channel Mapping + Sampling Rate
sChannels = 38; %[1:10, 17:26, 33:42];
CA1_Channels = [];%[7:10, 23:26, 39:42];
CA3_Channels = 38; %[1:6, 17:22, 33:38];

% For ClipArt_2:
% Channel #1-6 was implanted in LEFT CA3 Anterior, in which channel #1-3 were in the same depth and #4-6 in another depth. 
% Channel #7-10 was implanted in LEFT CA1 Anterior, in which channel #7-8 were in the same depth and #9-10 in another depth.
% Channel #17-22 was implanted in RIGHT CA3 Anterior, in which channel #17-19 were in the same depth and #20-22 in another depth.
% Channel #23-26  was implanted in RIGHT CA1 Anterior, in which channel #23-24 were in the same depth and #25-26 in another depth.
% Channel #33-38  was implanted in RIGHT CA3 Posterior, in which channel #33-35 were in the same depth and #36-38 in another depth.
% Channel #39-42  was implanted in RIGHT CA1 Posterior, in which channel #39-40 were in the same depth and #41-42 in another depth.

% Processing | Binning & Windows
freqMin = 1;
freqMax= 150;
freqBin = .5; % Frequency Bin Width (Hz)
timeBin = .1;  % Time Bin Width (s)
trialSegmentationWindow = [-1 1];

downSample = 500; % Samples/s

theta = [4 8];
alpha = [8 12];
beta = [16 24];
lowGamma = [25, 55];
highGamma = [65, 140];


% Define Low Pass Filter
lowPass = 250; % Low Pass Filter Frequency (Hz)



























%% Load User Definitions into Parameters Variable
parameters.Channels.sChannels = sChannels;
parameters.Channels.CA1_Channels = CA1_Channels;
parameters.Channels.CA3_Channels = CA3_Channels;
parameters.Filters.lowPass = lowPass;
parameters.Directories.filePath = filePath;
parameters.Directories.dataName = dataName;
parameters.Choices.trialWindow = trialSegmentationWindow;
parameters.Choices.downSample = downSample;
parameters.Optional.NonTrials = NonTrials;
parameters.Optional.ZScore = ZScore;
parameters.Optional.VizLoop = vizLoop;

methodsCount = 1;
    if Hamming
        methodsToTest(1) = 1;
        parameters.Optional.methods{methodsCount} = 'Hamming';
        methodsCount = methodsCount + 1;
    end
    if Hanning
        methodsToTest(2) = 1;
        parameters.Optional.methods{methodsCount} = 'Hanning';
        methodsCount = methodsCount + 1;
    end
    if Kaiser
        methodsToTest(3) = 1;
        parameters.Optional.methods{methodsCount} = 'Kaiser';
        methodsCount = methodsCount + 1;
    end
    if Taylor
        methodsToTest(4) = 1;
        parameters.Optional.methods{methodsCount} = 'Taylor';
        methodsCount = methodsCount + 1;
    end
    
parameters.Optional.methodsToTest = methodsToTest;
parameters.Choices.freqMin = freqMin;
parameters.Choices.freqMax = freqMax;
parameters.Choices.timeBin = timeBin;
parameters.Choices.freqBin = freqBin;
parameters.Choices.intervalVec = intervalVec;
parameters.Choices.doBands = doBands;
parameters.Choices.doTypes = [doSignals 2*(doSpectrum)];




if nargin == 3
parameters.Filters.notchFilter = designfilt('bandstopiir','FilterOrder',2, ...
    'HalfPowerFrequency1',59,'HalfPowerFrequency2',61, ...
    'DesignMethod','butter','SampleRate',samplingFreq); % Notch Filter to Remove Powerline Noise (Hz)

parameters.Derived.samplingFreq = samplingFreq;
parameters.Derived.durationSeconds = sessionPointLength/samplingFreq;
parameters.Derived.time = linspace(0,parameters.Derived.durationSeconds,((1/parameters.Choices.timeBin)*4)-1);
parameters.Derived.freq = linspace(parameters.Choices.freqMin, parameters.Choices.freqMax, ((parameters.Choices.freqMax-parameters.Choices.freqMin)+1)/parameters.Choices.freqBin);
parameters.Derived.overlap = round((parameters.Choices.timeBin * parameters.Derived.samplingFreq)/2);

for ii = 1:2
[minValue,closestIndex] = min(abs(parameters.Derived.freq-theta(ii)'));
if parameters.Derived.freq(closestIndex) > theta(ii) && ii == 1
parameters.SpectralAnalysis.Theta(ii) = parameters.Derived.freq(closestIndex-1);
elseif parameters.Derived.freq(closestIndex) < theta(ii) && ii == 2
parameters.SpectralAnalysis.Theta(ii) = parameters.Derived.freq(closestIndex+1);
else
    parameters.SpectralAnalysis.Theta(ii) = parameters.Derived.freq(closestIndex);
end

[minValue,closestIndex] = min(abs(parameters.Derived.freq-alpha(ii)'));
if parameters.Derived.freq(closestIndex) > alpha(ii) && ii == 1
parameters.SpectralAnalysis.Alpha(ii) = parameters.Derived.freq(closestIndex-1);
elseif parameters.Derived.freq(closestIndex) < alpha(ii) && ii == 2
parameters.SpectralAnalysis.Alpha(ii) = parameters.Derived.freq(closestIndex+1);
else
    parameters.SpectralAnalysis.Alpha(ii) = parameters.Derived.freq(closestIndex);
end

[minValue,closestIndex] = min(abs(parameters.Derived.freq-beta(ii)'));
if parameters.Derived.freq(closestIndex) > beta(ii) && ii == 1
parameters.SpectralAnalysis.Beta(ii) = parameters.Derived.freq(closestIndex-1);
elseif parameters.Derived.freq(closestIndex) < beta(ii) && ii == 2
parameters.SpectralAnalysis.Beta(ii) = parameters.Derived.freq(closestIndex+1);
else
    parameters.SpectralAnalysis.Beta(ii) = parameters.Derived.freq(closestIndex);
end



[minValue,closestIndex] = min(abs(parameters.Derived.freq-lowGamma(ii)'));
if parameters.Derived.freq(closestIndex) > lowGamma(ii) && ii == 1
parameters.SpectralAnalysis.Gamma_L(ii) = parameters.Derived.freq(closestIndex-1);
elseif parameters.Derived.freq(closestIndex) < lowGamma(ii) && ii == 2
parameters.SpectralAnalysis.Gamma_L(ii) = parameters.Derived.freq(closestIndex+1);
else
    parameters.SpectralAnalysis.Gamma_L(ii) = parameters.Derived.freq(closestIndex);
end



if freqMax < highGamma(2)
    highGamma(2) = freqMax;
end

[minValue,closestIndex] = min(abs(parameters.Derived.freq-highGamma(ii)'));
if parameters.Derived.freq(closestIndex) > highGamma(ii) && ii == 1
parameters.SpectralAnalysis.Gamma_H(ii) = parameters.Derived.freq(closestIndex-1);
elseif parameters.Derived.freq(closestIndex) < highGamma(ii) && ii == 2
parameters.SpectralAnalysis.Gamma_H(ii) = parameters.Derived.freq(closestIndex+1);
else
    parameters.SpectralAnalysis.Gamma_H(ii) = parameters.Derived.freq(closestIndex);
end


end

end