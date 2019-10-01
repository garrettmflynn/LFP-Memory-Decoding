
%% Data Visualization (optional)

 typeViz = 'Spectrum';

% IT IS ESSENTIAL TO SPECIFY SIGNAL AND SPECTRUM INPUTS, AS WELL AS UNITS + RANGES
         for qq = 1:size(dataToInterval,3)
          Signal_Spectrum_Events_Polygons({HHData.Data.LFP.LFP(qq,:),dataToInterval(:,:,qq)}, HHData.Events,parameters,HHData.Channels.sChannels(qq),HHData.Data.Intervals.Times,'Z-Scores', [-5,5], fullfile(parameters.Directories.filePath,['Signal-Spectrum-Events (NewColormap z from log)'],['Channel' num2str(HHData.Channels.sChannels(qq))]));
         end
         

%% Results Visualization
% This script is used to process the modeling results of the LFP MD model
% between Permute-based vs. PCA-based vs. Raw Signal based cases
% Multi-Channle (MCA) case
% Author : Xiwei She
% Date: 29/07/2019


if ~exist('resultsDir', 'var')
    resultsDir = 'C:\Users\flynn\OneDrive - University of Southern California\Office\LFP Decoding\ClipArt_2\Classifier Results [-1 1]';
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

        
        
%% Multi-Panel DATA VISUALIZATION Function
        
function [] = Signal_Spectrum_Events_Polygons(data, allEvents,parameters, channelNumber,intervalTimes,colorUnit, clims, saveDir,logSignal)%,timeBin,freqBin,band)
% Input 1: {Single Row/Channel of LFP Signal, Single Row/Channel of LFP Spectrum}
% Input 2: HHData.Events
% Input 3: parameters
% Input 4: Channel Number
% Input 5: Interval Times
% Input 6: Colorbar Axis Label ('e.g. Percent Change')
% Input 7: Color Limits (e.g. [-500 500])
% Input 8: Save Directory
% Input 9: Apply log to values (Set as 1 if not normalized) or not (as 0 if normalized) 
if nargin < 14
    band = 'Signal';
end


fs = parameters.Derived.samplingFreq;
% Parameters to Load and/or Derive
    dataSignalLFP = data{1};
    spectralData = data{2};
    freq = linspace(parameters.Choices.freqMin,parameters.Choices.freqMax,size(spectralData,1));

if ~exist(saveDir,'dir')
mkdir(saveDir);
end
    
fullRange = [allEvents.FOCUS_ON(1), allEvents.MATCH_RESPONSE(end)];
    %% Initialize Figures
    % Voltage Bounds
    vBound = max(abs([min(dataSignalLFP) max(dataSignalLFP)]));
    
    vBound = vBound*1.2;
    
    % Subplot Pattern
    numRows = 30;
    numCols = 8;
    templateSub = [2:numCols];
    
    firstHalf = templateSub;
    for ii = 1:((numRows/2) - 1)
    firstHalf = [firstHalf, templateSub + numCols*(ii)];
    end
    
    secondHalf = firstHalf + numCols*(numRows/2);
    secondHalf = secondHalf((1*length(templateSub)+1):end);
    
        
    clear lastThirdOG
    
     figFull = figure('Position',[50 50 1700 800],'visible','off');
    h(2) = subplot(numRows,8,firstHalf);
    plot(dataSignalLFP(:,:)','k');
            ylabel('Voltage'); ylim([-vBound vBound])
            xticks([]);
            xlim([0 length(dataSignalLFP)]);
            
    h(3) = subplot(numRows,8,secondHalf);
    
            originalSize1 = get(gca, 'Position');
            
            % Plot the Image
            imagesc([0 length(dataSignalLFP)],freq,spectralData);

            set(gca,'ydir','normal');
            ytickskip = 20:40:length(freq);
            newTicks = (round(freq(ytickskip)));
            yticks(newTicks)
            yticklabels(cellstr(num2str(round((newTicks')))));
            xticks(fs*[0:10:parameters.Derived.durationSeconds]);
            xticklabels((xticks/fs))
            xlabel('Time (s)');
            hcb2=colorbar;
            colormap(redblue);
            ylabel(hcb2,colorUnit);
            caxis(clims);
            ylabel('Frequency') ;
            set(gca, 'Position', originalSize1);
            text( -.275,.75 + .5,['Channel ', num2str(channelNumber)],'Units','Normalized','FontSize',30,'FontWeight','bold');
            
 
            
%% Take Interval Snapshots
intervalWindows = size(intervalTimes,2)/10; % Ten Trials per Window            
            
for iWin = 1:intervalWindows
   start =  1+(10*(iWin-1));
   stop = (10*iWin);
   
   [polyStructure] = polyEvents(allEvents,start,stop,vBound,fs);
   
% Shift Signal

   set(figFull,'CurrentAxes',h(2));
   xlim([(allEvents.FOCUS_ON(start)-1)*fs, (allEvents.MATCH_RESPONSE(stop)+1)*fs]);
   originalSize2 = get(gca, 'Position');
   
   % Polygon Blocks
   patch('Faces',polyStructure.Blocks.polyF,'Vertices',polyStructure.Blocks.polyV,'FaceColor',[0 0 0], 'FaceAlpha',.1); hold on;
   fields = fieldnames(polyStructure.Events);
   numF = length(fields);
   colors = winter(numF);

   for ii = 1:numF
       currentField = fields{ii};
       numEvents = length(polyStructure.Events.(currentField));
       % Create Line Vertices
       firstComp = [polyStructure.Events.(currentField);polyStructure.Events.(currentField)];
       secondComp = zeros(2*numEvents,1);
       secondComp(1:numEvents) = polyStructure.Bounds.bottomY;
       secondComp(numEvents+1:end) = polyStructure.Bounds.topY;
       lineVerts = [firstComp,secondComp];

       faceTemplate = [1,numEvents + 1];
       eventFaces = faceTemplate;
       for jj = 1:numEvents-1
       eventFaces = [eventFaces; faceTemplate + 1*(jj)];
       end
    
   l(ii) = patch('Faces',eventFaces,'Vertices',lineVerts,'FaceColor', colors(ii,:), 'EdgeColor',colors(ii,:),'LineWidth',2);
   name{ii} = currentField;
   end
   legend(l,name,'location','northeastoutside');
   set(gca, 'Position', originalSize2);
   
   % Shift Spectrum
   set(figFull,'CurrentAxes',h(3))
   xlim([(allEvents.FOCUS_ON(start)-1)*fs, (allEvents.MATCH_RESPONSE(stop)+1)*fs]);
   sText = text( -.275,.55+ .5,['Trials ', num2str(start), ' - ',num2str(stop)],'Units','Normalized','FontSize',20);
saveas(figFull,fullfile(saveDir,['Trials ', num2str(start), ' - ',num2str(stop), '.png']));
 delete(sText);
end
close all;
end


function [rasterPolygons] = polyEvents(Events,start,stop,vBound,fs)

if isempty(Events)
    % Rat Data Does Not Contain Events
else
    
    
 % Create Blocks
   trialStarts = Events.FOCUS_ON(start:stop)*fs;
   trialStops = Events.MATCH_RESPONSE(start:stop)*fs;

   templateY = ones(1,length(trialStarts));
   bottomY = -vBound*templateY';
   topY = (-vBound + (vBound*.2))*templateY';
   
   firstInds = [trialStarts,bottomY];
   secInds = [trialStarts,topY];
  thirdInds = [trialStops,topY];
   fourthInds = [trialStops,bottomY];
   
   rasterPolygons.Blocks.polyV = [firstInds;secInds;thirdInds;fourthInds];
   faces = [1,length(firstInds)+1,2*length(firstInds)+1,3*length(firstInds)+1];
   rasterPolygons.Blocks.polyF = faces;
   
   for ii = 1:10-1
   rasterPolygons.Blocks.polyF = [rasterPolygons.Blocks.polyF; ii+faces];
   end
    
   

   % Find Relevant Behaviors
behaviors = fieldnames(Events);
initB = length(behaviors);
eventPool = zeros(1,initB);
for bIter = 1:initB
match = cell2mat(regexpi(behaviors{bIter},{'FOCUS_ON','SAMPLE_ON','SAMPLE_RESPONSE','MATCH_ON','MATCH_RESPONSE'}));
     if ~isempty(match)
 eventPool(bIter) =  match;
     end
end

chosenBehaviors = find(eventPool);
numB = length(chosenBehaviors);

for behavior = 1:numB
    currentBehavior = behaviors{chosenBehaviors(behavior)};
    Y = Events.(currentBehavior);
%% Raster plot
    switch currentBehavior
        case 'FOCUS_ON'
             rasterPolygons.Events.FO = Y(start:stop)*fs;
        case 'SAMPLE_ON'
             rasterPolygons.Events.SO = Y(start:stop)*fs;
        case 'SAMPLE_RESPONSE'
             rasterPolygons.Events.SR = Y(start:stop)*fs;
        case 'MATCH_ON'
             rasterPolygons.Events.MO = Y(start:stop)*fs;
        case 'MATCH_RESPONSE'
             rasterPolygons.Events.MR = Y(start:stop)*fs;
    end       
end

rasterPolygons.Bounds.topY = topY;
rasterPolygons.Bounds.bottomY = bottomY;
end
end

function c = redblue(m)
%REDBLUE    Shades of red and blue color map
%   REDBLUE(M), is an M-by-3 matrix that defines a colormap.
%   The colors begin with bright blue, range through shades of
%   blue to white, and then through shades of red to bright red.
%   REDBLUE, by itself, is the same length as the current figure's
%   colormap. If no figure exists, MATLAB creates one.
%
%   For example, to reset the colormap of the current figure:
%
%             colormap(redblue)
%
%   See also HSV, GRAY, HOT, BONE, COPPER, PINK, FLAG, 
%   COLORMAP, RGBPLOT.
%   Adam Auton, 9th October 2009
if nargin < 1, m = size(get(gcf,'colormap'),1); end
if (mod(m,2) == 0)
    % From [0 0 1] to [1 1 1], then [1 1 1] to [1 0 0];
    m1 = m*0.5;
    r = (0:m1-1)'/max(m1-1,1);
    g = r;
    r = [r; ones(m1,1)];
    g = [g; flipud(g)];
    b = flipud(r);
else
    % From [0 0 1] to [1 1 1] to [1 0 0];
    m1 = floor(m*0.5);
    r = (0:m1-1)'/max(m1,1);
    g = r;
    r = [r; ones(m1+1,1)];
    g = [g; 1; flipud(g)];
    b = flipud(r);
end
c = [r g b]; 
end