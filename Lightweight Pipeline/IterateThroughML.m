

if exist('dataML', 'var') || exist('HHData','var')
    if exist('HHData','var') && ~exist('dataML', 'var')
        dataML = HHData.ML;
    end
    
    if Kmeans || allBasicClassifiers
        
        if allBasicClassifiers
            resultsDir = fullfile(parameters.Directories.filePath,['Classifier Results [-',num2str(range),' ',num2str(range),']']);
            
            if ~exist(resultsDir,'dir');
                mkdir(resultsDir);
            end
        end
        
        %% K-MEANS SECTION
        % Reshape Matrices
        temp = dataML.Data;
        dataML.Data = [];
        count = 1;
        
        % To use raw or normalized data as base
        for channels = 1:size(temp,3)
            dataML.Data(:,:,channels) = reshape(permute(squeeze(temp(:,:,channels,:)),[3,2,1]),size(temp,4),size(temp,2)*size(temp,1));
        end
        
        if ~bspline
            resChoice = [];
        else
            resChoice = 50:150;
        end
        
        clear temp
        
        % Make Real Clusters Vector
        realCluster = realClusters(dataML.Labels);
        
        saveBars = fullfile(parameters.Directories.filePath,'MCC Bar Plots');
        
        if Raw
            fprintf('Conducting Raw Classification\n');
            % Do SCA KMeans
            
            % fprintf('\nSCA\n');
            % CCAChoices = dataML.Channels.sChannels;
            % [SCA.Raw.clusterIndices] = kMeansClustering(dataML,[1 0 0]);
            % [SCA.Raw.MCC,SCA.Raw.MCC_Categories,orderedClustersSCA] = parseClusterAssignments(dataML,SCA.Raw.clusterIndices, [1 0 0]);
            %
            %
            % if ~exist(fullfile(saveBars,'SCA'),'dir');
            %     mkdir(fullfile(saveBars,'SCA'));
            % end
            % makeMCCBars(SCA.Raw.MCC,SCA.Raw.MCC_Categories,dataML.Labels,[],'SCA',norm(iter),fullfile(saveBars,'SCA'));
            if MCA
                for resolutions_to_retain = resChoice
                    % Do MCA (non-CNN)
                    fprintf('\nMCA\n');
                    CCAChoices = dataML.Channels.sChannels;
                    MCAMatrix = dataML;
                    MCAMatrix.Data  = zeros(size(dataML.Data, 1), size(dataML.Data, 2), length(CCAChoices));
                    for channels = 1:length(CCAChoices)
                        MCAMatrix.Data(:, :, channels) = dataML.Data(:,:,channels);
                    end
                   
                    if normBetweenOneAndZero
                        MCAMatrix.Data = (MCAMatrix.Data - min(min(MCAMatrix.Data)))/(max(max(MCAMatrix.Data))-min(min(MCAMatrix.Data)))
                   end
                    
                    if bspline
                        BSplineInput = MCAMatrix.Data;
                        disp(['Current number of B-Spline knots: ', mat2str(resolutions_to_retain)]);
                        BSOrder = 2;
                        MCA_BSFeatures = InputTensor2BSplineFeatureMatrix(BSplineInput,resolutions_to_retain,BSOrder);
                        MCAMatrix.Data = MCA_BSFeatures;
                    end
                    
                    if Kmeans
                        [MCA.Raw.clusterIndices] = kMeansClustering(MCAMatrix,[0 1 0]);
                        saveBarsMCA= fullfile(saveBars,'MCA');
                        [MCA.Raw.MCC,MCA.Raw.MCC_Categories,collectedClusterings(:,count),excluded{count}] = parseClusterAssignments(MCAMatrix,MCA.Raw.clusterIndices, [0 1 0],{MCAMatrix.Labels,[],'MCA',norm(iter),saveBarsMCA});
                        count = count + 1;
                    end
                    if allBasicClassifiers
                        name = 'MCA';
                        raw = ['Raw',num2str(resolutions_to_retain)];
                        cMCA.(raw) = trainClassifiers(MCAMatrix,learnerTypes,resultsDir,'MCA');
                    end
                end
                plotMCCvsFeatures(cMCA,resChoice,norm(iter),resultsDir,'MCA','BSpline Resolution');
            end
            
            if CA1
                for resolutions_to_retain = resChoice
                    % Do CCA (non-CNN) for CA1
                    fprintf('\nCA1\n');
                    CCAChoices = dataML.Channels.CA1_Channels;
                    MCAMatrix = dataML;
                    MCAMatrix.Data  = zeros(size(dataML.Data, 1), size(dataML.Data, 2), length(CCAChoices));
                    for channels = 1:length(CCAChoices)
                        MCAMatrix.Data(:, :, channels) = dataML.Data(:,:,channels);
                    end
                    
                   if normBetweenOneAndZero
                        MCAMatrix.Data = (MCAMatrix.Data - min(min(MCAMatrix.Data)))/(max(max(MCAMatrix.Data))-min(min(MCAMatrix.Data)))
                   end
                    
                    if bspline
                        BSplineInput = MCAMatrix.Data;
                        disp(['Current number of B-Spline knots: ', mat2str(resolutions_to_retain)]);
                        BSOrder = 2;
                        MCA_BSFeatures = InputTensor2BSplineFeatureMatrix(BSplineInput,resolutions_to_retain,BSOrder);
                        MCAMatrix.Data = MCA_BSFeatures;
                    end
                    
                    
                    if Kmeans
                        [resultsK.CA1.Raw.clusterIndices] = kMeansClustering(MCAMatrix,[0 1 0]);
                        saveBarsCA1= fullfile(saveBars,'CA1');
                        [resultsK.CA1.Raw.MCC,resultsK.CA1.Raw.MCC_Categories,collectedClusterings(:,count),excluded{count}] = parseClusterAssignments(MCAMatrix,resultsK.CA1.Raw.clusterIndices, [0 1 0],{MCAMatrix.Labels,[],'CA1',norm(iter),saveBarsCA1});
                        count = count + 1;
                    end
                    if allBasicClassifiers
                        name = 'CA1';
                        raw = ['Raw',num2str(resolutions_to_retain)];
                        cCA1.(raw) = trainClassifiers(MCAMatrix,learnerTypes,resultsDir,'CA1');
                    end
                    
                end
                plotMCCvsFeatures(cCA1,resChoice,norm(iter),resultsDir,'CA1','BSpline Resolution');
            end
            
            if CA3
                for resolutions_to_retain = resChoice
                    % Do CCA (non-CNN) for CA3
                    fprintf('\nCA3\n');
                    CCAChoices = dataML.Channels.CA3_Channels;
                    MCAMatrix = dataML;
                    MCAMatrix.Data  = zeros(size(dataML.Data, 1), size(dataML.Data, 2), length(CCAChoices));
                    for channels = 1:length(CCAChoices)
                        MCAMatrix.Data(:, :, channels) = dataML.Data(:,:,channels);
                    end
                    
                                        
                   if normBetweenOneAndZero
                        MCAMatrix.Data = (MCAMatrix.Data - min(min(MCAMatrix.Data)))/(max(max(MCAMatrix.Data))-min(min(MCAMatrix.Data)))
                   end
                    
                    if bspline
                        BSplineInput = MCAMatrix.Data;
                        disp(['Current number of B-Spline knots: ', mat2str(resolutions_to_retain)]);
                        BSOrder = 2;
                        MCA_BSFeatures = InputTensor2BSplineFeatureMatrix(BSplineInput,resolutions_to_retain,BSOrder);
                        MCAMatrix.Data = MCA_BSFeatures;
                    end
                    
                    if Kmeans
                        [resultsK.CA3.Raw.clusterIndices] = kMeansClustering(MCAMatrix,[0 1 0]);
                        saveBarsCA3= fullfile(saveBars,'CA3');
                        [resultsK.CA3.Raw.MCC,resultsK.CA3.Raw.MCC_Categories,collectedClusterings(:,count),excluded{count}] = parseClusterAssignments(MCAMatrix,resultsK.CA3.Raw.clusterIndices, [0 1 0],{MCAMatrix.Labels,[],'CA3',norm(iter),saveBarsCA3});
                        count = count + 1;
                    end
                    if allBasicClassifiers
                        name = 'CA3';
                        raw = ['Raw',num2str(resolutions_to_retain)];
                        cCA3.(raw) = trainClassifiers(MCAMatrix,learnerTypes,resultsDir,'CA3');
                    end
                end
                plotMCCvsFeatures(cCA3,resChoice,norm(iter),resultsDir,'CA3','BSpline Resolution');
            end
            
            %% Organize Results
            if Kmeans && ~PCA
                kSave
                
            end
            if allBasicClassifiers
                classSave;
                if ~PCA
                    visualizeClassifierPerformance(results,norm(iter),fullfile(resultsDir,'MCCs'));
                end
            end
        end
        
        
        
        
        
        
        
        
        
        
        
        
        %% Do Everything Again While Iterating Through PCA
        if PCA
            fprintf('Conducting PCA Classification\n');
            savePCA = fullfile(parameters.Directories.filePath,'Scree Plots');
            if ~exist(savePCA,'dir')
                mkdir(savePCA);
            end
            
            savePCAViz = fullfile(parameters.Directories.filePath,'PCA Scatter Plots');
            %% PCA SCA
            % fprintf('Now Conducting PCA on SCA\n');
            % fPCA = figure('visible','off','units','normalized','outerposition',[0 0 1
            % 1]);
            % for channel = 1:length(dataML.Channels.sChannels)
            % [~,scoreSCA(:,:,channel),~,~,explained(:,:,channel),~] = pca(dataML.Data(:,:,channel,:));
            %   subplot(ceil(sqrt(length(dataML.Channels.sChannels))),round(sqrt(length(dataML.Channels.sChannels))),channel);bar(explained(:,:,channel));hold on;
            %   title(num2str(dataML.Channels.sChannels(channel)))
            % end
            % if norm(iter)
            % sgtitle('Normalized Channel-Specific Scree Plot','FontSize',30);
            % % saveas(fPCA, fullfile(savePCA,'NormChannelSpecificScree.png'));
            % % else
            % sgtitle('Channel-Specific Scree Plot','FontSize',30);
            %     saveas(fPCA, fullfile(savePCA,'ChannelSpecificScree.png'));
            % end
            if MCA
                %% PCA MCA
                CCAChoices = dataML.Channels.sChannels;
                for trials = 1:size(dataML.Data,1)
                    temp = squeeze(dataML.Data(trials,:,ismember(dataML.Channels.sChannels,CCAChoices)));
                    if normBetweenOneAndZero
                        temp = (temp - min(min(temp)))/(max(max(temp))-min(min(temp)))
                    end
                    [~,scoreMCA(trials,:,:),~,~,explained,~] = pca(temp');
                end
                
                % fPCA2 =  figure('visible','off','units','normalized','outerposition',[0 0 1 1]);
                % [~,scoreMCA,~,~,explained,~] = pca(MCAMatrix);
                %  bar(explained);
                %   sgtitle('MCA Scree Plot','FontSize',30);
                % if norm(iter)
                %     sgtitle('Normalized MCA Scree Plot','FontSize',30);
                % saveas(fPCA2, fullfile(savePCA,'NormMCAScree.png'));
                % else
                %     sgtitle('MCA Scree Plot','FontSize',30);
                % saveas(fPCA2, fullfile(savePCA,'MCAScree.png'));
                % end
                % clear fPCA2
            end
            
            
            
            if CA1
                %% PCA CCA1
                CCAChoices = dataML.Channels.CA1_Channels;
                for trials = 1:size(dataML.Data,1)
                    temp = squeeze(dataML.Data(trials,:,ismember(dataML.Channels.sChannels,CCAChoices)));
                    if normBetweenOneAndZero
                        temp = (temp - min(min(temp)))/(max(max(temp))-min(min(temp)))
                    end
                    [~,scoreCA1(trials,:,:),~,~,explained,~] = pca(temp');
                end
                
                %  fPCA3 = figure('visible','off','units','normalized','outerposition',[0 0 1 1]);
                % [~,scoreCA1,~,~,explained,~] = pca(MCAMatrix);
                %  bar(explained);hold on;
                %   sgtitle('CA1 Scree Plot','FontSize',30);
                % if norm(iter)
                %     sgtitle('Normalized CA1 Scree Plot','FontSize',30);
                %   saveas(fPCA3, fullfile(savePCA,'NormCA1Scree.png'));
                % else
                %     sgtitle('CA1 Scree Plot','FontSize',30);
                %   saveas(fPCA3, fullfile(savePCA,'CA1Scree.png'));
                % end
                %
                % clear fPCA3
            end
            
            
            
            if CA3
                %% PCA CCA3
                CCAChoices = dataML.Channels.CA3_Channels;
                for trials = 1:size(dataML.Data,1)
                    temp = squeeze(dataML.Data(trials,:,ismember(dataML.Channels.sChannels,CCAChoices)));
                    if normBetweenOneAndZero
                        temp = (temp - min(min(temp)))/(max(max(temp))-min(min(temp)))
                    end
                    [~,scoreCA3(trials,:,:),~,~,explained,~] = pca(temp');
                end
                
                % fPCA4 =  figure('visible','off','units','normalized','outerposition',[0 0 1 1]);
                % [~,scoreCA3,~,~,explained,~] = pca(MCAMatrix);
                %  bar(explained);hold on;
                %   if norm(iter)
                %       sgtitle('Normalized CA3 Scree Plot','FontSize',30);
                %   saveas(fPCA4, fullfile(savePCA,'NormCA3Scree.png'));
                %   else
                %       sgtitle('CA3 Scree Plot','FontSize',30);
                %       saveas(fPCA4, fullfile(savePCA,'CA3Scree.png'));
                %   end
                %
                % clear fPCA4
            end
            %% Iterate Through PCA Components
            
            % dataML.PCA = scoreSCA(:,1:coeffs_to_retain,:);
            %saveDuringML;
            
            %% Do SCA KMeans on PCA
            % fprintf('\Now Clustering SCA\n');
            % [SCA.PCA.clusterIndices] = kMeansClustering(dataML,[0 1 0]);
            % [SCA.PCA.MCC,SCA.PCA.MCC_Categories,SCA.PCA.dominantClusters,prevalence.PCA.SCA] = parseClusterAssignments(dataML, SCA.PCA.clusterIndices,[0 1 0]);
            
            % if ~exist(fullfile(saveBars,'SCA'),'dir');
            %     mkdir(fullfile(saveBars,'SCA'));
            % end
            
            % makeMCCBars(SCA.PCA.MCC,SCA.PCA.MCC_Categories,dataML.Labels,coeffs_to_retain,'SCA',norm(iter), fullfile(saveBars,'SCA'));
            % if ~exist(fullfile(savePCAViz,'SCA'),'dir');
            %     mkdir(fullfile(savePCAViz,'SCA'));
            % end
            % if coeffs_to_retain ==  2
            % orderedClustersSCA_PCA{1} = analyzeClusters(dataML,SCA.PCA.clusterIndices)
            % elseif coeffs_to_retain ==  3
            % orderedClustersSCA_PCA{2} = analyzeClusters(dataML,SCA.PCA.clusterIndices)
            % createPCAVisualizations(scoreSCA,orderedClustersSCA_PCA,'SCA',norm(iter),fullfile(savePCAViz,'SCA'));
            % end
            
            
            if MCA
                %% Do MCA (non-CNN) | PCA
                for resolutions_to_retain = resChoice
                    if ~bspline
                        retained = 1:size(scoreMCA,3);
                    else
                        retained = size(scoreMCA,3);
                    end
                    for coeffs_to_retain = retained
                        fprintf('\nMCA\n');
                        toPermute = scoreMCA(:,:,1:coeffs_to_retain);
                        dataML.PCA = permute(toPermute,[1,3,2]);
                        
                        if bspline
                            BSplineInput = dataML.PCA;
                            disp(['Current number of B-Spline knots: ', mat2str(resolutions_to_retain)]);
                            BSOrder = 2;
                            MCA_BSFeatures = InputTensor2BSplineFeatureMatrix(BSplineInput,resolutions_to_retain,BSOrder);
                            dataML.PCA = MCA_BSFeatures;
                        end
                        
                        
                        
                        if Kmeans
                            [MCA.PCA.clusterIndices] = kMeansClustering(dataML,[0 1 0]);
                            nIters = size(MCA.PCA.clusterIndices,3);
                            
                            saveBarsMCA = fullfile(saveBars,'MCA');
                            [MCA.PCA.MCC,MCA.PCA.MCC_Categories,collectedClusterings(:,count),excluded{count}] = parseClusterAssignments(dataML, MCA.PCA.clusterIndices,[0 1 0],{dataML.Labels,coeffs_to_retain,'MCA',norm(iter),saveBarsMCA});
                            if coeffs_to_retain ==  2
                                PCA2CountMCA = count;
                            elseif coeffs_to_retain ==  3
                                for len = 1:size(collectedClusterings,1)
                                    orderedClustersMCA_PCA = [collectedClusterings(len,PCA2CountMCA) , collectedClusterings(len,count)];
                                    excludedMCA_PCA = {excluded{PCA2CountMCA} , excluded{count}};
                                    label = 'All Above';
                                    createPCAVisualizations(scoreMCA,orderedClustersMCA_PCA,['MCA ' ,label,' ', num2str(nIters-(len-1))],norm(iter),fullfile(savePCAViz,['MCA_' label]),excludedMCA_PCA);
                                    createPCAVisualizations_RealClusters(scoreMCA,realCluster,'MCA Correct Cluster',norm(iter),fullfile(savePCAViz,['CorrectMCA_' label]),fieldnames(dataML.Labels));
                                    
                                end
                            end
                            count = count + 1;
                        end
                        if allBasicClassifiers
                            name = 'MCA';
                            if ~bspline
                                structureName = ['PCA',num2str(coeffs_to_retain)];
                            else
                                structureName = ['Resolution',num2str(resolutions_to_retain)];
                            end
                            results.MCC.MCA.(structureName) = trainClassifiers(dataML,learnerTypes,resultsDir,'MCA',coeffs_to_retain);
                        end
                        
                        if Kmeans
                            kSave;
                        end
                        
                    end
                end
                
                plotMCCvsFeatures(results.MCC.MCA,1:size(scoreMCA,3),norm(iter),resultsDir,'MCA','PCA Coefficients (per channel)');
                
            end
            
            
            
            if CA1
                %% Do CCA (non-CNN) for CA1 | PCA
                for resolutions_to_retain = resChoice
                    if ~bspline
                        retained = 1:size(scoreCA1,3);
                    else
                        retained = size(scoreCA1,3);
                    end
                    for coeffs_to_retain = retained
                        fprintf('\nCA1\n');
                        toPermute = scoreCA1(:,:,1:coeffs_to_retain);
                        dataML.PCA = permute(toPermute,[1,3,2]);
                        if Kmeans
                            [resultsK.CA1.PCA.clusterIndices] = kMeansClustering(dataML,[0 1 0]);
                            nIters = size(resultsK.CA1.PCA.clusterIndices,3);
                            
                            saveBarsCA1= fullfile(saveBars,'CA1');
                            [resultsK.CA1.PCA.MCC,resultsK.CA1.PCA.MCC_Categories,collectedClusterings(:,count),excluded{count}] = parseClusterAssignments(dataML,resultsK.CA1.PCA.clusterIndices, [0 1 0],{dataML.Labels,coeffs_to_retain,'CA1',norm(iter),saveBarsCA1});
                            
                            if coeffs_to_retain ==  2
                                PCA2CountCA1 = count;
                            elseif coeffs_to_retain ==  3
                                for len = 1:size(collectedClusterings,1)
                                    orderedClustersCA1_PCA = [collectedClusterings(len,PCA2CountCA1) , collectedClusterings(len,count)];
                                    excludedCA1_PCA = {excluded{PCA2CountCA1} , excluded{count}};
                                    label = 'All Above';
                                    createPCAVisualizations(scoreCA1,orderedClustersCA1_PCA,['CA1 ' ,label,' ', num2str(nIters-(len-1))],norm(iter),fullfile(savePCAViz,['CA1_' label]),excludedCA1_PCA);
                                    createPCAVisualizations_RealClusters(scoreCA1,realCluster,'CA1 Correct Cluster',norm(iter),fullfile(savePCAViz,['CorrectCA1_' label]),fieldnames(dataML.Labels));
                                    
                                end
                            end
                            count = count + 1;
                        end
                        if allBasicClassifiers
                            name = 'CA1';
                            if ~bspline
                                structureName = ['PCA',num2str(coeffs_to_retain)];
                            else
                                structureName = ['Resolution',num2str(resolutions_to_retain)];
                            end
                            results.MCC.CA1.(structureName) = trainClassifiers(dataML,learnerTypes,resultsDir,'CA1',coeffs_to_retain);
                        end
                        
                        if Kmeans
                            kSave;
                        end
                        
                    end
                end
                plotMCCvsFeatures(results.MCC.CA1,1:size(scoreCA1,3),norm(iter),resultsDir,'CA1','PCA Coefficients (per channel)');
                
            end
            
            
            
            
            
            
            
            
            if CA3
                %% Do CCA (non-CNN) for CA3 | PCA
                for resolutions_to_retain = resChoice
                    if ~bspline
                        retained = 1:size(scoreCA3,3);
                    else
                        retained = size(scoreCA3,3);
                    end
                    for coeffs_to_retain = retained
                        %% Do CCA (non-CNN) for CA3 and PCA
                        fprintf('\nCA3\n');
                        toPermute = scoreCA3(:,:,1:coeffs_to_retain);
                        dataML.PCA = permute(toPermute,[1,3,2]);
                        if Kmeans
                            [resultsK.CA3.PCA.clusterIndices] = kMeansClustering(dataML,[0 1 0]);
                            nIters = size(resultsK.CA3.PCA.clusterIndices,3);
                            
                            saveBarsCA3= fullfile(saveBars,'CA3');
                            [resultsK.CA3.PCA.MCC,resultsK.CA3.PCA.MCC_Categories,collectedClusterings(:,count),excluded{count}] = parseClusterAssignments(dataML,resultsK.CA3.PCA.clusterIndices, [0 1 0],{dataML.Labels,coeffs_to_retain,'CA3',norm(iter),saveBarsCA3});
                            
                            if coeffs_to_retain ==  2
                                PCA2CountCA3 = count;
                            elseif coeffs_to_retain ==  3
                                for len = 1:size(collectedClusterings,1)
                                    orderedClustersCA3_PCA = [collectedClusterings(len,PCA2CountCA3) , collectedClusterings(len,count)];
                                    excludedCA3_PCA = {excluded{:,PCA2CountCA3} , excluded{count}};
                                    label = 'All Above';
                                    createPCAVisualizations(scoreCA3,orderedClustersCA3_PCA,['CA3 ' ,label,' ', num2str(nIters-(len-1))],norm(iter),fullfile(savePCAViz,['CA3_' label]),excludedCA3_PCA);
                                    createPCAVisualizations_RealClusters(scoreCA3,realCluster,'CA3 Correct Cluster',norm(iter),fullfile(savePCAViz,['CorrectCA3_' label]),fieldnames(dataML.Labels));
                                end
                            end
                            count = count + 1;
                        end
                        if allBasicClassifiers
                            name = 'CA3';
                            if ~bspline
                                structureName = ['PCA',num2str(coeffs_to_retain)];
                            else
                                structureName = ['Resolution',num2str(resolutions_to_retain)];
                            end
                            results.MCC.CA3.(structureName) = trainClassifiers(dataML,learnerTypes,resultsDir,'CA3',coeffs_to_retain);
                        end
                        
                        if Kmeans
                            kSave;
                        end
                        
                    end
                end
                plotMCCvsFeatures(results.MCC.CA3,1:size(scoreCA3,3),norm(iter),resultsDir,'CA3','PCA Coefficients (per channel)');
            end
            
            if allBasicClassifiers
                classSave;
                visualizeClassifierPerformance(results,norm(iter),fullfile(resultsDir,'MCCs'));
            end
        end
    end
    
    
    
    % CNN Methods Only
    if CNN_SVM
        CNN_Pipeline;
        processAllClassestoResults(results,'CNN_SVM');
        supervisedDir = fullfile(parameters.Directories.filePath,'CNN Results');
        
        if ~exist(supervisedDir,'dir')
            mkdir(supervisedDir);
        end
        if norm(iter) == 1
            save(fullfile(supervisedDir,[parameters.Directories.dataName, 'ResultsNorm.mat']),'results');
        else
            save(fullfile(supervisedDir,[parameters.Directories.dataName, 'Results.mat']),'results');
        end
    end
end