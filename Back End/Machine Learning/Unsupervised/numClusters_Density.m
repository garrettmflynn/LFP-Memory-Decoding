function [cluster,edgesLog,density,denseClusters,removed] = numClusters_Density(edges)

clustCount = 1;
added = [];
posIndex = 1;
next = edges{posIndex};
positions = 1:length(edges);

%% Count Edges Per Node
for ii = 1:length(edges)
edgesPerNode(ii) = length(edges{ii})-1; % Exclude edge with itself
end


edgeSearch = NaN(positions(end),positions(end));
for ii = 1:positions(end)
sz = length(edges{ii});
edgeSearch(ii,1:sz) = edges{ii};
end


alreadyEdges = cell(1,positions(end));
while ~isempty(find(~isnan(positions),1))
    toAdd = [];
    for zz = 1:length(next)
    [addColumn,~] = find(edgeSearch == next(zz));
    toAdd = [toAdd;addColumn];
    end
    toAdd = unique(toAdd);
    if clustCount == 1
        [added] = [added toAdd'];
        positions(toAdd) = NaN;
        cluster{clustCount} = toAdd;
        alreadyEdges{clustCount} = rewriteEdges(toAdd);
        edgeCount{clustCount} = size(alreadyEdges{clustCount},1);
        clustCount = clustCount + 1;
    elseif isempty(find(ismember(added,toAdd),1))
        cluster{clustCount} = toAdd;
        [added] = [added toAdd'];
        positions(toAdd) = NaN;
        alreadyEdges{clustCount} = rewriteEdges(toAdd);
        edgeCount{clustCount} = size(alreadyEdges{clustCount},1);
        
        clustCount = clustCount + 1;
    else
        historyIndex = [];
        count = 1;
        biggerCluster = toAdd;
        indices = 1:length(cluster);
        for ii = 1:length(cluster)
            if ~isempty(find(ismember(cluster{ii},toAdd),1))
                biggerCluster = [biggerCluster; cluster{ii}(~ismember(cluster{ii},toAdd))];
                positions(toAdd) = NaN;
                historyIndex(count) = ii;
                count = count + 1;
            end
        end
        newInds = indices;
        newInds(historyIndex) = [];
        oldCluster = cluster;
        oldAlreadyEdges = alreadyEdges;
        clear alreadyEdges;
        clear cluster;
        count = 1;
        cluster = cell(1,length(newInds));
        addBigger = true;
        if isempty(newInds)
            newInds = 1;
            cluster{1} = biggerCluster;
            addBigger = false;
            alreadyEdges{1} = rewriteEdges(biggerCluster);
        end
        for jj = newInds
            cluster{count} = oldCluster{jj};
            alreadyEdges{count} = oldAlreadyEdges{jj};
            count = count + 1;
        end
        
        if addBigger
            cluster{count} = biggerCluster;
            alreadyEdges{count} = rewriteEdges(biggerCluster);
            clustCount = count + 1;
        end
        posIndex = posIndex + 1;
        next = edges{posIndex};
    end
end

edgesLog = alreadyEdges;

if nargout >= 3
toLabel = [];
unLabel = [];
for ci = 1:length(cluster)
            if length(cluster{ci}) ~= 1
            n = length(cluster{ci});
            potentialEdges(ci) = (n*(n-1))/2;
            actualEdges(ci) = size(edgesLog(ci),1);
            density = actualEdges./potentialEdges;
            toLabel = [toLabel ci];
            else 
                density(ci) = NaN;
                unLabel = [unLabel ci];
            end
end  
            index = 1;
            
            for sigi = toLabel
            denseClusters{index} = cluster{sigi};
            index = index + 1;
            end
            

            removed = unLabel;

end

if isempty(unLabel)
    removed = NaN;
end


end

