    
function [] = plotMCCvsFeatures(resultsForPCA,coeffs_retained,norm,saveDir,mlType,independentVar)
    
    fprintf(['Now Visualizing MCC as a function of Feature #\n']);
    saveDir = fullfile(saveDir,['MCCvs',independentVar]);
if ~exist(saveDir,'dir')
    mkdir(saveDir);
end
typeFields = fieldnames(resultsForPCA);
    numRvsP = length(typeFields);
    
% The Following Fields Will All Be Filled or All Be Missing
originalResults = resultsForPCA;

%% Create Overall MCC
overallName = 'All Classes';
for kk = 1:numRvsP
learnerFields = fieldnames(originalResults.(typeFields{kk}));
    numLearners =  length(learnerFields);
for zz = 1:numLearners
    labelFields = fieldnames(originalResults.(typeFields{kk}).(learnerFields{zz}));
    numLabels = length(labelFields);
for ii = 1:numLabels
multiClassVector(ii) = originalResults.(typeFields{kk}).(learnerFields{zz}).(labelFields{ii});
end
meanForAll = nanmean(multiClassVector);
overallName = 'All_Classes';
resultsForPCA.(typeFields{kk}).(learnerFields{zz}).(overallName) = meanForAll;
clear multiClassVector
end
end


%% Plot All MCCs Together
    
    
    barFig1 = figure('visible','off','units','normalized','outerposition',[0 0 1 1]);
    
    
    % Add Title
if ~norm
        name = ['Raw_',mlType];
else
name = ['Percent Change_', mlType];
end

sgtitle([mlType, ' | The Effect of ',independentVar,' on MCCs | ',erase(name,['_',mlType])],'fontweight','bold');

learnerFields = fieldnames(originalResults.(typeFields{kk}));
    numLearners =  length(learnerFields);
for zz = 1:numLearners
    labelFields = fieldnames(resultsForPCA.(typeFields{kk}).(learnerFields{zz}));
    numLabels = length(labelFields);
for ii = 1:numLabels
    for kk = 1:numRvsP
    choiceOfMCC(ii,kk,zz) = resultsForPCA.(typeFields{kk}).(learnerFields{zz}).(labelFields{ii});
    end
end
end

lineLabels = learnerFields;

for ii = 1:numLabels
    h = subplot(round(numLabels/2),round(numLabels/ceil(numLabels/2)),ii); plot(coeffs_retained,squeeze(choiceOfMCC(ii,:,:))); hold on;
    title(strrep(labelFields{ii},'_',' '));
    ylim([-1 1]);
    xlim([coeffs_retained(1),coeffs_retained(end)]);
    xlabel(independentVar);
    ylabel('MCC');
    
    if ii == 2
    originalSize1 = get(gca, 'Position');
legend(lineLabels,'Location','northeastoutside');
set(h, 'Position', originalSize1); % Can also use gca instead of h1 if h1 is still active.
    end

end


  
saveas(barFig1,fullfile(saveDir,[name,'.png']));
end
    
    