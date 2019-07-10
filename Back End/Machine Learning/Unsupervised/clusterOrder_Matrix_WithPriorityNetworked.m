function [orderedClusters] = clusterOrder_Matrix_WithPriorityNetworked(countAcrossIters)
% Currently hardcoded for 5 Clusters

kOptimization = 5;


positions = 1:length(countAcrossIters);
numMaxes = positions(end);
orderedClusters = zeros(positions(end),1);
redo = true;
iterations = 1;
prevalence = max(max(countAcrossIters))-1;
numClusts = positions(end);

%% Determine Strongest Links
[v,i] = maxk(countAcrossIters,numMaxes);
while redo
    while (numClusts > kOptimization) && redo
        % First, Give Every Node At Least One Edge
        edges = cell(1,positions(end));
        for ii = positions
            edges{ii} = i(1:2,ii);
        end
        
        
        % Gather All Connections at X Prevalence
        
        [row,col] = find(v >= prevalence);
        
        for ii = 1:length(col)
            edges{col(ii)} = [edges{col(ii)}; i(row(ii),col(ii))];
            edges{col(ii)} = unique(edges{col(ii)});
        end
        
        maxIter = 2; % Start at 2 to skip trials matching with themselves
        
        %% Fill Edges Cell until 5 Stable Links are Made
        
        [numClusts,clusters] = numClusters_ForPriority(edges);
        
        maxIter = maxIter + 1;
        
        fprintf([num2str(numClusts),'\n']);
        
        %% If Gone Over, Restart & Take Advantage of Slight Randomization Due to Maximum Connections
        if numClusts == kOptimization
            redo = false;
        end
        prevalence = prevalence - 1;
        if iterations > 1
            redo = false;
        end
    end
    if iterations > 1
        break;
    end
    iterations = iterations + 1;
    
end
if iterations < 1
    for scale = 1:length(clusters)
        orderedClusters(clusters{scale}) = scale;
    end
else
    orderedClusters = NaN;
end

