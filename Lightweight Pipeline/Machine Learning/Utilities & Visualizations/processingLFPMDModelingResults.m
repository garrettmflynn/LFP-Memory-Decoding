% This script is used to process the modeling results of the LFP MD model
% between Permute-based vs. PCA-based vs. Raw Signal based cases
% Multi-Channle (MCA) case
% Author : Xiwei She
% Date: 29/07/2019



figDir = fullfile(resultsDir,'MCC Figures','Resolutions');
if ~exist(figDir,'dir')
    mkdir(figDir);
end

rPattern = fullfile(resultsDir, 'singleTestResult_*.mat');
rMatch = dir(rPattern);
rNames = {rMatch.name};
if ~isempty(rMatch)
for formatChoice = 1:length(rMatch)
currentTestResult = rNames{formatChoice};

%% Load modeling result
% New Structure:
 %    1D = Input Format ([band]Signal/Spectrum)
 %    2D = Learner
 %    3D = Category
 %    4D = FeatureType
 %    5D = PCA Coefficient
 %    6D = BSpline Resolution
load(fullfile(resultsDir, currentTestResult));
formats(formatChoice) = extractBetween(currentTestResult,'_','.');

% Only Extract MCA
choiceMethod = cResults.MCA;

% Collect All Bands in One Structure
results(formatChoice,:,:,:,:,:) = choiceMethod;
end

% Unpack Dimensions
[numFormats,numLearners,numCategories,numFeatures,numCoeffs,numRes] = size(results);
learners = cResults.MetaData.usedLearners;
categories = cResults.MetaData.usedCategories;
features = cResults.MetaData.caseNames;
resolutions = cResults.MetaData.Resolutions;
coeffs = cResults.MetaData.pcaCoefficients;

if length(unique(resolutions)) > length(unique(coeffs))
x = resolutions;
elseif length(unique(coeffs)) > length(unique(resolutions))
x = coeffs;
else
    disp('Confusion regarding what to put on the x-axis. Manually inspect code');
end

for cChoice = 1:numCategories
for fChoice = 1:numFeatures
f1 = figure('Position', [10 10 900 1200],'visible','off');


numSpots = numFormats*2;
subplotIndices = 1:numSpots/numFormats:numSpots+1;
titleSpace = round(numFormats/4);

for formatChoice = 1:numFormats
    currentFormat = formats{formatChoice};

%% MCC vs. Resolution Plots
% Learners by Features
dataChoice = squeeze(results(formatChoice,:,cChoice,fChoice,:,:));


first = subplotIndices(formatChoice) + titleSpace;
last = subplotIndices(formatChoice+1) -1 + titleSpace;
range = first:last;

ax = subplot(numSpots+titleSpace,1,first:last);
plot(x,dataChoice'); hold on;
xlim([x(1) x(end)]); 
ylim([-1 1]);
title([currentFormat, ' LFP MD performance']);

if formatChoice == 1
originalSize1 = get(gca, 'Position');
legend(learners,'Location','northoutside');
set(ax, 'Position', originalSize1);
end
end
sgtitle([categories{cChoice},' | ', features{fChoice}],'fontweight','bold','FontSize',20);

saveas(f1,fullfile(figDir,[features{fChoice},'_',categories{cChoice},'.png']));
close all;
end
end



figDir2 = fullfile(resultsDir,'MCC Figures','Bars');
if ~exist(figDir2,'dir')
    mkdir(figDir2);
end

%% MCC Bar Plots

for fChoice = 1:numFeatures
f2 = figure('Position', [10 10 900 1200],'visible','off');
for formatChoice = 1:numFormats
    currentFormat = formats{formatChoice};
    
% Learners by Features
dataChoice = squeeze(results(formatChoice,:,:,fChoice,:,:));
dataMax = squeeze(max(permute(dataChoice,[3,1,2])));

% Each row is a separate category
if size(dataMax,2) > 1
    dataMax = dataMax(:);
end

first = subplotIndices(formatChoice) + titleSpace;
last = subplotIndices(formatChoice+1) -1 + titleSpace;
range = first:last;

ax = subplot(numSpots+2,1,first:last);
bar(dataMax', 'FaceColor', 'flat'); hold on;
xticklabels(categories); ylim([-1 1]);
title([' Bar Plot for LFP MD Model | ', currentFormat]);

if formatChoice == 1
originalSize1 = get(gca, 'Position');
legend(learners,'Location','northoutside');
set(ax, 'Position', originalSize1);
end
end

sgtitle(features{fChoice},'fontweight','bold','FontSize','20')

saveas(f2,fullfile(figDir2,[features{fChoice},'.png']));
close all;
end

else
    error('No Results Found');
end





