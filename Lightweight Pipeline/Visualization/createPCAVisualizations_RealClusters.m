function [] = createPCAVisualizations_RealClusters(score,cluster,typeML,norm,saveDir,fieldLabels,excluded)

coeff2 = squeeze(score(:,1:2,:));
coeff3 = squeeze(score(:,1:3,:));
manyLabeled = [];

% Turn Multiples into Zeros
clusters = cluster(:,1);
for ii = 1:size(cluster,1)
    if sum(~isnan(cluster(ii,:))) > 1
        clusters(ii) = 0;
        manyLabeled = [manyLabeled ii];
    end
end

if nargin < 8
    excluded = [];
end

%% Initialize Figures
pcaFig1 = figure('visible','off','units','normalized','outerposition',[0 0 1 1]);

    if ~exist(saveDir,'dir');
    mkdir(saveDir);
    end

%% Add Data
numClusters = max(max(cluster));
colorScheme = numClusters;

    colors = hsv(colorScheme);
    black = [0 0 0];
    colors = [black ;colors];
    for iters = 1:size(clusters,3)
        fieldLabels = erase(fieldLabels,'Label_');
        legendLabels = ['Multiple Categories'; fieldLabels];

for category = 1:size(colors,1)
    set(0,'CurrentFigure',pcaFig1);
    indices{category} = find(clusters == category-1);
    ax1 = subplot(6,2,3:2:12);scatter(coeff2(indices{category},1),coeff2(indices{category},2),'MarkerFaceColor',colors(category,:)); hold on;
    title('Results using 2 Coefficients');
    clustText = text( 0,-.05,['# of Clusters: ', num2str(numClusters)],'Units','Normalized','FontSize',15);
    if ~isempty(manyLabeled)
    manyText = text( .5,-.05,['# of Many-Labeled (black): ', num2str(length(manyLabeled))],'Units','Normalized','FontSize',15);
    end
    if ~isempty(excluded)
    exText = text( 0,-.1,['Excluded: ', num2str(excluded{1,k})],'Units','Normalized','FontSize',15);
    end
    ax2 = subplot(6,2,4:2:12);scatter3(coeff3(indices{category},1),coeff3(indices{category},2),coeff3(indices{category},3),'MarkerFaceColor',colors(category,:)); hold on;
    title('Results using 3 Coefficients');
    clustText2 = text( 0,-.05,['# of Clusters: ', num2str(numClusters)],'Units','Normalized','FontSize',15);
    if ~isempty(excluded)
    exText2 = text( 0,-.1,['Excluded: ', num2str(excluded{1,k})],'Units','Normalized','FontSize',15);
    end
    if ~isempty(manyLabeled)
    manyText2 = text( .5,-.05,['# of Many-Labeled (black): ', num2str(length(manyLabeled))],'Units','Normalized','FontSize',15);
    end
end
  if ~norm
        name = [typeML];
  else
        name = ['Normalized',typeML];
  end
    sgtitle(['PCA Scatter Plots for ',typeML],'FontWeight','bold','FontSize',30);
    legend(legendLabels);
    
saveas(pcaFig1,fullfile(saveDir,[name,'.png']));
if ~isempty(excluded)
delete(exText);
delete(exText2);
end
if ~isempty(manyLabeled)
    delete(manyText);
delete(manyText2);
end
delete(clustText);
delete(clustText2);

    end
end