function [orderedClusters,excluded] = stableClusters(countAcrossIters)
% Currently hardcoded for 5 Clusters

kOptimization = 5;


positions = 1:length(countAcrossIters);
numMaxes = positions(end);
orderedClusters = zeros(positions(end),1);
iterations = 1;
prevalence = max(max(countAcrossIters));
numClusts = positions(end);
maxPrev = prevalence;

 %% Determine Strongest Links
[v,i] = maxk(countAcrossIters,numMaxes);

while prevalence>=(maxPrev*.9)
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

fprintf([num2str(numClusts),'\n']);

%% If Gone Over, Restart & Take Advantage of Slight Randomization Due to Maximum Connections

for scale = 1:length(denseClusters)
orderedClusters(denseClusters{scale},iterations) = scale;
end
excluded{:,iterations} = removed;
iterations = iterations + 1;
prevalence = prevalence - 1;
end
end
    
