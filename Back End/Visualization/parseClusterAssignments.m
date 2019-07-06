function[F1,MCC, dominantClusters,prevalence] = parseClusterAssignments(dataML, clusters,methodML)

channelVec = dataML.Channels.sChannels;
sessionDir = dataML.Directory;
data = clusters;

% Load Correct Labels and Bounds

        intervalRange = 1:size(data,1);
        kRange = 3:6;
        iterations = size(data,3);
        label = 'Trial';    

    if methodML(1)
        prevalenceAcrossK = zeros(intervalRange(end),intervalRange(end));
        for kVal = kRange
            prevalenceAcrossChannels = zeros(intervalRange(end),intervalRange(end));
            channelCo = 1;
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
                    
                end

                % Correctness Calculations
                [F1(channel,kVal),MCC(channel,kVal)] = correctnessIndex(prevalenceAcrossIters,intervalRange(end),kVal);
                dominantClusters{channel,kVal} = prevalenceDetection(prevalenceAcrossIters, 5);
                
                prevalence{channel,kVal} = prevalenceAcrossIters;
                
                channelCo = channelCo + 1;
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