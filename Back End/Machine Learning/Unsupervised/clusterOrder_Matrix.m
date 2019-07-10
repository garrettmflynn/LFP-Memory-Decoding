function [orderedClusters] = clusterOrder_Matrix(countAcrossIters)
% Currently hardcoded for 5 Clusters

kOptimization = 5;


positions = 1:length(countAcrossIters);
numMaxes = positions(end);
orderedClusters = zeros(positions(end),1);
redo = true;
iterations = 1;

 %% Determine Strongest Links
[v,i] = maxk(countAcrossIters,numMaxes);
while redo
for qq = 1:size(v,1)
    % If More than One is the Max, then Put Index Value First--then Randomize
    if v(1,qq) == v(2,qq)
        row = 2;
        count = 1;
        while v(row,qq) == v(1)
            count = count + 1;
            row = row + 1;
        end
        toRandomize = i(1:count,qq);
        toRandomize = toRandomize(toRandomize ~= qq);
        randomized = toRandomize(randperm(length(toRandomize)));
        i(1,qq) = qq;
        i(2:count,qq) = randomized;
    end
end

positions = 1:length(countAcrossIters);
maxIter = 2; % Start at 2 to skip trials matching with themselves
numClusts = positions(end);

%% Fill Edges Cell until 5 Stable Links are Made
while numClusts > kOptimization
    edges = zeros(positions(end),maxIter);
for pi = positions
    edges(pi,:) = i(1:maxIter,pi);
end

[numClusts,clusters] = numClusters(edges);

maxIter = maxIter + 1;

fprintf([num2str(numClusts),'\n']);

end
%% If Gone Over, Restart & Take Advantage of Slight Randomization Due to Maximum Connections
if numClusts == kOptimization
    redo = false;
end
    iterations = iterations + 1;
    
if iterations > 100
    redo = false;
end
end


if iterations < 1000
for scale = 1:length(clusters)
orderedClusters(clusters{scale}) = scale;
end
else 
   orderedClusters = NaN; 
end 
end
