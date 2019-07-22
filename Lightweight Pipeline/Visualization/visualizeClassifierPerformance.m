
function [] = visualizeClassifierPerformance(results,norm,saveDir)
fprintf(['Now Visualizing Classifier Performance\n']);
if ~exist(saveDir,'dir')
    mkdir(saveDir);
end
    
% The Following Fields Will All Be Filled or All Be Missing
typeFields = fieldnames(results.MCC);
numTypes = length(typeFields);

pcavsrawField = fieldnames(results.MCC.(typeFields{1}));
numRvsP = length(pcavsrawField);

originalResults = results;

%% Create Overall MCC
overallName = 'All Classes';

for jj = 1:numTypes
for kk = 1:numRvsP
    learnerFields = fieldnames(originalResults.MCC.(typeFields{jj}).(pcavsrawField{kk}));
    numLearners =  length(learnerFields);
for zz = 1:numLearners
    labelFields = fieldnames(originalResults.MCC.(typeFields{jj}).(pcavsrawField{kk}).(learnerFields{zz}));
    numLabels = length(labelFields);
for ii = 1:numLabels
if typeFields{jj} == 'SCA'
multiClassVector(ii,:) = originalResults.MCC.(typeFields{jj}).(pcavsrawField{kk}).(learnerFields{zz}).(labelFields{ii});
else
multiClassVector(ii) = originalResults.MCC.(typeFields{jj}).(pcavsrawField{kk}).(learnerFields{zz}).(labelFields{ii});
end
end
meanForAll = nanmean(multiClassVector);
overallName = 'All_Classes';
results.MCC.(typeFields{jj}).(pcavsrawField{kk}).(learnerFields{zz}).(overallName) = meanForAll;
clear multiClassVector
end
end
end



%% Plot All MCCs Together
newLabelFields = [overallName;labelFields];

for kk = 1:numRvsP
    barFig1 = figure('visible','off','units','normalized','outerposition',[0 0 1 1]);
for jj = 1:numTypes
    learnerFields = fieldnames(results.MCC.(typeFields{jj}).(pcavsrawField{kk}));
    numLearners =  length(learnerFields);
for zz = 1:numLearners
    labelFields = fieldnames(results.MCC.(typeFields{jj}).(pcavsrawField{kk}).(learnerFields{zz}));
    numLabels = length(labelFields);
for ii = 1:numLabels
% Each Row is a New Group
if strcmp(newLabelFields{ii},overallName)
choiceOfMCC = results.MCC.(typeFields{jj}).(pcavsrawField{kk}).(learnerFields{zz}).(newLabelFields{ii});
else
    choiceOfMCC = results.MCC.(typeFields{jj}).(pcavsrawField{kk}).(learnerFields{zz}).(newLabelFields{ii});
end
barGroupedByClass(ii,zz) = choiceOfMCC;
end
end

% Add Title
if ~norm
        name = [pcavsrawField{kk}];
else
name = ['Normalized_',pcavsrawField{kk}];
end
sgtitle([strrep(name,'_',' '),' Data'],'FontSize',30,'fontweight','bold');

% Add Subplots
barLabels = erase(learnerFields,'Label_');
if jj == 2
h = subplot(12,1,(3*(jj-1)+3):((3*jj)+2)); bar(categorical(strrep(newLabelFields,'_',' ')),barGroupedByClass); hold on;
elseif jj == 3
    h = subplot(12,1,(3*(jj-1)+4):((3*jj)+3)); bar(categorical(strrep(newLabelFields,'_',' ')),barGroupedByClass); hold on;
else
    h = subplot(12,1,(2:((3*jj)+1))); bar(categorical(strrep(newLabelFields,'_',' ')),barGroupedByClass); hold on;
end
ylim([-1 1]);
ylabel('MCC');
set(gca,'FontSize',10,'fontweight','bold');
if jj == 1
    originalSize1 = get(gca, 'Position');
legend(barLabels,'Location','northeastoutside');
set(h, 'Position', originalSize1); % Can also use gca instead of h1 if h1 is still active.
end
if jj ~= 3
    %xticks([]);
end
title(typeFields{jj},'FontSize',20);
end


saveas(barFig1,fullfile(saveDir,[name,'.png']));
close all
end
end
    
    

    


