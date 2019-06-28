function [sampledData] = sampleData(data, intervals,samplingFreq)

freqs = size(data,1);

if ndims(data) == 3
channels = size(data,3);
else
    channels = 1
end

intervalSize = (intervals(2,1)*samplingFreq-intervals(1,1)*samplingFreq);
numIntervals = size(intervals,2);

sampledData = NaN(freqs,intervalSize,channels,numIntervals);

for q = 1:numIntervals
    start = round((intervals(1,q)*samplingFreq)+1);
    stop = round((intervals(2,q)*samplingFreq)+1);
    
%% If Data is Time-Frequency
if ndims(data) == 3
if ~(start == stop)
    sampledData(:,:,:,q) = data(:,start:(stop-1),:);
end

%% If Data is Time-Series
else
if ~(start == stop)
    sampledData(:,:,q) = data(:,start:(stop-1));
end
end
end
end
