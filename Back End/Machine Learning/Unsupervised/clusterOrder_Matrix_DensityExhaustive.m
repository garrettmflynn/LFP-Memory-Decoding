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

%% Iterate Links 
[v,i] = maxk(countAcrossIters,numMaxes);
startExComb = 1;

while numIters >= 6
edges = cell(1,positions(end));
toLabel = [];
unLabel = [];
trueCols = cell(1,1000);
trueRows = cell(1,1000);
variationCounts = 1;


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
            grab = howMany(iterIndex)-1;
            if grab > length(pairs)
                grab = length(pairs);
            end
        exhaustiveCombinations = combnk(pairs,grab);
        newRows = [repmat(r,size(exhaustiveCombinations,1),1),exhaustiveCombinations];
        end
        
        if size(newRows,1) < size(pairs,1);  
        len = size(newRows,1);
        else
            if isempty(pairs)
            len = size(newRows,1);
            else   
            len = size(pairs,1);
            end
        end
        
        newRows = newRows(1:len,:);
        newCols = zz * ones(len,1);
        
        for partition = 1:size(newRows,2)
        trueCols{variationCounts} = [trueCols{variationCounts};newCols];
        trueRows{variationCounts} = [trueRows{variationCounts}; newRows(:,partition)];
        variationCounts = variationCounts + 1;
        end
        end
        for v = 1:length(variationCounts)
            for ii = 1:length(trueCols{v})
            edges{trueCols(ii),v} = [edges{trueCols(ii),v}; i(trueRows{v}(ii,:),trueCols{v}(ii,:))];
            edges{trueCols(ii),v} = unique(edges{trueCols(ii),v});
            end
        end
       end
            if maxMany == howMany(numIters)
                numIters = numIters - 1;
                howMany(numIters) = 1;
                startExComb = 1;
            else
            howMany(numIters) = howMany(numIters) + 1;
            startExComb = 1;
            end
end


  for numPermutations = 1:size(edges,3)     
       
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
        
        startExComb = startExComb + 1;    
  end
end
