function [orderedClusters,excluded] = stableClusters(countAcrossIters)
% Currently hardcoded for .5 of maxPrev

interest = .5; % of maxPrev

positions = 1:length(countAcrossIters);
numMaxes = positions(end);
iterations = 1;
prevalence = max(max(countAcrossIters));
numClusts = positions(end);
maxPrev = prevalence;
orderedClusters = zeros(positions(end),length(maxPrev:-1:(maxPrev*interest)));

 %% Determine Strongest Links
[v,i] = maxk(countAcrossIters,numMaxes);

while prevalence>=(maxPrev*interest)
% Gather All Connections at X Prevalence    
edges = cell(1,positions(end));
    [row,col] = find(v >= prevalence);
    
    for ii = 1:length(col)
    edges{col(ii)} = [edges{col(ii)}; i(row(ii),col(ii))];
    edges{col(ii)} = unique(edges{col(ii)});
    end
    
%% Fill Edges Cell until 5 Stable Links are Made

[clusters,edgesLog,density,denseClusters,removed] = numClusters_Density(edges);
numClusts = length(clusters);

%fprintf([num2str(numClusts),'\n']);

%% If Gone Over, Restart & Take Advantage of Slight Randomization Due to Maximum Connections
if ~isnan(denseClusters{1})
for scale = 1:length(denseClusters)
orderedClusters(denseClusters{scale},iterations) = scale;
end
else
for scale = 1:length(clusters)
orderedClusters(clusters{scale},iterations)
end
end
excluded{:,iterations} = removed;
iterations = iterations + 1;
prevalence = prevalence - 1;
end
end
    
