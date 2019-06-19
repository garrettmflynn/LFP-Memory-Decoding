function [parameters] = makeIntervals(parameters,trialSegmentationWindow)
% This file is used to generate interval windows for data processing

% Trial Intervals
SAMPLE_RESPONSE = parameters.Times.SAMPLE_RESPONSE;
tempIntervals = SAMPLE_RESPONSE;
intervals = tempIntervals(:,1) + trialSegmentationWindow(1);
intervals(:,2) = tempIntervals(:,1) + trialSegmentationWindow(2);
parameters.Intervals.Trials = (intervals');


% NonTrial Intervals
FOCUS_ON = parameters.Times.FOCUS_ON;
MATCH_RESPONSE = parameters.Times.MATCH_RESPONSE;
intervalEnd = FOCUS_ON(:,1);
intervalBegin = MATCH_RESPONSE(:,1);
intervals = [intervalBegin(1:end-1)';intervalBegin(1:end-1)'+2]; % Standardized to Two Seconds Because There is Enough Time in ClipArt_2
NTOnePadding = [0;0];
parameters.Intervals.NonTrials = [NTOnePadding, intervals];
end