% Extract Intervals Around SAMPLE_RESPONSE
[HHData.ML.Data, HHData.ML.Times] = makeIntervals(HHData.Data.LFP.Spectrum,HHData.Events.SAMPLE_RESPONSE,HHData.Data.Parameters.Choices.trialWindow,HHData.Data.Parameters.SpectrumTime);
[HHData.Data.Intervals.Signal,~] = makeIntervals(HHData.Data.LFP.LFP,HHData.Events.SAMPLE_RESPONSE,HHData.Data.Parameters.Choices.trialWindow,HHData.Data.Parameters.SamplingFrequency); 


if norm(iter)
    % Do Normalization
    HHData.Data.Voltage = [];
    HHData.Data.Spikes = [];
    HHData.Data.Normalized = normalize({HHData.Data.LFP.LFP, HHData.Data.LFP.Spectrum},'STFT','ZScore');
    [HHData.ML.Data] = makeIntervals(HHData.Data.Normalized.Spectrum,HHData.Events.SAMPLE_RESPONSE,HHData.Data.Parameters.Choices.trialWindow,HHData.Data.Parameters.SpectrumTime);
end

% But Only Keep A Small Part
dataML.Data = HHData.ML.Data;
dataML.Channels = HHData.Channels;
dataML.Directory = parameters.Directories.filePath;
dataML.Labels = HHData.Labels;
dataML.WrongResponse = find(HHData.Data.Intervals.Outcome == 0);



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

clear HHData