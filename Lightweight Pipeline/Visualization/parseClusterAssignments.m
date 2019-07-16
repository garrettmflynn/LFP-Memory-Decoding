function[MCC, MCC_Categories,newClusters,removed] = parseClusterAssignments(dataML, clusters,methodML,barInfo)

% WE ARE NOW OUTPUTTING THE RECONSTRUCTED CLUSTERS FROM MULTIPLE ITERATIONS
outputReconstruct = false;


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
            [MCC(channel,kVal,:),MCC_Categories(channel,kVal,:)] = MCCs(toJudge,dataML.Labels,intervalRange(end),kVal);
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
        [MCC(kVal,:),MCC_Categories(kVal,:,:)] = MCCs(toJudge,dataML.Labels,intervalRange(end),kVal);
        [collectedClusterings,removed] = stableClusters(prevalenceAcrossIters);
        for iter2 = 1:size(collectedClusterings,2)
            newClusters{iter2} = collectedClusterings(:,iter2);
        end
        
        for iter2 = 1:size(newClusters,2)
            newCluster = newClusters{iter2};
            exclude = [dataML.WrongResponse removed{iter2}];
            newCluster = repmat(newCluster,1,length(newCluster));
            newCluster = double(newCluster == newCluster');
            [MCC_Reconstruction(iter2,:),MCC_Categories_Reconstruction(iter2,:)] = MCCs(newCluster,dataML.Labels,intervalRange(end),kVal,exclude);
        end
    end
end

if outputReconstruct
    MCC = MCC_Reconstruction;
    MCC_Categories = MCC_Categories_Reconstruction;
end

if nargin > 3
    labels = barInfo{1};
    pca = barInfo{2};
    typeML = barInfo{3};
    normalized = barInfo{4};
    saveBars =  barInfo{5};
    
    
    if ~exist(saveBars,'dir');
        mkdir(saveBars);
    end
    if outputReconstruct
        makeMCCBars(MCC,MCC_Categories,labels,[],name,normalized,saveBars);
    else
        makeMCCBars(MCC,MCC_Categories,labels,pca,typeML,normalized,saveBars,{MCC_Reconstruction,MCC_Categories_Reconstruction});
    end
end
end