function [] = makeMCCBars(MCC,MCC_Categories,labels,pca,typeML,norm,saveDir)




k = 5;
fields = fieldnames(labels);



%% Initialize Figure
    barFig1 = figure('visible','off','units','normalized','outerposition',[0 0 1 1]);
     %text(.25,1.02,['MCCs for ',typeML],'Units','Normalized','FontSize',30,'FontWeight','bold');
    
    
    if ~norm
        if ~isempty(pca)
        txt = ['PCA ',num2str(pca)];
        name = [typeML,'_',num2str(pca)];
        else
        txt = ['Raw'];
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
 sgtitle(['\fontsize{30} MCCs for ',typeML, char(10) ...
    '\fontsize{20} ',txt, char(10)],'interpreter','tex');   
    %'\fontsize{20} Mixed_{\fontsize{8} underscore}'],'interpreter','tex');   
        
        
        

 %% MCC Subplot
        subplot(1,4,1);bar(mean(MCC(k,:),2)); hold on;
        ylim([-1 1]);
        errorbar(mean(MCC(k,:),2),std(MCC(k,:),0,2) ,'.');
        XTickLabel=k;
set(gca, 'XTickLabel', k,'FontSize',20);

        

subplot(1,4,2:4);bar(mean(squeeze(MCC_Categories(k,:,:)),2)); hold on;
ylim([-1 1]);
errorbar(mean(squeeze(MCC_Categories(k,:,:)),2),std(squeeze(MCC_Categories(k,:,:)),0,2) ,'.');
XTickLabel=erase(fields,'Label_');
set(gca, 'XTickLabel', XTickLabel,'FontSize',20);

yticks([]);

saveas(barFig1,fullfile(saveDir,[name,'.png']));
end