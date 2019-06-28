
function [consistentGroups] = prevalenceDetection(prevalenceAcrossX, threshold);
% PREVALENCEDETECTION takes in a square NxN matrix, where N corresponds to
% the # of intervals processed, that logs the # of times that two intervals
% have been clustered together--whether this is over K Values, PCA
% Components, K-Means Iterations, or Channels. The output of this functoin
% is a 1xN vector where columns correspond to the
% interval-under-investigation, and cells correspond to the other intervals
% clustered with such an interval (if such clustering occurs MORE THAN the
% specified threshold.

for q = 1:90
consistentGroups{q}= find(prevalenceAcrossX(:,q) > threshold)
end

end