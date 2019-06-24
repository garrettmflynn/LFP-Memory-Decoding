function [parameters] = makeIntervals(parameters,trialSegmentationWindow)
% This file is used to generate interval windows for data processing

if ~isempty(parameters.Choices.intervalVec)
intervalsToKeep = parameters.Choices.intervalVec;
else
    intervalsToKeep = 1:length(parameters.Times.SAMPLE_RESPONSE);
end

% Trial Intervals
SAMPLE_RESPONSE = parameters.Times.SAMPLE_RESPONSE;
tempIntervals = SAMPLE_RESPONSE;
intervals = tempIntervals(:,1) + trialSegmentationWindow(1);
intervals(:,2) = tempIntervals(:,1) + trialSegmentationWindow(2);
intervals = (intervals');
parameters.Intervals.Trials = intervals(:,intervalsToKeep);


% NonTrial Intervals
FOCUS_ON = parameters.Times.FOCUS_ON;
MATCH_RESPONSE = parameters.Times.MATCH_RESPONSE;
%intervalEnd = FOCUS_ON(:,1);
intervalBegin = MATCH_RESPONSE(:,1);
intervals = [intervalBegin(1:end-1)';intervalBegin(1:end-1)'+2]; % Standardized to Two Seconds Because There is Enough Time in ClipArt_2
NTOnePadding = [0;0];
fullInt = [NTOnePadding, intervals];
parameters.Intervals.NonTrials = fullInt(:,intervalsToKeep);


% 1 Second of ITI
ITI_ON = parameters.Times.ITI_ON;
intervalEnd = FOCUS_ON(:,1);
intervalBegin = ITI_ON(:,1);
intervalCenter = ((intervalBegin(1:end-1) + ((intervalBegin(1:end-1)-intervalEnd(2:end))/2)));
intervals = [intervalCenter'-.5;intervalCenter'+.5];
parameters.Intervals.ITIOneSecond = intervals;




end