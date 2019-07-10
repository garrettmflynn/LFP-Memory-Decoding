function [] = createPCAVisualizations(score,clusters,typeML,norm,saveDir)

coeff2 = squeeze(score(:,1:2,:));
coeff3 = squeeze(score(:,1:3,:));
clusters2 = clusters{1};
clusters3 = clusters{2};


%% Initialize Figures
pcaFig1 = figure('visible','off','units','normalized','outerposition',[0 0 1 1]);
pcaFigM = figure('visible','off','units','normalized','outerposition',[0 0 1 1]);

%% Add Data
 if ismatrix(clusters2)
[~,kNonZero] = find(clusters2(1,:,end));
 else
kNonZero = max(clusters2);
 end
 
for k = kNonZero
    colors = hsv(k);
    for iters = 1:size(clusters2,3)
    choice2 = clusters2(:,k,iters);
    choice3 = clusters3(:,k,iters);

for category = 1:max(choice2)
    indices2{category} = find(choice2 == category);
    indices3{category} = find(choice3 == category);
    subplot(6,2,3:2:12);scatter(coeff2(indices2{category},1),coeff2(indices2{category},2),'MarkerFaceColor',colors(category,:)); hold on;
    title('Results using 2 Coefficients');
    subplot(6,2,4:2:12);scatter3(coeff3(indices3{category},1),coeff3(indices3{category},2),coeff3(indices3{category},3),'MarkerFaceColor',colors(category,:)); hold on;
    title('Results using 3 Coefficients');
end
  if ~norm
        name = [typeML];
  else
        name = ['Normalized',typeML];
  end
    sgtitle(['PCA Scatter Plots for ',typeML,' | Iteration ', num2str(iters)],'FontWeight','bold','FontSize',30);
    
saveas(pcaFig1,fullfile(saveDir,[name,'_Iter',num2str(iters),'.png']));
    end
    
    choice2M = mode(permute(clusters2(:,k,:),[3,1,2]));
    choice3M = mode(permute(clusters3(:,k,:),[3,1,2]));
    
for category = 1:max(choice2M)
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
    sgtitle(['PCA Scatter Plots for ',typeML,' | Iteration Mean'],'FontWeight','bold','FontSize',30);
    
saveas(pcaFigM,fullfile(saveDir,[name,'_Mode.png']));
    
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