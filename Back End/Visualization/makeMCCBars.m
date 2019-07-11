function [] = makeMCCBars(MCC,MCC_Categories,labels,pca,typeML,norm,saveDir,reconstruction)

if nargin > 7
    MCC_Reconstruction = reconstruction{1};
    MCC_Categories_Reconstruction = reconstruction{2};
end

fields = fieldnames(labels);



%% Initialize Figure
barFig1 = figure('visible','off','units','normalized','outerposition',[0 0 1 1]);
%text(.25,1.02,['MCCs for ',typeML],'Units','Normalized','FontSize',30,'FontWeight','bold');

%% MCC Subplot
if nargin > 7
    index = find(MCC_Reconstruction);
    [index2,~] = find(MCC);
    index2 = unique(index2);
     [index3,~] = find(MCC);
    index3 = unique(index3);
    [index4,~] = find(MCC_Categories_Reconstruction,1);
    % Construct Bar Comparisons
 nbars = size(MCC_Reconstruction,1) + 1;
    loc = 2:(length(mean(squeeze(MCC_Categories(index3,:,:)),2)) + 1);
    constructBarComparisons = nan(length(loc) + length(index2), nbars);
    addC = [mean(MCC(index2,:),2)];
    addS = [std(MCC(index2,:),0,2)];
    addM =  addC;
    for nb = 2:nbars
    addM = [addM NaN];
    addS = [addS NaN];
    end
    addC = [addC;MCC_Reconstruction(index)];
    constructBarComparisons(1,1:size(addC,1)) = addC;
    constructErrorBarPos(1,1:length(addM)) = addM;
    constructErrorBarSTD(1,1:length(addS)) = addS;
    for row = loc-1
    addC = mean(squeeze(MCC_Categories(index3,row,:)));
    addS = std(squeeze(MCC_Categories(index3,row,:)));
    addM = addC;
    for nb = 1:nbars
    addM = [addM NaN];
    addS = [addS NaN];
    end
    addC = [addC; MCC_Categories_Reconstruction(:,row)];
    constructBarComparisons(row+1,1:length(addC)) = addC;
    constructErrorBarPos(row+1,1:length(addM)) = addM;
    constructErrorBarSTD(row+1,1:length(addS)) = addS;
    end
    
    hb = bar(1:loc(end),constructBarComparisons); hold on;
    
    ngroups = loc(end);
% Calculating the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, constructErrorBarPos(:,i), constructErrorBarSTD(:,i), '.k');
end
    
    ylim([-1 1]);
XTickLabel=[{num2str(index2)}; erase(fields,'Label_')];
set(gca, 'XTickLabel', XTickLabel,'FontSize',20);
legendLabels{1} = 'From Multiple Iterations';
 iters = size(MCC,2);
for nb = 2:nbars
legendLabels{nb} = ['From Reconstructed Clusters | ' , num2str(iters - (nb-2)),'+ Iterations'];
end
legend(legendLabels);
else
    [index2,~] = find(MCC);
    index2 = unique(index2);
     [index3,~] = find(MCC);
    index3 = unique(index3);
    % Construct Bar Comparisons
 
    loc = 2:(length(mean(squeeze(MCC_Categories(index3,:,:)),2)) + 1);
    constructBarComparisons = nan(length(loc )+ length(index2), 1)
    addC = mean(MCC(index2,:),2);
    constructBarComparisons(1,1:size(addC,2)) = addC;
    addM =  mean(MCC(index2,:),2);
    addS = std(MCC(index2,:),0,2);
    constructErrorBarPos(1,1:length(addM)) = addM;
    constructErrorBarSTD(1,1:length(addS)) = addS;
    for row = loc-1
        addC = mean(squeeze(MCC_Categories(index3,row,:)));
    constructBarComparisons(row+1,1:length(addC)) = addC;
    addM = mean(squeeze(MCC_Categories(index3,row,:)));
    addS = std(squeeze(MCC_Categories(index3,row,:)));
    constructErrorBarPos(row+1,1:length(addM)) = addM;
    constructErrorBarSTD(row+1,1:length(addS)) = addS;
    end
    
    hb = bar(1:loc(end),constructBarComparisons); hold on;
    
    ngroups = loc(end);
nbars = 1;
% Calculating the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, constructErrorBarPos(:,i), constructErrorBarSTD(:,i), '.k');
end
    %errorbar(constructErrorBarPos,constructErrorBarSTD ,'.');
    legendLabels = {'From Multiple Iterations'};
    
    ylim([-1 1]);
XTickLabel=[{num2str(index2)}; erase(fields,'Label_')];
set(gca, 'XTickLabel', XTickLabel,'FontSize',20);
legend(legendLabels);
end

%% Generate Title

if ~norm
    if ~isempty(pca)
        txt = ['PCA ',num2str(pca)];
        name = [typeML,'_',num2str(pca)];
    else
        txt = 'Raw';
        name = [typeML,'_Raw'];
    end
else
    if ~isempty(pca)
        txt = ['Normalized PCA ',num2str(pca)];
        name = ['Normalized',typeML,'_',num2str(pca)];
    else
        txt = ['Normalized Raw'];
        name = ['Normalized',typeML,'_Raw'];
    end
end
title(['\fontsize{30} MCCs for ',typeML, char(10) ...
    '\fontsize{20} ',txt, char(10)],'interpreter','tex');
%'\fontsize{20} Mixed_{\fontsize{8} underscore}'],'interpreter','tex');


saveas(barFig1,fullfile(saveDir,[name,'.png']));
end