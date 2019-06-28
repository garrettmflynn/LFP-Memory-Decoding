function [sampledData] = sampleData(data, intervals,sampling)

freqs = size(data,1);

%% If Sampling is a Rate
if isscalar(sampling)
if ndims(data) == 3
channels = size(data,3);
else
    channels = 1
end

intervalSize = (intervals(2,1)*sampling-intervals(1,1)*sampling);
numIntervals = size(intervals,2);

sampledData = NaN(freqs,intervalSize,channels,numIntervals);

for q = 1:numIntervals
    start = round((intervals(1,q)*sampling)+1);
    stop = round((intervals(2,q)*sampling)+1);
    
%% If Data is Time-Frequency
if ndims(data) == 3
if ~(start == stop)
    for ii = 1:channels
    sampledData(:,:,ii,q) = data(:,start:stop-1,ii);
    end
end

%% If Data is Time-Series
else
if ~(start == stop)
    sampledData(:,:,q) = data(:,start:(stop-1));
end
end
end

%% If Sampling is a Time Vector (only for spectral data)

elseif isvector(sampling)
if ndims(data) == 3
channels = size(data,3);

intervalSize = closest(sampling,intervals(2,1))-closest(sampling,intervals(1,1));
numIntervals = size(intervals,2);

sampledData = NaN(freqs,intervalSize,channels,numIntervals);

for q = 1:numIntervals
    start = closest(sampling,intervals(1,q));
    stop = closest(sampling,intervals(2,q));
    
%% If Data is Time-Frequency
if ~(start == stop)
    for ii = 1:channels
    sampledData(:,:,ii,q) = data(:,start:stop-1,ii);
    end
end
end
end













end
end

function [idx, val] = closest(testArr,val)
tmp = abs(testArr - val);
[~, idx] = min(tmp);
val = testArr(idx);
end
