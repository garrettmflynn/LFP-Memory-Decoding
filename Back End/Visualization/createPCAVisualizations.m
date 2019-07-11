function [] = createPCAVisualizations(score,clusters,typeML,norm,saveDir,excluded)

coeff2 = squeeze(score(:,1:2,:));
coeff3 = squeeze(score(:,1:3,:));
clusters2 = clusters{1};
clusters3 = clusters{2};


%% Initialize Figures
pcaFig1 = figure('visible','off','units','normalized','outerposition',[0 0 1 1]);
pcaFigM = figure('visible','off','units','normalized','outerposition',[0 0 1 1]);

    if ~exist(saveDir,'dir');
    mkdir(saveDir);
    end

%% Add Data
 if iscell(clusters)
[~,kNonZero] = find(clusters2(1,:,end));
existingClusters = 1:size(clusters2,2);
colorScheme = max([max(max(clusters2)) max(max(clusters3))]);
excluded2 = excluded{1};
excluded3 = excluded{2};
 else
existingClusters = max(clusters2);
kNonZero = max(clusters2);
colorScheme = max(clusters2);
numIters = 1;
 end

for k = existingClusters
    colors = hsv(colorScheme);
    black = [0 0 0];
    colors = [black ;colors];
    for iters = 1:size(clusters2,3)
    choice2 = clusters2(:,k,iters);
    choice3 = clusters3(:,k,iters);

for category = 1:size(colors,1)
    set(0,'CurrentFigure',pcaFig1);
    indices2{category} = find(choice2 == category-1);
    indices3{category} = find(choice3 == category-1);
    subplot(6,2,3:2:12);scatter(coeff2(indices2{category},1),coeff2(indices2{category},2),'MarkerFaceColor',colors(category,:)); hold on;
    title('Results using 2 Coefficients');
    clustText = text( 0,-.1,['# of Clusters: ', num2str(max(max(clusters2)))],'Units','Normalized','FontSize',15);
    exText = text( 0,-.2,['Excluded: ', num2str(excluded2{1,k})],'Units','Normalized','FontSize',15);
    subplot(6,2,4:2:12);scatter3(coeff3(indices3{category},1),coeff3(indices3{category},2),coeff3(indices3{category},3),'MarkerFaceColor',colors(category,:)); hold on;
    title('Results using 3 Coefficients');
    clustText2 = text( 0,-.1,['# of Clusters: ', num2str(max(max(clusters3)))],'Units','Normalized','FontSize',15);
    exText2 = text( 0,-.2,['Excluded: ', num2str(excluded3{1,k})],'Units','Normalized','FontSize',15);
end
  if ~norm
        name = [typeML];
  else
        name = ['Normalized',typeML];
  end
    sgtitle(['PCA Scatter Plots for ',typeML],'FontWeight','bold','FontSize',30);
    
saveas(pcaFig1,fullfile(saveDir,[name,'.png']));
delete(exText);
delete(exText2);
delete(clustText);
delete(clustText2);
    end

if size(clusters2,3) > 1
    choice2M = mode(permute(clusters2(:,k,:),[3,1,2]));
    choice3M = mode(permute(clusters3(:,k,:),[3,1,2]));
    
for category = 1:max(choice2M)
     set(0,'CurrentFigure',pcaFigM);
    indices2M{category} = find(choice2M == category);
    indices3M{category} = find(choice3M == category);
    subplot(6,2,3:2:12);scatter(coeff2(indices2M{category},1),coeff2(indices2M{category},2),'MarkerFaceColor',colors(category,:)); hold on;
    title('Results using 2 Coefficients');
    subplot(6,2,4:2:12);scatter3(coeff3(indices3M{category},1),coeff3(indices3M{category},2),coeff3(indices3M{category},3),'MarkerFaceColor',colors(category,:)); hold on;
    title('Results using 3 Coefficients');
end
  if ~norm
        name = [typeML];
  else
        name = ['Normalized',typeML];
  end
    sgtitle(['PCA Scatter Plots for ',typeML,' | Mean'],'FontWeight','bold','FontSize',30);

   
saveas(pcaFigM,fullfile(saveDir,[name,'_Mode.png']));
    
end
end

% If Single Cluster is Passed In
% else
%     
%     [~,kNonZero] = find(clusters2);
% 
% for k = kNonZero
%     colors = hsv(k);
%     choice2 = clusters2;
%     choice3 = clusters3;
% 
% for category = 1:max(choice2)
%     indices2{category} = find(choice2 == category);
%     indices3{category} = find(choice3 == category);
%     subplot(6,2,3:2:12);scatter(coeff2(indices2{category},1),coeff2(indices2{category},2),'MarkerFaceColor',colors(category,:)); hold on;
%     title('Results using 2 Coefficients');
%     subplot(6,2,4:2:12);scatter3(coeff3(indices3{category},1),coeff3(indices3{category},2),coeff3(indices3{category},3),'MarkerFaceColor',colors(category,:)); hold on;
%     title('Results using 3 Coefficients');
% end
%   if ~norm
%         name = [typeML];
%   else
%         name = ['Normalized',typeML];
%   end
%     sgtitle(['PCA Scatter Plots for ',typeML,' | Iteration ', num2str(iters)],'FontWeight','bold','FontSize',30);
%     
% saveas(pcaFig1,fullfile(saveDir,[name,'_Iter',num2str(iters),'.png']));
%     end
%     
%     choice2M = mode(permute(clusters2(:,k,:),[3,1,2]));
%     choice3M = mode(permute(clusters3(:,k,:),[3,1,2]));
%     
% for category = 1:max(choice2M)
%     indices2M{category} = find(choice2M == category);
%     indices3M{category} = find(choice3M == category);
%     subplot(6,2,3:2:12);scatter(coeff2(indices2M{category},1),coeff2(indices2M{category},2),'MarkerFaceColor',colors(category,:)); hold on;
%     title('Results using 2 Coefficients');
%     subplot(6,2,4:2:12);scatter3(coeff3(indices3M{category},1),coeff3(indices3M{category},2),coeff3(indices3M{category},3),'MarkerFaceColor',colors(category,:)); hold on;
%     title('Results using 3 Coefficients');
% end
%   if ~norm
%         name = [typeML];
%   else
%         name = ['Normalized',typeML];
%   end
%     sgtitle(['PCA Scatter Plots for ',typeML,' | Iteration Mean'],'FontWeight','bold','FontSize',30);
%     
% saveas(pcaFigM,fullfile(saveDir,[name,'_Mode.png']));
%     
% end