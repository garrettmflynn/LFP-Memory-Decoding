%% Extract Intervals Around SAMPLE_RESPONSE
if sigVsSpec(2)
[HHData.ML.Spectrum, HHData.Data.Intervals.Times] = makeIntervals(HHData.Data.LFP.Spectrum,HHData.Events.SAMPLE_RESPONSE,HHData.Data.Parameters.Choices.trialWindow,HHData.Data.Parameters.SpectrumTime);
end
if sigVsSpec(1)
[HHData.ML.Signal,HHData.ML.Times] = makeIntervals(HHData.Data.LFP.LFP,HHData.Events.SAMPLE_RESPONSE,HHData.Data.Parameters.Choices.trialWindow,HHData.Data.Parameters.SamplingFrequency); 
end

%% Do Normalization
if norm(iter)
    HHData.Data.Voltage = [];
    HHData.Data.Spikes = [];
    HHData.Data.Normalized = normalize({HHData.Data.LFP.LFP, HHData.Data.LFP.Spectrum},'STFT','ZScore');
    if sigVsSpec(2)
    [HHData.ML.Spectrum] = makeIntervals(HHData.Data.Normalized.Spectrum,HHData.Events.SAMPLE_RESPONSE,HHData.Data.Parameters.Choices.trialWindow,HHData.Data.Parameters.SpectrumTime);
    end
    if sigVsSpec(1)
    [HHData.ML.Signal] = makeIntervals(HHData.Data.Normalized.Signal,HHData.Events.SAMPLE_RESPONSE,HHData.Data.Parameters.Choices.trialWindow,HHData.Data.Parameters.SamplingFrequency);
    end
    
    
    %     for ii = 1:size(HHData.ML.Data,3)
%         for jj = 1:size(HHData.ML.Data,4)
%     standardImage(HHData.ML.Data(:,:,ii,jj), HHData.Events,parameters, parameters.Derived.samplingFreq, ['Interval ' num2str(jj)], HHData.Channels.sChannels(ii),jj,HHData.ML.Times(:,jj),'% Change', [-500 500], fullfile(parameters.Directories.filePath,['Interval Images'],['Channel_',num2str(ii)]), 'Spectrum',0);
%         end
%     end
end

% But Only Keep A Small Part
if sigVsSpec(2)
dataML.Spectrum = HHData.ML.Spectrum;
end
if sigVsSpec(1)
dataML.Signal = HHData.ML.Signal;
end
dataML.Channels = HHData.Channels;
dataML.Directory = parameters.Directories.filePath;
dataML.Labels = HHData.Labels;
dataML.WrongResponse = find(HHData.Data.Intervals.Outcome == 0);
dataML.Times = HHData.ML.Times;



%% Save HHData If Desired
if saveHHData
    if norm(iter) == 1
fprintf('Now Saving Normalized HHData. This may take a while...');
save(fullfile(parameters.Directories.filePath,[parameters.Directories.dataName, 'HHDataNorm.mat']),'HHData','-v7.3');
    else
fprintf('Now Saving HHData. This may take a while...');
save(fullfile(parameters.Directories.filePath,[parameters.Directories.dataName, 'HHData.mat']),'HHData','-v7.3');
    end
end