
function [] = visualizeClassifierPerformance(results,norm,saveDir);
fprintf(['Now Visualizing Classifier Performance\n']);
if ~exist(saveDir,'dir');
    mkdir(saveDir);
end
    
typeFields = fieldnames(results.MCC);
pcavsrawField = fieldnames(results.MCC.(typeFields{1}));
learnerFields = fieldnames(results.MCC.(typeFields{1}).(pcavsrawField{1}));
labelFields = fieldnames(results.MCC.(typeFields{1}).(pcavsrawField{1}).(learnerFields{1}));
numLabels = length(labelFields);
numTypes = length(typeFields);
numRvsP = length(pcavsrawField);
numLearners =  length(learnerFields);

%% Create Overall MCC
overallName = 'All Classes';

for jj = 1:numTypes
for kk = 1:numRvsP
for zz = 1:numLearners
for ii = 1:numLabels
if typeFields{jj} == 'SCA'
multiClassVector(ii,:) = results.MCC.(typeFields{jj}).(pcavsrawField{kk}).(learnerFields{zz}).(labelFields{ii});
else
multiClassVector(ii) = results.MCC.(typeFields{jj}).(pcavsrawField{kk}).(learnerFields{zz}).(labelFields{ii});
end
end
meanForAll = nanmean(multiClassVector);
nans = isnan(multiClassVector);
overallName = 'All_Classes';
if sum(sum(nans)) > 1
numNans = sum(nans);
results.MCC.(typeFields{jj}).(pcavsrawField{kk}).(learnerFields{zz}).(overallName){2} = ['numNans = ' num2str(numNans)];
end
results.MCC.(typeFields{jj}).(pcavsrawField{kk}).(learnerFields{zz}).(overallName){1} = meanForAll;
end
end
end



%% Plot All MCCs Together
newLabelFields = [overallName;labelFields];

for kk = 1:numRvsP
    barFig1 = figure('visible','on','units','normalized','outerposition',[0 0 1 1]);
for jj = 1:numTypes
for zz = 1:numLearners
for ii = 1:(numLabels + 1)
% Each Row is a New Group
if strcmp(newLabelFields{ii},overallName)
choiceOfMCC = results.MCC.(typeFields{jj}).(pcavsrawField{kk}).(learnerFields{zz}).(newLabelFields{ii}){1};
else
    choiceOfMCC = results.MCC.(typeFields{jj}).(pcavsrawField{kk}).(learnerFields{zz}).(newLabelFields{ii});
end
barGroupedByClass(ii,zz) = choiceOfMCC;
end
end

barLabels = erase(learnerFields,'Label_')
subplot(3,1,jj); bar(categorical(strrep(newLabelFields,'_',' ')),barGroupedByClass); hold on;
ylim([-1 1]);
set(gca,'FontSize',10,'fontweight','bold');
if jj == 1
legend(barLabels,'Location','northeastoutside');
end
title(typeFields{jj},'FontSize',20);
end

if ~norm
        name = [pcavsrawField{kk}];
else
name = ['Normalized_',pcavsrawField{kk}];
end
sgtitle(['MCCs for '  strrep(name,'_',' ')],'FontSize',30,'fontweight','bold');


saveas(barFig1,fullfile(saveDir,[name,'.png']));
clear barFig1
end
end
    
    

    


