function [LFP_Sampled] = sampleLFP(RawData_Sampled,fs)
% This file is used to extract LFP from sampled raw data


%% Define Filters
filterLP = 250; % Low Pass Filter Frequency (Hz)
filterNotch = designfilt('bandstopiir','FilterOrder',2, ...
    'HalfPowerFrequency1',59,'HalfPowerFrequency2',61, ...
    'DesignMethod','butter','SampleRate',fs); % Notch Filter to Remove Powerline Noise (Hz)


%% Filter Raw Data
    for interval = 1:size(RawData_Sampled,3)
    processedData = lowpass(rawData,filterLP,30000); % Low Pass
    LFP_Sampled(:,:,interval) = filtfilt(filterNotch,processedData); % Notch
    end
end