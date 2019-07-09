function[F1,MCC, dominantClusters,prevalence,clusterVectors] = parseClusterAssignments(dataML, clustersProcessed,methodML)

channelVec = dataML.Channels.sChannels;
sessionDir = dataML.Directory;
data = clustersProcessed;

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
                for nIters = 1:iterations
                    currentClusters = data(:,kVal,nIters,channel);
                    numberClusters(currentClusters)
                    [F1(channel,kVal),MCC(channel,kVal)] = correctnessIndex(currentClusters,intervalRange(end),kVal);
                end

                % Correctness Calculations
                [F1(channel,kVal),MCC(channel,kVal)] = correctnessIndex(prevalenceAcrossIters,intervalRange(end),kVal);
                dominantClusters{channel,kVal} = prevalenceDetection(prevalenceAcrossIters, 5);
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
            end
            
                
         % Correctness Calculations
         [F1(kVal) MCC(kVal)] = correctnessIndex(prevalenceAcrossIters,intervalRange(end),kVal);
          dominantClusters{kVal} = prevalenceDetection(prevalenceAcrossIters, 5);
          
          prevalence{kVal} = prevalenceAcrossIters;
                       
                
        end
    end




end