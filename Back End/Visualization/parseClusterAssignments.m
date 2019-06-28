function[] = parseClusterAssignments(trialStructure, sessionDir,channelVec, methodML,TvsNT)

% What Defines an Interesting Loading?
stdThreshold = 1; % How Many Standard Deviations Above the Mean a Loading Has to Be to Be Considered as an Interesting Feature



T = trialStructure{1};
NT = trialStructure{2};

% Load Correct Labels and Bounds
index = 1;

if methodML(1)
    if TvsNT(1)
        intervalRange{index} = 1:size(T.kMeans.SingleChannel{1,channelVec(1)}.clusterAssignments,1);
        %kRange{index} = 1:size(T.kMeans.SingleChannel{1,channelVec(1)}.clusterAssignments,2);
        kRange{index} = 5:6;
        iterations = size(T.kMeans.SingleChannel{1,channelVec(1)}.clusterAssignments,3);
        label{index} = 'Trial';
        index = index + 1;
    end
    if TvsNT(2)
        intervalRange{index} = 1:size(NT.kMeans.SingleChannel{1,channelVec(1)}.clusterAssignments,1);
        %kRange{index} = 1:size(NT.kMeans.SingleChannel{1,channelVec(1)}.clusterAssignments,2);
        kRange{index} = 5:6;
        iterations = size(NT.kMeans.SingleChannel{1,channelVec(1)}.clusterAssignments,3);
        label{index} = 'NonTrial';
    end
    
elseif methodML(2)
    if TvsNT(1)
        intervalRange{index} = 1:size(T.kMeans.MCA.clusterAssignments,1);
        %kRange{index} = 1:size(T.kMeans.MCA.clusterAssignments,2);
        kRange{index} = 5:6;
        iterations = size(NT.kMeans.MCA.clusterAssignments,3);
        label{index} = 'Trial';
        index = index + 1;
    end
    
    if TvsNT(2)
        intervalRange{index} = 1:size(NT.kMeans.MCA.clusterAssignments,1);
        %kRange{index} = 1:size(NT.kMeans.MCA.clusterAssignments,2);
        kRange{index} = 5:6;
        iterations = size(NT.kMeans.MCA.clusterAssignments,3);
        label{index} = 'NonTrial';
    end
end


% WHERE IS THE ORIGINAL IMAGE STRUCTURE?
%     relevantCoeffs = coeffMatrix(:,1:nComps)
%     for i = 1:nComps
%         mean = mean(relevantCoeffs(:,i));
%         std = std(relevantCoeffs(:,i));
%         weightsLoading = (relevantCoeffs > (mean+(std*stdThresold)));
%         interestingLoadings = relevantCoeffs.*weightsLoading;
% X = originalImage
% mu = mean(X);
% [eigenvectors, scores] = pca(X);
% nComp = 2;
% Xhat = scores(:,1:nComp) * eigenvectors(:,1:nComp)';
% Xhat = bsxfun(@plus, Xhat, mu);
% Xhat(1,:)
%

for q = 1:sum(TvsNT)
    
    
    
    if methodML(1)
        prevalenceAcrossK = zeros(intervalRange{q}(end),intervalRange{q}(end));
        averagedChannel = figure()
        averagedIterations5 = figure()
        averagedIterations6 = figure()
        kCount = 1;
        for kVal = kRange{q}
            prevalenceAcrossChannels = zeros(intervalRange{q}(end),intervalRange{q}(end));
            channelCo = 1;
            for channel = channelVec
                
                % Load Correct Data
                index = 1;
                
                
                if TvsNT(1)
                    %coeffMatrixT{index} = T.PCA.channels{1,channel}.loading;
                    clusterAssignments{index} = T.kMeans.SingleChannel{1,channel}.clusterAssignments;
                    index = index + 1;
                end
                if TvsNT(2)
                    %coeffMatrix{index} = NT.PCA.channels{1,channel}.loading;
                    clusterAssignments{index} = NT.kMeans.SingleChannel{1,channel}.clusterAssignments;
                end
                prevalenceAcrossIters = zeros(intervalRange{q}(end),intervalRange{q}(end));
                
                for nIters = 1:iterations
                    currentClusters = clusterAssignments{q}(:,kVal,nIters);
                    currentClusters = repmat(currentClusters,1,length(currentClusters));
                    currentClusters = double(currentClusters == currentClusters');
                    prevalenceAcrossIters = [prevalenceAcrossIters + currentClusters];
                    prevalenceAcrossK = [prevalenceAcrossK + currentClusters];
                    prevalenceAcrossChannels = [prevalenceAcrossChannels + currentClusters];
                    
                end
                
                if kVal == 5
                    set(0,'CurrentFigure',averagedIterations5)
                    subplot(ceil(sqrt(length(channelVec))),floor(sqrt(length(channelVec))),channelCo);surf(intervalRange{q}, intervalRange{q},prevalenceAcrossIters,'EdgeColor','none');hold on;
                    axis xy; axis tight; colormap(jet); view(0,90);
                    hcb2=colorbar;
                    caxis([0,iterations]);
                    set(get(hcb2,'label'),'string','Stability (across iterations)');
                    title(['Channel = ',num2str(channel)]);
                    plot3([length(T.PSD.channels{1,channelVec(1)}.intervals) length(T.PSD.channels{1,channelVec(1)}.intervals)],[0 length(T.PSD.channels{1,channelVec(1)}.intervals)],[1 1],'g','Linewidth',2);
                    plot3([1 length(T.PSD.channels{1,channelVec(1)}.intervals)],[length(T.PSD.channels{1,channelVec(1)}.intervals) length(T.PSD.channels{1,channelVec(1)}.intervals)],[1 1],'g','Linewidth',2);
                    sgtitle(['Stability for K = ',num2str(kVal)]);
                end
                
                 if kVal == 6
                    set(0,'CurrentFigure',averagedIterations6)
                    subplot(ceil(sqrt(length(channelVec))),floor(sqrt(length(channelVec))),channelCo);surf(intervalRange{q}, intervalRange{q},prevalenceAcrossIters,'EdgeColor','none');hold on;
                    axis xy; axis tight; colormap(jet); view(0,90);
                    hcb2=colorbar;
                    caxis([0,iterations]);
                    set(get(hcb2,'label'),'string','Stability (across iterations)');
                    title(['Channel = ',num2str(channel)]);
                    plot3([length(T.PSD.channels{1,channelVec(1)}.intervals) length(T.PSD.channels{1,channelVec(1)}.intervals)],[0 length(T.PSD.channels{1,channelVec(1)}.intervals)],[1 1],'g','Linewidth',2);
                    plot3([1 length(T.PSD.channels{1,channelVec(1)}.intervals)],[length(T.PSD.channels{1,channelVec(1)}.intervals) length(T.PSD.channels{1,channelVec(1)}.intervals)],[1 1],'g','Linewidth',2);
                    sgtitle(['Stability for K = ',num2str(kVal)]);
                 end
                
                channelCo = channelCo + 1;
            end
%             sgtitle(['Stability for K = ',num2str(kVal)]);
            
            
            set(0,'CurrentFigure',averagedChannel)
            subplot(ceil(sqrt(length(kRange{q}))),floor(sqrt(length(kRange{q}))),kCount);surf(intervalRange{q}, intervalRange{q},prevalenceAcrossChannels/iterations,'EdgeColor','none');hold on;
            axis xy; axis tight; colormap(jet); view(0,90);
            hcb2=colorbar;
            caxis([0,length(channelVec)]);
            set(get(hcb2,'label'),'string','Stability (across channels)');
            title(['K = : ',num2str(kVal)]);
            plot3([length(T.PSD.channels{1,channelVec(1)}.intervals) length(T.PSD.channels{1,channelVec(1)}.intervals)],[0 length(T.PSD.channels{1,channelVec(1)}.intervals)],[30 30],'g','Linewidth',2);
            plot3([1 length(T.PSD.channels{1,channelVec(1)}.intervals)],[length(T.PSD.channels{1,channelVec(1)}.intervals) length(T.PSD.channels{1,channelVec(1)}.intervals)],[30 30],'g','Linewidth',2);
        
        kCount = kCount + 1;
        
        end
        
        sgtitle(['Cross-Channel Stability for Each K Value & ',num2str(iterations),' Iterations']);
        
    end
    
    
    
    
    
    
    
    
    % Load Correct Data
    index = 1;
    
    if methodML(2)
        MCAKvals = figure()
        if TvsNT(1)
            %coeffMatrixT{index} = T.PCA.channels{1,channel}.loading;
            clusterAssignments{index} =T.kMeans.MCA.clusterAssignments;
            index = index + 1;
        end
        if TvsNT(2)
            %coeffMatrixNT{index} = NT.PCA.channels{1,channel}.loading;
            clusterAssignments{index} =NT.kMeans.MCA.clusterAssignments;
        end
        prevalenceAcrossK = zeros(intervalRange{q}(end),intervalRange{q}(end));
        kCount = 1;
        for kVal = kRange{q}
            prevalenceAcrossIters = zeros(intervalRange{q}(end),intervalRange{q}(end));
            for nIters = 1:iterations
                currentClusters = clusterAssignments{q}(:,kVal,nIters);
                currentClusters = repmat(currentClusters,1,length(currentClusters));
                currentClusters = double(currentClusters == currentClusters');
               prevalenceAcrossIters = [prevalenceAcrossIters + currentClusters];
                prevalenceAcrossK = [prevalenceAcrossK + currentClusters];
            end
            
                set(0,'CurrentFigure',MCAKvals)
                subplot(ceil(sqrt(length(kRange{q}))),floor(sqrt(length(kRange{q}))),kCount);surf(intervalRange{q}, intervalRange{q},prevalenceAcrossIters,'EdgeColor','none');hold on;
                axis xy; axis tight; colormap(jet); view(0,90);
                hcb2=colorbar;
                caxis([0,iterations]);
                set(get(hcb2,'label'),'string','Stability (across iterations)');
                title(['K = ',num2str(kVal)]);
                plot3([length(T.PSD.channels{1,channelVec(1)}.intervals) length(T.PSD.channels{1,channelVec(1)}.intervals)],[0 length(T.PSD.channels{1,channelVec(1)}.intervals)],[1 1],'g','Linewidth',2);
                plot3([1 length(T.PSD.channels{1,channelVec(1)}.intervals)],[length(T.PSD.channels{1,channelVec(1)}.intervals) length(T.PSD.channels{1,channelVec(1)}.intervals)],[1 1],'g','Linewidth',2);
           kCount = kCount + 1; 
        end
        sgtitle(['Cross-Iteration Stability for ',num2str(iterations),' Iterations']);
    end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
end

























end