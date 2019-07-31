
data = featureMatrix.Data; tSNE = tsne(squeeze(data),'Algorithm','exact','distance','cosine','NumDimensions',3);
names = {'Animal','Building','Plant','Tool','Vehicle'};
names2 = {'Mixed','Animal','Building','Plant','Tool','Vehicle'};
realClustsCollapse = cell(size(realClust,1),1);
for ii = 1:size(realClust,1)
    if sum(~isnan(realClust(ii,:))) > 1
      realClustsCollapse{ii} = 'Mixed';
    elseif isnan(realClust(ii,1))
        realClustsCollapse{ii} = 'NaN';   
    else
     realClustsCollapse{ii} = names{realClust(ii,1)};   
    end
end

figure('visible','off');
goodrows = find(~ismember(realClustsCollapse,'NaN'));
cats = double(categorical({realClustsCollapse{goodrows}}));
u = unique(cats,'stable');
colors = jet(length(u)-1);
colors = [0,0,0;colors];
for ii = 1:length(u)
    choice = u(ii);
    choicerows = find(ismember(cats,choice));
figC = scatter3(tSNE(choicerows,1),tSNE(choicerows,2),tSNE(choicerows,3),15,colors(u(ii),:),'filled');hold on;
end
hold off;
legend({names2{u}},'Location','bestoutside');
saveName = [format,' ',featureCounter];
title(saveName);




clusterSave = fullfile(parameters.Directories.filePath,'Real Clusters using tSNE',format);
    if ~exist(clusterSave,'dir');
    mkdir(clusterSave);
    end
    
saveas(figC,fullfile(clusterSave,[saveName,'.png']));

close all;