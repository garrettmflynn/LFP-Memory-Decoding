function [finalCount,cluster] = numClusters_ForPriority(edges)

clustCount = 1;
added = [];
posIndex = 1;
next = edges{posIndex};
positions = 1:length(edges);

edgeSearch = NaN(positions(end),positions(end));
for ii = 1:positions(end)
sz = length(edges{ii});
edgeSearch(ii,1:sz) = edges{ii};
end

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
        clustCount = clustCount + 1;
    elseif isempty(find(ismember(added,toAdd),1))
        cluster{clustCount} = toAdd;
        [added] = [added toAdd'];
        positions(toAdd) = NaN;
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
        clear cluster;
        count = 1;
        cluster = cell(1,length(newInds));
        for jj = newInds
            cluster{count} = oldCluster{jj};
            count = count + 1;
        end
        
        if ~isempty(cluster)
            cluster{length(cluster) + 1} = biggerCluster;
            clustCount = length(cluster) + 1;
        else
            cluster{1} = biggerCluster;
            clustCount = 2;
        end
        posIndex = posIndex + 1;
        next = edges{posIndex};
    end
end

finalCount = size(cluster,2);

end

