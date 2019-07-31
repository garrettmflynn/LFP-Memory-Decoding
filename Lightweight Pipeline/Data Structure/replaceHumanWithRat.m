function [neuralData,nexFileData] = TrialChannelData_Visualization(nexFileData)


%% Create Artificial Neural Data Structure
neuralData = struct();

% Channels
neuralData.MetaTags.ChannelCount = size(nexFileData.contvars,1);

% Sampling
realSampling = nexFileData.freq;
downSample = 2000;
sRatio = downSample/realSampling;
sIter = realSampling/downSample;


neuralData.MetaTags.SamplingFreq = downSample;


% Data
neuralData.MetaTags.DataPoints = size(nexFileData.contvars{neuralData.MetaTags.ChannelCount, 1}.data,1)*sRatio;

neuralData.MetaTags.DataDurationSec = neuralData.MetaTags.DataPoints/neuralData.MetaTags.SamplingFreq;
neuralData.MetaTags.DataPointsSec = neuralData.MetaTags.DataDurationSec;

neuralData.Data = zeros(neuralData.MetaTags.ChannelCount,neuralData.MetaTags.DataPoints);

for ii = 1:neuralData.MetaTags.ChannelCount
    neuralData.Data(ii,:) = nexFileData.contvars{ii, 1}.data(1:sIter:end);
end

% Remove ContVars
nexFileData.contvars = [];
end
