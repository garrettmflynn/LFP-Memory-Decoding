
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
    form = 'Spectrum';
%% All Bands
    if ~isempty(cell2mat(regexpi(choiceFull,{'theta','alpha','beta','lowGamma','highGamma'})))
        bandType = erase(choiceFull,'Spectrum');
        spectrumFrequencies = HHData.Data.Parameters.SpectrumFrequencies;
        [HHData] = bandSpectrum(HHData,spectrumFrequencies,bandType,parameters.Choices.bandAveragedPower);
        if norm(iter) 
            dataToInterval = normalize(HHData.ML.(choiceFull),'STFT',form);
        else
            dataToInterval = HHData.ML.(choiceFull);
        end
[dataML.(choiceFull), HHData.Data.Intervals.Times] = makeIntervals(dataToInterval,HHData.Events.(centerEvent),HHData.Data.Parameters.Choices.trialWindow,HHData.Data.Parameters.SpectrumTime);
%% Just Spectrum  
    else
       if norm(iter) 
            dataToInterval = normalize(HHData.Data.LFP.Spectrum,'STFT',form);
        else
            dataToInterval = HHData.Data.LFP.Spectrum;
       end
[dataML.(choiceFull), HHData.Data.Intervals.Times] = makeIntervals(dataToInterval,HHData.Events.(centerEvent),HHData.Data.Parameters.Choices.trialWindow,HHData.Data.Parameters.SpectrumTime);
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
        [dataSignal,HHData.Data.Intervals.Times] = makeIntervals(dataToInterval,HHData.Events.(centerEvent),HHData.Data.Parameters.Choices.trialWindow,HHData.Data.Parameters.SamplingFrequency); 

        
%% Just Signal
     else
       if norm(iter) 
            dataToInterval = normalize(HHData.Data.LFP.LFP,'STFT',form);
        else
            dataToInterval = HHData.Data.LFP.LFP;
        end
[dataSignal,HHData.Data.Intervals.Times] = makeIntervals(dataToInterval,HHData.Events.(centerEvent),HHData.Data.Parameters.Choices.trialWindow,HHData.Data.Parameters.SamplingFrequency); 
     end
    clear dataToInterval
dataML.(choiceFull) = permute(dataSignal,[3,2,1,4]);
end
end

  

       for qq = 1:size(HHData.Data.LFP.Spectrum,3)
        Signal_Spectrum_Events_Polygons({HHData.Data.LFP.LFP(qq,:),HHData.Data.LFP.Spectrum(:,:,qq)}, HHData.Events,parameters,HHData.Channels.sChannels(qq),HHData.Data.Intervals.Times,'% Change', [-500,500], fullfile(parameters.Directories.filePath,['Signal-Spectrum-Events'],['Channel' num2str(HHData.Channels.sChannels(qq))]),0);
        end



%% Only Keep a Small Sampling of Additional Parameters
dataML.Channels = HHData.Channels;
dataML.Directory = parameters.Directories.filePath;
if parameters.isHuman
dataML.Labels = HHData.Labels;
dataML.WrongResponse = find(HHData.Data.Intervals.Outcome == 0);
end
dataML.Times = HHData.Data.Intervals.Times;

    
    