function [numberedClusters] = analyzeClusters(dataML,kmeansClusters)

%% Load Correct Labels and Bounds
if ndims(kmeansClusters) == 4
    channels = size(kmeansClusters,4);
else
    channels = 1;
end
intervalRange = 1:size(kmeansClusters,1);
kRange = 1:size(kmeansClusters,2);
iterations = 1:size(kmeansClusters,3);


%% Create Numbered Clusters (out of Kmeans Data)
for ki = kRange
    for channel = 1:channels
for iteri = iterations
    data = kmeansClusters(:,ki,iteri,channel);
    numberedClusters(:,ki,iteri,channel) = zeros(length(data),1);
    
    next = data(1);
for  ii = 1:max(data)
    if max(data) > 0
    indices = ii*(data == next(1));
    numberedClusters(:,ki,iteri,channel) = numberedClusters(:,ki,iteri,channel) + indices;
    toExclude = data ~= next(1);
    data = data.*toExclude;
    next = data(data > 0);
    end
end
end
end
end

%% Judge Correctness
if isfield(dataML,'Labels')
     fprintf('Computing MCCs');
for ki = kRange
    for channel = 1:channels   
    for iteri = iterations
[MCC{ki,iteri,channel}] = correctnessIndex(numberedClusters(:,ki,iteri,channel),dataML.Labels,intervalRange(end),ki);
    end
    end
end
else 
 fprintf('No labels. Unable to display performance metrics.');
end


%% Determine Most Prevalent Cluster
