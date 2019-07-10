function[MCC, MCC_Categories,collectedClusterings] = parseClusterAssignments(dataML, clusters,methodML)

channelVec = dataML.Channels.sChannels;
sessionDir = dataML.Directory;
data = clusters;

% Load Correct Labels and Bounds

intervalRange = 1:size(data,1);
kRange = 5;
iterations = size(data,3);
label = 'Trial';

if methodML(1)
    prevalenceAcrossK = zeros(intervalRange(end),intervalRange(end));
    for kVal = kRange
        prevalenceAcrossChannels = zeros(intervalRange(end),intervalRange(end));
        for channel = 1:length(channelVec)
            
            clusterAssignments = data(:,:,:,channel);
            
            prevalenceAcrossIters = zeros(intervalRange(end),intervalRange(end));
            
            for nIters = 1:iterations
                currentClusters = clusterAssignments(:,kVal,nIters);
                currentClusters = repmat(currentClusters,1,length(currentClusters));
                currentClusters = double(currentClusters == currentClusters');
                prevalenceAcrossIters = [prevalenceAcrossIters + currentClusters];
                prevalenceAcrossK = [prevalenceAcrossK + currentClusters];
                prevalenceAcrossChannels = [prevalenceAcrossChannels + currentClusters];
                toJudge(:,:,nIters,channel) = currentClusters;
                
            end
            
            % Correctness Calculations
            [MCC(channel,kVal,:),MCC_Categories(channel,kVal,:)] = correctnessIndexIters(toJudge,dataML.Labels,intervalRange(end),kVal);
            orderedClusters(channel,kVal,:) = clusterOrder_Matrix(prevalenceAcrossIters);
            
        end
    end
end


% Load Correct Data
if methodML(2)
    clusterAssignments = data(:,:,:);
    
    prevalenceAcrossK = zeros(intervalRange(end),intervalRange(end));
    for kVal = kRange
        prevalenceAcrossIters = zeros(intervalRange(end),intervalRange(end));
        for nIters = 1:iterations
            currentClusters = clusterAssignments(:,kVal,nIters);
            currentClusters = repmat(currentClusters,1,length(currentClusters));
            currentClusters = double(currentClusters == currentClusters');
            prevalenceAcrossIters = [prevalenceAcrossIters + currentClusters];
            prevalenceAcrossK = [prevalenceAcrossK + currentClusters];
            toJudge(:,:,nIters) = currentClusters;
        end
        
        
        
        % Correctness Calculations
        [MCC(kVal,:),MCC_Categories(kVal,:,:)] = correctnessIndexIters(toJudge,dataML.Labels,intervalRange(end),kVal);
        collectedClusterings{1,1} = clusterOrder_Matrix(prevalenceAcrossIters);  
        collectedClusterings{2,1} = clusterOrder_Matrix_WithPriority(prevalenceAcrossIters);
        collectedClusterings{3,1} = clusterOrder_Matrix_WithPriorityNetworked(prevalenceAcrossIters);
        collectedClusterings{4,1} = clusterOrder_Matrix_Density(prevalenceAcrossIters);
        
        for iter = 1:length(collectedClusterings)
            newCluster = collectedClusterings{iter,1};
            newCluster = repmat(newCluster,1,length(newCluster));
            newCluster = double(newCluster == newCluster');
            [MCC_Reconstruction(kVal,:,iter),MCC_Categories_Reconstruction(kVal,:,iter)] = correctnessIndexIters(newCluster,dataML.Labels,intervalRange(end),kVal);
        end
    end
end

end