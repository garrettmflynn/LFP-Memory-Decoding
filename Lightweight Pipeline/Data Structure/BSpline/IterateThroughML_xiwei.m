

if exist('dataML', 'var') || exist('HHData','var')
    if exist('HHData','var') && ~exist('dataML', 'var')
        dataML = HHData.ML;
    end
    
    if Kmeans || allBasicClassifiers
        %% K-MEANS SECTION
        % Reshape Matrices
        temp = dataML.Data;
        dataML.Data = [];
        count = 1;
        
        for channels = 1:size(temp,3)
            dataML.Data(:,:,channels) = reshape(permute(squeeze(temp(:,:,channels,:)),[3,2,1]),size(temp,4),size(temp,2)*size(temp,1));
        end
        
        % Make Real Clusters Vector
        realCluster = realClusters(dataML.Labels);
        
        
        fprintf('Conducting Raw Clustering\n');
        saveBars = fullfile(parameters.Directories.filePath,'MCC Bar Plots');
        
        if Raw
            % Do MCA (non-CNN)
            fprintf('\nMCA\n');
            CCAChoices = dataML.Channels.sChannels;
            MCAMatrix = dataML;
            %             MCAMatrix.Data = [];
            %             for channels = 1:length(CCAChoices)
            %                 MCAMatrix.Data = [MCAMatrix.Data dataML.Data(:,:,channels)];
            %             end
            % Modified by Xiwei
            MCAMatrix.Data  = zeros(size(dataML.Data(:,:,channels), 1), length(dataML.Data(:,:,channels)), length(CCAChoices));
            for channels = 1:length(CCAChoices)
                MCAMatrix.Data(:, :, channels) = dataML.Data(:,:,channels);
            end
            
            BSplineInput = MCAMatrix.Data;
            for coeffs_to_retain = 50:150 % Modified by Xiwei
                disp(['Current number of B-Spline knots: ', mat2str(coeffs_to_retain)]);
                BSOrder = 2;
                MCA_BSFeatures = InputTensor2BSplineFeatureMatrix(BSplineInput,coeffs_to_retain,BSOrder);
                MCAMatrix.Data = MCA_BSFeatures;
                if allBasicClassifiers
                    name = 'MCA';
                    cMCA.Raw = trainClassifiers(MCAMatrix,learnerTypes);
                end
            end
            
            
            %% Organize Results
            if Kmeans && ~PCA
                resultsK = struct();
                %     results.SCA = SCA;
                resultsK.MCA = MCA;
                resultsK.CCA = CCA;
                %results.consistency = consistency;
                resultsDir = fullfile(parameters.Directories.filePath,'Results');
                
            end
            if allBasicClassifiers && ~PCA
                results = struct();
                %results.SCA = cSCA;
                results.MCC.MCA = cMCA;
                resultsDir = fullfile(parameters.Directories.filePath,['Classifier Results [-',num2str(range),' ',num2str(range),']']);
                visualizeClassifierPerformance(results,norm(iter),fullfile(resultsDir,'MCCs'));
            end
            
            % Save if PCA Will Not Occur
            if ~PCA
                if norm(iter) == 1
                    if exist('results','var')
                        save(fullfile(resultsDir,[parameters.Directories.dataName, 'ResultsNorm[-',num2str(range),' ',num2str(range),'].mat']),'results');
                    end
                    if exist('resultsK','var')
                        save(fullfile(resultsDir,[parameters.Directories.dataName, 'ResultsNormK',num2str(coeffs_to_retain),'.mat']),'resultsK');
                    end
                else
                    if exist('results','var')
                        save(fullfile(resultsDir,[parameters.Directories.dataName, 'Results[-',num2str(range),' ',num2str(range),'].mat']),'results');
                    end
                    if exist('resultsK','var')
                        save(fullfile(resultsDir,[parameters.Directories.dataName, 'ResultsK',num2str(coeffs_to_retain),'.mat']),'resultsK');
                    end
                end
            end
            
        end
        
        %% Do Everything Again While Iterating Through PCA
        if PCA
            savePCA = fullfile(parameters.Directories.filePath,'Scree Plots');
            if ~exist(savePCA,'dir');
                mkdir(savePCA);
            end
            
            savePCAViz = fullfile(parameters.Directories.filePath,'PCA Scatter Plots');
            
            %% PCA MCA
            fprintf('\nMCA\n');
            CCAChoices = dataML.Channels.sChannels;
            MCAMatrix = []; % Question Here
            %% Cancelled by Xiwei
            % for channels = 1:length(CCAChoices)
            %    MCAMatrix = [MCAMatrix dataML.Data(:,:,channels)];
            % end
            % Modified by Xiwei
            MCAMatrix = zeros(size(dataML.Data(:,:,channels), 1), length(dataML.Data(:,:,channels)), length(CCAChoices));
            for channels = 1:length(CCAChoices)
                MCAMatrix(:, :, channels) = dataML.Data(:,:,channels);
            end
            
            % Do PCA
            fPCA2 =  figure('visible','off','units','normalized','outerposition',[0 0 1 1]);
            scoreMCA = zeros(size(dataML.Data(:, :, 1), 1), length(CCAChoices)-1, length(CCAChoices));
            for trials = 1:size(dataML.Data(:, :, 1), 1) % for every trial
                [~,scoreMCA_temp,~,~,explained_temp,~] = pca(squeeze(MCAMatrix(trials, :, :))');
                scoreMCA(trials, :, :) = scoreMCA_temp';
            end
            
            % Solution 1: Concatente PCA of MCA into vector
            %             scoreMCA_temp = [];
            %             for tempi = 1:size(scoreMCA, 3)
            %                 scoreMCA_temp = [scoreMCA_temp scoreMCA(:, :, tempi)];
            %             end
            %             scoreMCA = scoreMCA_temp;
            
            %% Iterate Through PCA Components
            % for coeffs_to_retain = [2,3,5,10]
            for coeffs_to_retain = 50:150 % Modified by Xiwei
                disp(['Current number of B-Spline knots: ', mat2str(coeffs_to_retain)]);
                
                
                % Solution 2: Use B-Spline to do data representation
                BSOrder = 2; % Keep as default (2) first
                MCA_BSFeatures = InputTensor2BSplineFeatureMatrix(scoreMCA,coeffs_to_retain,BSOrder);
                
                %% Do MCA (non-CNN) on PCA
                fprintf('MCA\n');
                dataML.PCA = MCA_BSFeatures; % Set B-Spline feature as input
                if allBasicClassifiers
                    name = 'MCA';
                    pcaName = ['PCA',num2str(coeffs_to_retain)];
                    cMCA.(pcaName) = trainClassifiers(dataML,learnerTypes);
                end
                if allBasicClassifiers
                    results = struct();
                    %results.SCA = SCA;
                    results.MCC.MCA = cMCA;
                    %     results.MCC.CA1 = cCA1;
                    %     results.MCC.CA3 = cCA3;
                    resultsDir = fullfile(parameters.Directories.filePath,['Classifier Results [-',num2str(range),' ',num2str(range),']']);
                    visualizeClassifierPerformance(results,norm(iter),fullfile(resultsDir,'MCCs'));
                    
                    
                    if norm(iter) == 1
                        if exist('results','var')
                            save(fullfile(resultsDir,[parameters.Directories.dataName, 'ResultsNorm[-',num2str(range),' ',num2str(range),'].mat']),'results');
                        end
                    else
                        if exist('results','var')
                            save(fullfile(resultsDir,[parameters.Directories.dataName, 'Results[-',num2str(range),' ',num2str(range),'].mat']),'results');
                        end
                    end
                    
                end
                
                clear MCA
                clear cMCA
                
            end
        end
    end
end





% CNN Methods Only
if CNN_SVM
    CNN_Pipeline;
    processAllClassestoResults(results,'CNN_SVM');
    supervisedDir = fullfile(parameters.Directories.filePath,'CNN Results');
    
    if ~exist(supervisedDir,'dir');
        mkdir(supervisedDir);
    end
    if norm(iter) == 1
        save(fullfile(supervisedDir,[parameters.Directories.dataName, 'ResultsNorm.mat']),'results');
    else
        save(fullfile(supervisedDir,[parameters.Directories.dataName, 'Results.mat']),'results');
    end
end
