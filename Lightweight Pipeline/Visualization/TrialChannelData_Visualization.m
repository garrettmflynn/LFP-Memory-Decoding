function [] = TrialChannelData_Visualization(data,labels,channelInfo,saveDir,typeInput)
%% Create Visualization of Signals Across Channels FOR A SPECIFIC MEMORY

if ~exist(saveDir,'dir')
    mkdir(saveDir);
end

channelStandard = channelInfo{1};
iCA1 = channelInfo{1};
iCA3 = channelInfo{1};

categories = fieldnames(labels);
numCats = 1:length(categories);

for cati = numCats
    currentCat = erase(categories{cati},'Label_');
    ccLabels = labels(categories{cati});
    ccIndices = find(ccLabels);
toVisualize = data(ccIndices,:,:);
[t,c,d] = size(toVisualize);

toVisualize = permute(toVisualize,[2,1,3]);
sortedChannels = [toVisualize(ismember(channelStandard,iCA1),:,:);NaN(1,t,d);toVisualize(ismember(channelStandard,iCA3),:,:)];
sortedChannels = permute(sortedChannels,[2,1,3]);
sortedElectNames = [iCA1';NaN;iCA3'];
fig1 = figure('visible','on','units','normalized','outerposition',[0 0 1 1]);
for ii = 1:t
    subplot(ceil(sqrt(t)),ceil(sqrt(t)),ii);imagesc(squeeze(sortedChannels(ii,:,:)));
    title(['Trial ', num2str(ccIndices(ii))])
    caxis([-1*(10^6) 1*(10^6)]);
    yticks([length(iCA1)/2, ((length(iCA1)+1)+length(iCA3)/2)])
    yticklabels({'CA1','CA3'});
    xticks([1,2000,4000]);
    t1 = round(dataML.Times(1,ccIndices(ii)));
    t2 = round(dataML.Times(2,ccIndices(ii)));
    xticklabels({t1,mean([t1,t2],t2)});
    xlabel('Time (s)');
end
sgtitle({'\fontsize{15} Signal Responses: ',['\fontsize{25} \bf',currentCat]});  
saveas(fig1,fullfile(saveDir,[typeInput,'_',currentCat]));        
end
end