
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



for ii = 1:length(dataFormat)
    choiceFull = dataFormat{ii};
if ~isempty(regexpi(choiceFull,'Spectrum','ONCE'))
    form = 'Spectrum';
%% All Bands
    if ~isempty(cell2mat(regexpi(choiceFull,{'theta','alpha','beta','lowGamma','highGamma'})))
        bandType = erase(choiceFull,'Spectrum');
        spectrumFrequencies = HHData.Data.Parameters.SpectrumFrequencies;
        [HHData] = bandSpectrum(HHData,spectrumFrequencies,bandType);
        if norm(iter) 
            dataToInterval = normalize(HHData.ML.(choiceFull),'STFT',form);
        else
            dataToInterval = HHData.ML.(choiceFull);
        end
[dataML.(choiceFull), HHData.Data.Intervals.Times] = makeIntervals(dataToInterval,HHData.Events.SAMPLE_RESPONSE,HHData.Data.Parameters.Choices.trialWindow,HHData.Data.Parameters.SpectrumTime);
%% Just Spectrum  
    else
       if norm(iter) 
            dataToInterval = normalize(HHData.Data.LFP.Spectrum,'STFT',form);
        else
            dataToInterval = HHData.Data.LFP.Spectrum;
       end
[dataML.(choiceFull), HHData.Data.Intervals.Times] = makeIntervals(dataToInterval,HHData.Events.SAMPLE_RESPONSE,HHData.Data.Parameters.Choices.trialWindow,HHData.Data.Parameters.SpectrumTime);
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
%% Just Signal
     else
       if norm(iter) 
            dataToInterval = normalize(HHData.Data.LFP.LFP,'STFT',form);
        else
            dataToInterval = HHData.Data.LFP.LFP;
        end
[dataSignal,HHData.Data.Intervals.Times] = makeIntervals(dataToInterval,HHData.Events.SAMPLE_RESPONSE,HHData.Data.Parameters.Choices.trialWindow,HHData.Data.Parameters.SamplingFrequency); 
     end
     
dataML.(choiceFull) = permute(dataSignal,[3,2,1,4]);
end

% %% Extract Images if Desired    
%     for ii = 1:size(HHData.ML.Data,3)
%         for jj = 1:size(HHData.ML.Data,4)
%      standardImage(HHData.ML.Data(:,:,ii,jj), HHData.Events,parameters, parameters.Derived.samplingFreq, ['Interval ' num2str(jj)], HHData.Channels.sChannels(ii),jj,HHData.ML.Times(:,jj),'% Change', [-500 500], fullfile(parameters.Directories.filePath,['Interval Images'],['Channel_',num2str(ii)]), 'Spectrum',0);
%          end
%      end
 end

%% Only Keep a Small Sampling of Additional Parameters
dataML.Channels = HHData.Channels;
dataML.Directory = parameters.Directories.filePath;
dataML.Labels = HHData.Labels;
dataML.WrongResponse = find(HHData.Data.Intervals.Outcome == 0);
dataML.Times = HHData.Data.Intervals.Times;