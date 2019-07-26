function [clusterIndices] = kMeansClustering(MLData,methodML)

%% Important Variable Derivation

distanceMethod = 'cosine';
kRange = 5;
sIters = 10;
intervalFilter = []; %[1,3,4,5,6,8,9,12,14] % Keep empty to process all
channelVec = MLData.Channels.sChannels;
IDCMatrix = MLData.Data;

%% Begin K-Means Clustering
if isempty(intervalFilter)
intervalFilter = 1:size(MLData.Data,1);
end
switch methodML
    case 'SCA'
    for nIters = 1:sIters
     displayNice(nIters, sIters, 'KMeans Sanity Iteration: ');
        for channel = 1:length(channelVec)
            fprintf(['\nChannel ', num2str(channelVec(channel))])
            for k = kRange
                    [idx,means,sumd] = kmeans(IDCMatrix(intervalFilter,:,channel),k,'Distance',distanceMethod);
                    for i = 1:max(idx)
                        clusterBuddies = find(idx==i);
                        clusterIndices(:,k,nIters,channel) = idx;
                    end
                close all;
            end
        end
    end
    
    otherwise
    IDMatrix = IDCMatrix;
for nIters = 1:sIters
   displayNice(nIters, sIters, 'KMeans Sanity Iteration: ');
        for k = kRange
                [idx,means,sumd] = kmeans(IDMatrix,k,'Distance',distanceMethod);
                for i = 1:max(idx)
                    clusterBuddies = find(idx==i);
                    clusterIndices(:,k,nIters) = idx;
                end
        end
end
end
end
