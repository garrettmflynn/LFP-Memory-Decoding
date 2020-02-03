
%% Data Visualization (optional)

 typeViz = 'Spectrum';

% IT IS ESSENTIAL TO SPECIFY SIGNAL AND SPECTRUM INPUTS, AS WELL AS UNITS + RANGES
%          for qq = 1:size(HHData.Data.LFP.Spectrum,3)
%           Signal_Spectrum_Events_Polygons({HHData.Data.LFP.LFP(qq,:),HHData.Data.LFP.Spectrum(:,:,qq)}, HHData.Events,parameters,HHData.Channels.sChannels(qq),HHData.Data.Intervals.Times,'dB', [-5,5], fullfile(parameters.Directories.filePath,['Signal-Spectrum-Events (LFP Validation)'],['Channel' num2str(HHData.Channels.sChannels(qq))]));
%          end
%          

%% Results Visualization
% This script is used to process the modeling results of the LFP MD model
% between Permute-based vs. PCA-based vs. Raw Signal based cases
% Multi-Channle (MCA) case
% Author : Xiwei She
% Date: 29/07/2019


if ~exist('resultsDir', 'var')
    resultsDir = 'C:\Users\flynn\Desktop\PiplineImages';
end

figDir = fullfile(resultsDir,'MCC Figures','Resolutions');
if ~exist(figDir,'dir')
    mkdir(figDir);
end

rPattern = fullfile(resultsDir, 'singleTestResult_*.mat');
rMatch = dir(rPattern);
rNames = {rMatch.name};
if ~isempty(rMatch)
if length(rMatch) > 1
    error('Please only leave one results structure in the specified directory');
else
currentTestResult = rNames{1};
end

%% Load modeling result
% New Structure:
 %    1D = Learner
 %    2D = Category
 %    3D = Feature Types
 %    4D = PCA Coefficient
 %    5D = BSpline Resolution
load(fullfile(resultsDir, currentTestResult));
dateTime = extractBetween(currentTestResult,'_','.');

% Only Extract MCA
results = cResults.MCA;

% Unpack Dimensions
[numLearners,numCategories,numFeatures,numCoeffs,numRes] = size(results);
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
f1 = figure('Position', [10 10 900 1200],'visible','off');


numSpots = numFeatures*2;
subplotIndices = 1:numSpots/numFeatures:numSpots+1;
titleSpace = round(numFeatures/4);

for featureChoice = 1:numFeatures
    currentFeature = features{featureChoice};

%% MCC vs. Resolution Plots
% Learners by Features
dataChoice = squeeze(results(:,cChoice,featureChoice,:,:));


first = subplotIndices(featureChoice) + titleSpace;
last = subplotIndices(featureChoice+1) -1 + titleSpace;
range = first:last;

ax = subplot(numSpots+titleSpace,1,first:last);
plot(x,dataChoice'); hold on;
xlim([x(1) x(end)]); 
ylim([-1 1]);
title([features{featureChoice}]);

if featureChoice == 1
originalSize1 = get(gca, 'Position');
legend(learners,'Location','northoutside');
set(ax, 'Position', originalSize1);
end
end
sgtitle([categories{cChoice},' LFP MD performance'],'fontweight','bold','FontSize',20);

saveas(f1,fullfile(figDir,[dateTime{1},'_',categories{cChoice},'.png']));
close all;
end



figDir2 = fullfile(resultsDir,'MCC Figures','Bars');
if ~exist(figDir2,'dir')
    mkdir(figDir2);
end

%% MCC Bar Plots


f2 = figure('Position', [10 10 900 1200],'visible','off');
for featureChoice = 1:numFeatures
    currentFeature = features{featureChoice};
    
% Learners by Features
% Each row becomes a separate bar (within the same group)
dataChoice = squeeze(results(:,:,featureChoice,:,:));
if ndims(dataChoice) == 4
     dataChoice = permute(dataChoice,[4,3,1,2]);
[dataMax,maxLoc] = max(max(abs(dataChoice),[],1,'linear'));
dataMax = squeeze(dataMax);
maxLoc = squeeze(maxLoc);

for r = 1:rows
    for c = 1:cols
    if dataChoice(maxLoc(r,c)) < 0
        dataMax(r,c) = dataMax(r,c)*-1;
    end
    end
end

elseif ndims(dataChoice) == 3
    dataChoice = permute(dataChoice,[3,1,2]);
[dataMax,maxLoc] = max(abs(dataChoice),[],1,'linear');
%absmax = dataChoice(sub2ind(size(dataChoice),index,1:size(dataChoice,2)));

[useless rows cols] = size(maxLoc);
dataMax = squeeze(dataMax);
maxLoc = squeeze(maxLoc);

for r = 1:rows
    for c = 1:cols
    if dataChoice(maxLoc(r,c)) < 0
        dataMax(r,c) = dataMax(r,c)*-1;
    end
    end
end

else
    error('Incorrect Results Format');
end

first = subplotIndices(featureChoice) + titleSpace;
last = subplotIndices(featureChoice+1) -1 + titleSpace;
range = first:last;

ax = subplot(numSpots+titleSpace,1,first:last);
bar(dataMax', 'FaceColor', 'flat'); hold on;
xticklabels(categories); ylim([-1 1]);
title(currentFeature);

if featureChoice == 1
originalSize1 = get(gca, 'Position');
legend(learners,'Location','northoutside');
set(ax, 'Position', originalSize1);
end
end

sgtitle('Bar Plot for LFP MD Model','fontweight','bold','FontSize',20)

saveas(f2,fullfile(figDir2,['Bar Plot_',dateTime{1},'.png']));
close all;

else
    error('No Results Found');
end
