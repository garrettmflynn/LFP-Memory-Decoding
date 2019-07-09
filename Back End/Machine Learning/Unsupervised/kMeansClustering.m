function [clusterIndices] = kMeansClustering(MLData,methodML)

%% Important Variable Derivation

distanceMethod = 'cosine';
kRange = 5;
sIters = 1;
intervalFilter = []; %[1,3,4,5,6,8,9,12,14] % Keep empty to process all

maxK = kRange(end);

channelVec = MLData.Channels.sChannels;
sessionDir = MLData.Directory;

if ~isfield(MLData,'PCA')
IDCMatrix = MLData.Data;
else
IDCMatrix = MLData.PCA;
end

%% Begin K-Means Clustering
if isempty(intervalFilter)
intervalFilter = 1:size(MLData.Data,1);
end


if methodML(1)
    for nIters = 1:sIters
            fprintf(['\nKMeans Sanity Iteration ', num2str(nIters),': '])
        for channel = 1:length(channelVec)
            
            fprintf(['\nChannel ', num2str(channelVec(channel))])

            
            saveDir = [sessionDir,'/KMeans/SCA'];
            
            if ~exist(saveDir,'dir');
                mkdir(saveDir);
            end
            
            for k = kRange
                    [idx,means,sumd] = kmeans(IDCMatrix(intervalFilter,:,channel),k,'Distance',distanceMethod);
                    for i = 1:max(idx)
                        clusterBuddies = find(idx==i);
                        clusterIndices(:,k,nIters,channel) = idx;
                    end
                    
                    subplot(1,2,1);[sil,h] = silhouette(IDCMatrix(intervalFilter,:,channel),idx,distanceMethod);hold on;
                        cluster(k,nIters) = mean(sil);
                
                close all;
                
             
                    totSum(k,nIters) = NaN;
                    totSum(k,nIters)=sum(sumd.*sumd);
                
            end
            
            meanSils(channel,:) = mean(cluster,2);
            channelSum(channel,:) = mean(totSum,2);
            
            
        end
%         minimizeSumD2 = figure('visible','off');
%         [ii,~,v] = find((channelSum.*channelSum)');
%         means = accumarray(ii,v,[],@mean);
%         plot(means);
%         xlabel('K Value')
%         ylabel('Squared Sum of Distances from Centroid')
%         title('Squared Distance from Centroid per K-Value (T)');
%         xlim([0 maxK]);
%         saveas(minimizeSumD2,[saveDir,'/SumsSquaredIteration',num2str(nIters),'.png'])
% 
%         
%         figMultiChannelClusters = figure('visible','off');
%         allK = repmat(1:kRange(end),size(meanSils,1),1);
%         [ii,~,v] = find(meanSils');
%         means = accumarray(ii,v,[],@mean);
%         bar(1:kRange(end),means); hold on;
%         plot(allK,meanSils,'.');
%         xlabel('K Value')
%         ylabel('Mean Silhouette Value over All Channels')
%         title('Cluster Separation for Varying K-Values(T)');
%         xlim([0 maxK]);
%         ylim([0 1]);
%         saveas(figMultiChannelClusters,[saveDir,'/ChannelAverageClustersIteration',num2str(nIters),'.png']);
    end
end

if methodML(2)
    IDMatrix = IDCMatrix;
    for nIters = 1:sIters
        fprintf(['\nKMeans Sanity Iteration ', num2str(nIters),': '])
        
        % Analyze Raw Data           
        
        saveDir = [sessionDir,'/KMeans/MCA'];
        if ~exist(saveDir,'dir');
        mkdir(saveDir);
        end
        
        for k = kRange
            
                [idx,means,sumd] = kmeans(IDMatrix,k,'Distance',distanceMethod);
                for i = 1:max(idx)
                    clusterBuddies = find(idx==i);
                    clusterIndices(:,k,nIters) = idx;
                end
                subplot(1,2,1);[sil,h] = silhouette(IDMatrix,idx,distanceMethod);hold on;
                    cluster(k,nIters) = mean(sil);
                    totSum(k,nIters)=sum(sumd);

            close all;
        end
        
        
%             minimizeSumD = figure('visible','off');
%             plot(sum(totSum.*totSum,2));
%             xlabel('K Value')
%             ylabel('Squared Sum of Distances from Centroid')
%             title('Average Distance from Centroid per K-Value (T)');
%             xlim([0 maxK]);
%             saveas(minimizeSumD,[saveDir,'/averageSumDistancesFromCentroidMacroIteration',num2str(nIters),'.png'])
%             
%             
%             figMultiChannelClusters = figure('visible','off');
%             allK = repmat(1:kRange(end),size(cluster,2),1);
%             bar(1:kRange(end),mean(cluster,2)); hold on;
%             plot(allK,cluster','.');
%             xlabel('K Value')
%             ylabel('Mean Silhouette Value')
%             title('Cluster Separation for Varying K-Values(T)');
%             xlim([0 maxK]);
%             ylim([0 1]);
%             saveas(figMultiChannelClusters,[saveDir,'/ChannelAverageClustersIterationIteration',num2str(nIters),'.png']);

    end
    
    
    
    
    
    
    
    
end







if methodML(3)
    IDMatrix = IDCMatrix;
    for nIters = 1:sIters
         fprintf(['\nKMeans Sanity Iteration ', num2str(nIters),': '])
        for k = kRange
            
                [idx,means,sumd] = kmeans(IDMatrix,k,'Distance',distanceMethod);
                for i = 1:max(idx)
                    clusterBuddies = find(idx==i);
                    clusterIndices(:,k,nIters) = idx;
                end
        end
    
    
    
end
end
