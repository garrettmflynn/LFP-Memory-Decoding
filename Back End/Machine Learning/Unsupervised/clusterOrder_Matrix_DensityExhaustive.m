function [orderedClusters] = clusterOrder_Matrix_DensityExhaustive(countAcrossIters)
% Currently hardcoded for 5 Clusters

kOptimization = 5;


positions = 1:length(countAcrossIters);
numMaxes = positions(end);
orderedClusters = zeros(positions(end),1);
redo = true;
iterations = 1;
numClusts = positions(end);
numIters = max(max(countAcrossIters));
startIters = numIters;
howMany(numIters) = 2;
figure;

%% Initialize Links of size (numIters)
[v,i] = maxk(countAcrossIters,numMaxes);
startExComb = 1;
while redo
while redo
edges = cell(1,positions(end));
toLabel = [];
unLabel = [];
trueCols = [];
trueRows = [];

       for iterIndex = startIters:-1:numIters
        [row{iterIndex},col{iterIndex}] = find(v == iterIndex);
        
        
        uniqueCols = unique(col{iterIndex});
        for zz = uniqueCols'
        maxMatrix(zz,iterIndex) = sum(col{iterIndex} == zz);
        end
        
        maxMany = max(max(maxMatrix));
        
        for zz = uniqueCols'
        indices = find(col{iterIndex} == zz);
        pairs = row{iterIndex}(indices);
        [r,c] = find(i(:,zz) == zz);
        pairs = pairs(pairs ~= r);
        if howMany(iterIndex) == 1 || isempty(pairs)
            pairs = [r;pairs];
            newRows = pairs;
        else
        exhaustiveCombinations = combnk(pairs,howMany(iterIndex)-1);
        newRows = [r;exhaustiveCombinations(startExComb)];
        end
        
        if length(newRows) < length(pairs)   
        len = length(newRows);
        else
            if isempty(pairs)
            len = length(newRows);
            else   
            len = length(pairs);
            end
        end
        
        newRows = newRows(1:len);
        newCols = zz * ones(1,len);
        
        trueCols = [trueCols;newCols'];
        trueRows = [trueRows; newRows];
        
        end
            for ii = 1:length(trueCols)
            edges{trueCols(ii)} = [edges{trueCols(ii)}; i(trueRows(ii),trueCols(ii))];
            edges{trueCols(ii)} = unique(edges{trueCols(ii)});
        end
        end
        
        [clusters, edgesLog] = numClusters_Density(edges);
        
        % Check Density & Reject Clusters that are Below 
        
        for ci = 1:length(clusters)
            if length(clusters{ci}) ~= 1
            n = length(clusters{ci});
            potentialEdges(ci) = (n*(n-1))/2;
            actualEdges(ci) = size(edgesLog(ci),1);
            density = actualEdges./potentialEdges;
            toLabel = [toLabel ci];
            else 
                density(ci) = NaN;
                unLabel = [unLabel ci];
            end
        end  
       
            numClusts = sum(density > 0);
%             bar(howMany(numIters),numClusts); hold on;
%             bar(howMany(numIters),nanmean(density),'y'); hold on;
            
            densityDecider(startExComb,numIters) =  nanmean(density);
            bar(startExComb,numClusts); hold on;
            bar(startExComb,nanmean(density),'y'); hold on;
        
            clear density
            clear potentialEdges
            clear actualEdges
       
        if startExComb == size(exhaustiveCombinations,1)   
            if maxMany == howMany(numIters)
                numIters = numIters - 1;
                howMany(numIters) = 1;
                startExComb = 1;
            else
            howMany(numIters) = howMany(numIters) + 1;
            startExComb = 1;
            end
        end
        
        startExComb = startExComb + 1;    
        %% If Gone Over, Restart & Take Advantage of Slight Randomization Due to Maximum Connections
        if numClusts == kOptimization
            %redo = false;
        end
        if iterations > 10
            %redo = false;
        end
        iterations = iterations + 1;
    end
    
    if iterations > 10
        break;
    end
    
end
if iterations < 10
    for scale = 1:kOptimization
        for indices = toLabel
        orderedClusters(clusters{indices}) = scale;
        end
        for unlabeled = unLabel
            orderedClusters(clusters{unlabeled}) = 0;
        end
    end
else
    orderedClusters = NaN;
end
end