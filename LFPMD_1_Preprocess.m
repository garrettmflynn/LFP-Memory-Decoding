
%% Prepare For ML
% This script allows for Memory Decoders to do the following with HHData structures:
%   - Create Bands
%   - Normalize Data
%   - Generate Intervals
%
% All of these changes are then saved into a dataML variable for use in
% iterateThroughML.m

                                                                            % Project: USC RAM
                                                                            % Author: Garrett Flynn
                                                                            % Date: July 26th, 2019

  %% Extract Images if Desired
for ii = 1:length(dataFormat)
    choiceFull = dataFormat{ii};
if ~isempty(regexpi(choiceFull,'Spectrum','ONCE'))
%% All Bands
    if ~isempty(cell2mat(regexpi(choiceFull,{'theta','alpha','beta','lowGamma','highGamma'})))
        form = 'bandSpectrum';
        bandType = erase(choiceFull,'Spectrum');
        spectrumFrequencies = HHData.Data.Parameters.SpectrumFrequencies;
        [HHData] = bandSpectrum(HHData,spectrumFrequencies,bandType,parameters.Choices.bandAveragedPower);
        if norm(iter) 
            dataToInterval = normalize(HHData.ML.(choiceFull),'STFT',form,output);
        else
            dataToInterval = HHData.ML.(choiceFull);
        end
        centers = HHData.Events.(centerEvent);
        
        if parameters.Channels.quickDebug
            numIntervals = 3;
        else
        numIntervals = length(centers);
        end
        
        
[dataML.(choiceFull), HHData.Data.Intervals.Times] = makeIntervals(dataToInterval,centers(1:numIntervals),HHData.Data.Parameters.Choices.trialWindow,HHData.Data.Parameters.SpectrumTime,'Spectrum'); 
%% Just Spectrum  
    else
        form = 'Spectrum';
       if norm(iter) 
            [dataToInterval] = normalize(HHData.Data.LFP.Spectrum,'STFT',form,output);
        else
            dataToInterval = HHData.Data.LFP.Spectrum;
       end
centers = HHData.Events.(centerEvent);

        if parameters.Channels.quickDebug
            numIntervals = 3;
        else
        numIntervals = length(centers);
        end
        
        [dataML.(choiceFull), HHData.Data.Intervals.Times] = makeIntervals(dataToInterval,centers(1:numIntervals),HHData.Data.Parameters.Choices.trialWindow,HHData.Data.Parameters.SpectrumTime,'Spectrum');
    end
    
    
end



if ~isempty(regexpi(choiceFull,'Signal','ONCE'))
    form = 'Signal';
%% Signal Bands
     if ~isempty(cell2mat(regexpi(choiceFull,{'theta','alpha','beta','lowGamma','highGamma'})))
        bandType = erase(choiceFull,'Signal');
        spectrumFrequencies = HHData.Data.Parameters.SpectrumFrequencies; 
        fs = HHData.Data.Parameters.SamplingFrequency;
        [HHData] = bandSignal(HHData,spectrumFrequencies,fs,bandType);
        if norm(iter) 
            dataToInterval = normalize(HHData.ML.(choiceFull),'STFT',form);
        else
            dataToInterval = HHData.ML.(choiceFull);
        end
        centers = HHData.Events.(centerEvent);
        
                if parameters.Channels.quickDebug
            numIntervals = 3;
        else
        numIntervals = length(centers);
                end
        
        [dataML.(choiceFull),HHData.Data.Intervals.Times] = makeIntervals(dataToInterval,centers(1:numIntervals),HHData.Data.Parameters.Choices.trialWindow,HHData.Data.Parameters.SamplingFrequency,'Signal'); 

        
%% Just Signal
     else
       if norm(iter) 
            dataToInterval = normalize(HHData.Data.LFP.LFP,'STFT',form,output);
        else
            dataToInterval = HHData.Data.LFP.LFP;
       end
        centers = HHData.Events.(centerEvent);
        
                if parameters.Channels.quickDebug
            numIntervals = 3;
        else
        numIntervals = length(centers);
                end
        
[dataML.(choiceFull),HHData.Data.Intervals.Times] = makeIntervals(dataToInterval,centers(1:numIntervals),HHData.Data.Parameters.Choices.trialWindow,HHData.Data.Parameters.SamplingFrequency,'Signal'); 
     end
    clear dataToInterval
end
end

  

%        for qq = 1:size(HHData.Data.LFP.Spectrum,3)
%         Signal_Spectrum_Events_Polygons({HHData.Data.LFP.LFP(qq,:),HHData.Data.LFP.Spectrum(:,:,qq)}, HHData.Events,parameters,HHData.Channels.sChannels(qq),HHData.Data.Intervals.Times,'% Change', [-500,500], fullfile(parameters.Directories.filePath,['Signal-Spectrum-Events'],['Channel' num2str(HHData.Channels.sChannels(qq))]),0);
%         end



%% Only Keep a Small Sampling of Additional Parameters
dataML.Channels = HHData.Channels;
dataML.Directory = parameters.Directories.filePath;
if parameters.isHuman
dataML.Labels = HHData.Labels;
dataML.WrongResponse = find(HHData.Data.Intervals.Outcome == 0);
end
dataML.Times = HHData.Data.Intervals.Times;



%% Function Repository

%% Make Intervals
function [sampledData,intervalMatrix] = makeIntervals(data,centerEventVector,trialSegmentationWindow,sampling,sigOrSpec)
% This file is used to generate interval windows for data processing

%% If Data is Time-Series
if strcmp(sigOrSpec,'Signal')
    

[channels,~] = size(data);

centerPoint = centerEventVector(1)*sampling;
    start = (centerEventVector(1)+trialSegmentationWindow(1))*sampling;
    aroundRange = centerPoint - start;
    stop = centerPoint + aroundRange;
intervalSize = (stop - start)+1;
numIntervals = length(centerEventVector);

sampledData = NaN(1,intervalSize,channels,numIntervals);
for q = 1:numIntervals
centerPoint = round(centerEventVector(q)*sampling);
    start = centerPoint - aroundRange;
    stop = centerPoint + aroundRange;
    
    intervalMatrix(1,q) = round(start/sampling);
    intervalMatrix(2,q) = round(stop/sampling);

if ~(start == stop)
    sampledData(1,:,:,q) = data(:,start:stop)';
end
end


%% Spectral Data (time sampling)

elseif strcmp(sigOrSpec,'Spectrum')
    
    
% Subcases  
if ndims(data) == 3
[freqs,~,channels] = size(data);
else  
[freqs,~] = size(data);
channels = 1;
end

    
    
    numIntervals = length(centerEventVector);
    centerPoint = closest(sampling,centerEventVector(1));
    start = closest(sampling,centerEventVector(1)+trialSegmentationWindow(1));
    aroundRange = centerPoint - start;
    stop = centerPoint + aroundRange;
intervalSize = (stop - start)+1;

sampledData = NaN(freqs,intervalSize,channels,numIntervals);

for q = 1:numIntervals
    centerPoint = closest(sampling,centerEventVector(q));
    start = centerPoint - aroundRange;
    stop = centerPoint + aroundRange;
    
    intervalMatrix(1,q) = sampling(start);
    intervalMatrix(2,q) = sampling(stop);
    
if ~(start == stop)
    for ii = 1:channels
    sampledData(:,:,ii,q) = data(:,start:stop,ii);
    end
end
end
end

function [idx, val] = closest(testArr,val)
tmp = abs(testArr - val);
[~, idx] = min(tmp);
val = testArr(idx);
end

end

%% Normalize
function [norm] = normalize(LFP_Data,dataMethod,dataFormat,outputFormat)
if strncmp(dataMethod,'STFT',4)
switch dataFormat

%% Signal Normalization | STFT | Percent Change
   case 'Signal'
for channels = 1:size(LFP_Data,1)
    channelMu = mean(LFP_Data(channels,:));
    freqSig = std(LFP_Data(channels,:));   
    inputToModify = LFP_Data(channels,:);
    if strcmp(outputFormat,'percentChange')
    LFP_Signal(channels,:) = 100*(inputToModify - channelMu)/channelMu;
    end
    if strcmp(outputFormat,'zScore')
       LFP_Signal(channels,:) = (inputToModify - channelMu)/freqSig;
    end
end
norm = LFP_Signal;
    %% Spectrum | STFT | MultiChannel | Percent Change
    case 'Spectrum'
            fprintf('Now Creating Normalized Data\n');
            if ndims(squeeze(LFP_Data)) == 3
                
                frequencyMu = squeeze(mean(permute(LFP_Data,[2,1,3])));   
                freqSig = squeeze(std(permute(LFP_Data,[2,1,3])));     
                for channels = 1:size(LFP_Data,3)
                    
                    if strcmp(outputFormat,'percentChange')
                    LFP_Spectrum(:,:,channels) = 100*(LFP_Data(:,:,channels) - frequencyMu(:,channels))./frequencyMu(:,channels);
                    end
                    if strcmp(outputFormat,'zScore')
                    LFP_Spectrum(:,:,channels) = (LFP_Data(:,:,channels) - frequencyMu(:,channels))./freqSig(:,channels);
                    end
                end
                
       %% Spectrum | STFT | Single Channel | Percent Change
            else
                if strcmp(outputFormat,'percentChange')
                frequencyMu = squeeze(mean(LFP_Data'));
                freqSig = squeeze(std(LFP_Data'));     
                  LFP_Spectrum = 100*(LFP_Data' - frequencyMu)./frequencyMu;
                  end
                if strcmp(outputFormat,'zScore')
                     LFP_Spectrum = (LFP_Data' - frequencyMu)./freqSig;
                end
                    
            end
            
            norm = LFP_Spectrum;

            
            
    case 'bandSpectrum'
        processableData = squeeze(LFP_Data);
        frequencyMu = squeeze(mean(processableData));
        freqSig = squeeze(std(processableData));
        
        [f,t,c] = size(LFP_Data);
         if strcmp(outputFormat,'percentChange')
                LFP_Spectrum = zeros(f,t,c);
                LFP_Spectrum(1:f,:,:) = 100*(processableData - frequencyMu)./frequencyMu;
         end
         if strcmp(outputFormat,'zScore')
                LFP_Spectrum = zeros(f,t,c);
                LFP_Spectrum(1:f,:,:) = 100*(processableData - frequencyMu)./freqSig;
                end
         
         
        norm = LFP_Spectrum;
end       
end
end

%% Band Spectrum
function [HHData] = bandSpectrum(HHData,SpectrumFrequencies,choice,averageOrNot)

% Initialize Variables
spectralParameters = bandParams(SpectrumFrequencies);
fullSpectrum = HHData.Data.LFP.Spectrum;

theta = spectralParameters.theta;
alpha = spectralParameters.alpha;
beta = spectralParameters.beta;
lowGamma = spectralParameters.lowGamma;
highGamma = spectralParameters.highGamma;

%% Spectral Band Derivation

switch choice
    case 'theta'
matchTheta(1) = find(SpectrumFrequencies  == theta(1));
matchTheta(2) = find(SpectrumFrequencies  == theta(2));
HHData.ML.thetaSpectrum = fullSpectrum(matchTheta(1):matchTheta(2),:,:,:);

if averageOrNot
    HHData.ML.thetaSpectrum = mean(HHData.ML.thetaSpectrum);
end

    case 'alpha'

matchAlpha(1) = find(SpectrumFrequencies  == alpha(1));
matchAlpha(2) = find(SpectrumFrequencies  == alpha(2));
HHData.ML.alphaSpectrum = fullSpectrum(matchAlpha(1):matchAlpha(2),:,:,:);

if averageOrNot
    HHData.ML.alphaSpectrum = mean(HHData.ML.alphaSpectrum);
end

    case 'beta'

matchBeta(1) = find(SpectrumFrequencies==beta(1));
matchBeta(2) = find(SpectrumFrequencies==beta(2));
HHData.ML.betaSpectrum = fullSpectrum(matchBeta(1):matchBeta(2),:,:,:);

if averageOrNot
    HHData.ML.betaSpectrum = mean(HHData.ML.betaSpectrum);
end

    case 'lowGamma'

matchGamma_L(1) = find(SpectrumFrequencies==lowGamma(1));
matchGamma_L(2) = find(SpectrumFrequencies==lowGamma(2));
HHData.ML.lowGammaSpectrum = fullSpectrum(matchGamma_L(1):matchGamma_L(2),:,:,:);

if averageOrNot
    HHData.ML.lowGammaSpectrum = mean(HHData.ML.lowGammaSpectrum);
end

    case 'highGamma'

matchGamma_H(1) = find(SpectrumFrequencies==highGamma(1));
matchGamma_H(2) = find(SpectrumFrequencies==highGamma(2));
HHData.ML.highGammaSpectrum = fullSpectrum(matchGamma_H(1):matchGamma_H(2),:,:,:);

if averageOrNot
    HHData.ML.highGammaSpectrum = mean(HHData.ML.highGammaSpectrum);
end

end
end

%% Band Signal
function [HHData] = bandSignal(HHData,SpectrumFrequencies,samplingFreq,choice)

% Initialize Variables
spectralParameters = bandParams(SpectrumFrequencies);
fullSignal = HHData.Data.LFP.LFP;

theta = spectralParameters.theta;
alpha = spectralParameters.alpha;
beta = spectralParameters.beta;
lowGamma = spectralParameters.lowGamma;
highGamma = spectralParameters.highGamma;

%% If Full Signal
if ndims(fullSignal) < 3
    switch choice
case 'theta'
HHData.ML.thetaSignal =  (bandpass(fullSignal',theta,samplingFreq))';
case 'alpha'
HHData.ML.alphaSignal = (bandpass(fullSignal',alpha,samplingFreq))';
case 'beta'
HHData.ML.betaSignal = (bandpass(fullSignal',beta,samplingFreq))';
case 'lowGamma'
HHData.ML.lowGammaSignal = (bandpass(fullSignal',lowGamma,samplingFreq))';
case 'highGamma'
HHData.ML.highGammaSignal = (bandpass(fullSignal',highGamma,samplingFreq))';
    end


%% 
else
fullSignal = squeeze(fullSignal);
for ii = 1:size(fullSignal,3)
    toBand = fullSignal(:,:,ii);
switch choice
    case 'theta'
HHData.ML.thetaSignal(:,:,ii) = (bandpass(toBand',theta,samplingFreq))';
case 'alpha'
HHData.ML.alphaSignal(:,:,ii) = (bandpass(toBand',alpha,samplingFreq))';
case 'beta'
HHData.ML.betaSignal(:,:,ii) = (bandpass(toBand',beta,samplingFreq))';
case 'lowGamma'
HHData.ML.lowGammaSignal(:,:,ii) = (bandpass(toBand',lowGamma,samplingFreq))';
case 'highGamma'
HHData.ML.highGammaSignal(:,:,ii) = (bandpass(toBand',highGamma,samplingFreq))';
end
end
end
end

%% Band Params
function [SpectralAnalysis] = bandParams(freqUsed)

%% Specify Band Bounds (in Hz) 
theta = [4 8];
alpha = [8 12];
beta = [16 24];
lowGamma = [25, 55];
highGamma = [65, 140];


%% Match Bounds to Actual Frequency Bins
for ii = 1:2
[minValue,closestIndex] = min(abs(freqUsed-theta(ii)'));
    SpectralAnalysis.theta(ii) = freqUsed(closestIndex);

[minValue,closestIndex] = min(abs(freqUsed-alpha(ii)'));
    SpectralAnalysis.alpha(ii) = freqUsed(closestIndex);

[minValue,closestIndex] = min(abs(freqUsed-beta(ii)'));
SpectralAnalysis.beta(ii) = freqUsed(closestIndex);


[minValue,closestIndex] = min(abs(freqUsed-lowGamma(ii)'));
   SpectralAnalysis.lowGamma(ii) = freqUsed(closestIndex);

[minValue,closestIndex] = min(abs(freqUsed-highGamma(ii)'));
   SpectralAnalysis.highGamma(ii) = freqUsed(closestIndex);
end
end



    