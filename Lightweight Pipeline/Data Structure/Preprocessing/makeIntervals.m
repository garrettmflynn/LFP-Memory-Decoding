function [sampledData,intervalMatrix] = makeIntervals(data,centerEventVector,trialSegmentationWindow,sampling)
% This file is used to generate interval windows for data processing

%% Extract Intervals from Supplied Data

if ndims(data) == 3
[freqs,~,channels] = size(data);
else
    
[freqs,~] = size(data);
channels = 1;
end


%% If Sampling is a Rate
if isscalar(sampling)
centerPoint = centerEventVector(1)*sampling;
    start = (centerEventVector(1)+trialSegmentationWindow(1))*sampling;
    aroundRange = centerPoint - start;
    stop = centerPoint + aroundRange;
intervalSize = (stop - start)+1;
numIntervals = length(centerEventVector);

sampledData = NaN(freqs,intervalSize,channels,numIntervals);

for q = 1:numIntervals
centerPoint = round(centerEventVector(q)*sampling);
    start = centerPoint - aroundRange;
    stop = centerPoint + aroundRange;
    
    intervalMatrix(1,q) = round(start/sampling);
    intervalMatrix(2,q) = round(stop/sampling);
    
%% If Data is Time-Frequency
if ndims(data) == 3
if ~(start == stop)
    for ii = 1:channels
    sampledData(:,:,ii,q) = data(:,start:stop,ii);
    end
end

%% If Data is Time-Series
else
if ~(start == stop)
    sampledData(:,:,q) = data(:,start:stop);
end
end
end

%% Spectral Data (time sampling)

elseif isvector(sampling)
    numIntervals = length(centerEventVector);
if ndims(data) == 3
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
    
%% If Data is Time-Frequency
if ~(start == stop)
    for ii = 1:channels
    sampledData(:,:,ii,q) = data(:,start:stop,ii);
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

%% Archived Code

%% NonTrial Intervals
% FOCUS_ON = parameters.Times.FOCUS_ON;
% MATCH_RESPONSE = parameters.Times.MATCH_RESPONSE;
% %intervalEnd = FOCUS_ON(:,1);
% intervalBegin = MATCH_RESPONSE(:,1);
% intervals = [intervalBegin(1:end-1)';intervalBegin(1:end-1)'+2]; % Standardized to Two Seconds Because There is Enough Time in ClipArt_2
% NTOnePadding = [0;0];
% fullInt = [NTOnePadding, intervals];
% parameters.Intervals.NonTrials = fullInt(:,intervalsToKeep);


%% "1 Second of ITI" Intervals
% ITI_ON = parameters.Times.ITI_ON;
% intervalEnd = FOCUS_ON(:,1);
% intervalBegin = ITI_ON(:,1);
% intervalCenter = ((intervalBegin(1:end-1) + ((intervalBegin(1:end-1)-intervalEnd(2:end))/2)));
% intervals = [intervalCenter'-.5;intervalCenter'+.5];
% parameters.Intervals.ITIOneSecond = intervals;
