function [sampledData] = sampleData(rawData, intervals,parameters)

% This file is used to sample raw data given specified intervals.
channels = size(rawData,1);
intervalSize = (intervals(2,1)*parameters.Derived.samplingFreq-intervals(1,1)*parameters.Derived.samplingFreq);
numIntervals = size(intervals,2);



sampledData = zeros(channels,intervalSize,numIntervals);


for q = 1:numIntervals
    start = round((intervals(1,q)*parameters.Derived.samplingFreq)+1);
    stop = round((intervals(2,q)*parameters.Derived.samplingFreq)+1);

if ~(start == stop)
    sampledData(:,:,q) = rawData(:,start:(stop-1));
end
end
end
