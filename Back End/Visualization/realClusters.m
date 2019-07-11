function [realCluster] = realClusters(labels)

fields = fieldnames(labels);
realCluster = NaN(length(labels.(fields{1})),length(fields))
useCount = ones(length(labels.(fields{1})),1);
for ind = 1:length(fields)
     categories = find(labels.(fields{ind}));
if ind == 1
reUse = [];
used = categories; 
new = categories;    
else
reUse = used(ismember(categories,used));
new = categories(~ismember(categories,used));
used = [used;new];
end
for ii = 1:length(new)
realCluster(new(ii),1) = ind;
end
for jj = 1:length(reUse)
useCount(reUse(jj)) = useCount(reUse(jj)) + 1;
realCluster(reUse(jj),useCount(reUse(jj))) = ind;
end
end
end