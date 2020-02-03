
%% Prepare For ML
% This script allows for Memory Decoders to do the following with HHData structures:
%   - Create Bands
%   - Normalize Data
%   - Generate Intervals
%
% All of these changes are then saved into a dataML variable for use in
% iterateThroughML.m

                                                                            % Project: USC RAM
                                                                            % Author: Garrett Flynn
                                                                            % Date: July 26th, 2019

  %% Extract Images if Desired
for ii = 1:length(dataFormat)
    choiceFull = dataFormat{ii};
if ~isempty(regexpi(choiceFull,'Spectrum','ONCE'))
%% All Bands
    if ~isempty(cell2mat(regexpi(choiceFull,{'theta','alpha','beta','lowGamma','highGamma'})))
        form = 'bandSpectrum';
        bandType = erase(choiceFull,'Spectrum');
        spectrumFrequencies = HHData.Data.Parameters.SpectrumFrequencies;
        [HHData] = bandSpectrum(HHData,spectrumFrequencies,bandType,parameters.Choices.bandAveragedPower);
        if norm(iter) 
            dataToInterval = normalize(HHData.ML.(choiceFull),'STFT',form,output);
        else
            dataToInterval = HHData.ML.(choiceFull);
        end
        centers = HHData.Events.(centerEvent);
        
        if parameters.Channels.quickDebug
            numIntervals = 3;
        else
        numIntervals = length(centers);
        end
        
        
[dataML.(choiceFull), HHData.Data.Intervals.Times] = makeIntervals(dataToInterval,centers(1:numIntervals),HHData.Data.Parameters.Choices.trialWindow,HHData.Data.Parameters.SpectrumTime,'Spectrum'); 
%% Just Spectrum  
    else
        form = 'Spectrum';
       if norm(iter) 
            [dataToInterval] = normalize(HHData.Data.LFP.Spectrum,'STFT',form,output);
        else
            dataToInterval = HHData.Data.LFP.Spectrum;
       end
centers = HHData.Events.(centerEvent);

        if parameters.Channels.quickDebug
            numIntervals = 3;
        else
        numIntervals = length(centers);
        end
        
        [dataML.(choiceFull), HHData.Data.Intervals.Times] = makeIntervals(dataToInterval,centers(1:numIntervals),HHData.Data.Parameters.Choices.trialWindow,HHData.Data.Parameters.SpectrumTime,'Spectrum');
        normed.Spectrum = dataToInterval;
    end
    
    
end



if ~isempty(regexpi(choiceFull,'Signal','ONCE'))
    form = 'Signal';
%% Signal Bands
     if ~isempty(cell2mat(regexpi(choiceFull,{'theta','alpha','beta','lowGamma','highGamma'})))
        bandType = erase(choiceFull,'Signal');
        spectrumFrequencies = HHData.Data.Parameters.SpectrumFrequencies; 
        fs = HHData.Data.Parameters.SamplingFrequency;
        [HHData] = bandSignal(HHData,spectrumFrequencies,fs,bandType);
        if norm(iter) 
            dataToInterval = normalize(HHData.ML.(choiceFull),'STFT',form);
        else
            dataToInterval = HHData.ML.(choiceFull);
        end
        centers = HHData.Events.(centerEvent);
        
                if parameters.Channels.quickDebug
            numIntervals = 3;
        else
        numIntervals = length(centers);
                end
        
        [dataML.(choiceFull),HHData.Data.Intervals.Times] = makeIntervals(dataToInterval,centers(1:numIntervals),HHData.Data.Parameters.Choices.trialWindow,HHData.Data.Parameters.SamplingFrequency,'Signal'); 

        
%% Just Signal
     else
       if norm(iter) 
            dataToInterval = normalize(HHData.Data.LFP.LFP,'STFT',form,output);
        else
            dataToInterval = HHData.Data.LFP.LFP;
       end
        centers = HHData.Events.(centerEvent);
        
                if parameters.Channels.quickDebug
            numIntervals = 3;
        else
        numIntervals = length(centers);
                end
        
[dataML.(choiceFull),HHData.Data.Intervals.Times] = makeIntervals(dataToInterval,centers(1:numIntervals),HHData.Data.Parameters.Choices.trialWindow,HHData.Data.Parameters.SamplingFrequency,'Signal'); 
     normed.LFP = dataToInterval;
     end
    clear dataToInterval
end
end

  

%% Only Keep a Small Sampling of Additional Parameters
dataML.Channels = HHData.Channels;
dataML.Directory = parameters.Directories.filePath;
if parameters.isHuman
dataML.Labels = HHData.Labels;
dataML.WrongResponse = find(HHData.Data.Intervals.Outcome == 0);
end
dataML.Times = HHData.Data.Intervals.Times;

% Visualize as needed
for qq = 1:size(HHData.Data.LFP.Spectrum,3)
    Signal_Spectrum_Events_Polygons({HHData.Data.Voltage.Raw(qq,:),normed.LFP(qq,:),normed.Spectrum(:,:,qq)}, HHData.Events,parameters,HHData.Channels.sChannels(qq),HHData.Data.Intervals.Times,'Z-Score', 'norm', fullfile(parameters.Directories.filePath,'Signal-Spectrum-Events (LFP Validation)',['Channel' num2str(HHData.Channels.sChannels(qq))]),'Event',centerEvent);%'Trial',10);
    Signal_Spectrum_Events_Polygons({HHData.Data.Voltage.Raw(qq,:),HHData.Data.LFP.LFP(qq,:),HHData.Data.LFP.Spectrum(:,:,qq)}, HHData.Events,parameters,HHData.Channels.sChannels(qq),HHData.Data.Intervals.Times,'dB', 'raw', fullfile(parameters.Directories.filePath,'Signal-Spectrum-Events (LFP Validation)',['Channel' num2str(HHData.Channels.sChannels(qq))]),'Event',centerEvent);%'Trial',10);
end

%% Function Repository

%% Make Intervals
function [sampledData,intervalMatrix] = makeIntervals(data,centerEventVector,trialSegmentationWindow,sampling,sigOrSpec)
% This file is used to generate interval windows for data processing

%% If Data is Time-Series
if strcmp(sigOrSpec,'Signal')
    

[channels,~] = size(data);

centerPoint = centerEventVector(1)*sampling;
    start = (centerEventVector(1)+trialSegmentationWindow(1))*sampling;
    aroundRange = centerPoint - start;
    stop = centerPoint + aroundRange;
intervalSize = (stop - start)+1;
numIntervals = length(centerEventVector);

sampledData = NaN(1,intervalSize,channels,numIntervals);
for q = 1:numIntervals
centerPoint = round(centerEventVector(q)*sampling);
    start = centerPoint - aroundRange;
    stop = centerPoint + aroundRange;
    
    intervalMatrix(1,q) = round(start/sampling);
    intervalMatrix(2,q) = round(stop/sampling);

if ~(start == stop)
    sampledData(1,:,:,q) = data(:,start:stop)';
end
end


%% Spectral Data (time sampling)

elseif strcmp(sigOrSpec,'Spectrum')
    
    
% Subcases  
if ndims(data) == 3
[freqs,~,channels] = size(data);
else  
[freqs,~] = size(data);
channels = 1;
end

    
    
    numIntervals = length(centerEventVector);
    centerPoint = closest(sampling,centerEventVector(1));
    start = closest(sampling,centerEventVector(1)+trialSegmentationWindow(1));
    aroundRange = centerPoint - start;
    stop = centerPoint + aroundRange;
intervalSize = (stop - start)+1;

sampledData = NaN(freqs,intervalSize,channels,numIntervals);

for q = 1:numIntervals
    centerPoint = closest(sampling,centerEventVector(q));
    start = centerPoint - aroundRange;
    stop = centerPoint + aroundRange;
    
    intervalMatrix(1,q) = sampling(start);
    intervalMatrix(2,q) = sampling(stop);
    
if ~(start == stop)
    for ii = 1:channels
    sampledData(:,:,ii,q) = data(:,start:stop,ii);
    end
end
end
end

function [idx, val] = closest(testArr,val)
tmp = abs(testArr - val);
[~, idx] = min(tmp);
val = testArr(idx);
end

end

%% Normalize
function [norm] = normalize(LFP_Data,dataMethod,dataFormat,outputFormat)
if strncmp(dataMethod,'STFT',4)
switch dataFormat

%% Signal Normalization | STFT | Percent Change
   case 'Signal'
for channels = 1:size(LFP_Data,1)
    channelMu = mean(LFP_Data(channels,:));
    freqSig = std(LFP_Data(channels,:));   
    inputToModify = LFP_Data(channels,:);
    if strcmp(outputFormat,'percentChange')
    LFP_Signal(channels,:) = 100*(inputToModify - channelMu)/channelMu;
    end
    if strcmp(outputFormat,'zScore')
       LFP_Signal(channels,:) = (inputToModify - channelMu)/freqSig;
    end
end
norm = LFP_Signal;
    %% Spectrum | STFT | MultiChannel | Percent Change
    case 'Spectrum'
            fprintf('Now Creating Normalized Data\n');
            if ndims(squeeze(LFP_Data)) == 3
                
                frequencyMu = squeeze(mean(permute(LFP_Data,[2,1,3])));   
                freqSig = squeeze(std(permute(LFP_Data,[2,1,3])));     
                for channels = 1:size(LFP_Data,3)
                    
                    if strcmp(outputFormat,'percentChange')
                    LFP_Spectrum(:,:,channels) = 100*(LFP_Data(:,:,channels) - frequencyMu(:,channels))./frequencyMu(:,channels);
                    end
                    if strcmp(outputFormat,'zScore')
                    LFP_Spectrum(:,:,channels) = (LFP_Data(:,:,channels) - frequencyMu(:,channels))./freqSig(:,channels);
                    end
                end
                
       %% Spectrum | STFT | Single Channel | Percent Change
            else
                if strcmp(outputFormat,'percentChange')
                frequencyMu = squeeze(mean(LFP_Data'));
                freqSig = squeeze(std(LFP_Data'));     
                  LFP_Spectrum = 100*(LFP_Data' - frequencyMu)./frequencyMu;
                  end
                if strcmp(outputFormat,'zScore')
                     LFP_Spectrum = (LFP_Data' - frequencyMu)./freqSig;
                end
                    
            end
            
            norm = LFP_Spectrum;

            
            
    case 'bandSpectrum'
        processableData = squeeze(LFP_Data);
        frequencyMu = squeeze(mean(processableData));
        freqSig = squeeze(std(processableData));
        
        [f,t,c] = size(LFP_Data);
         if strcmp(outputFormat,'percentChange')
                LFP_Spectrum = zeros(f,t,c);
                LFP_Spectrum(1:f,:,:) = 100*(processableData - frequencyMu)./frequencyMu;
         end
         if strcmp(outputFormat,'zScore')
                LFP_Spectrum = zeros(f,t,c);
                LFP_Spectrum(1:f,:,:) = 100*(processableData - frequencyMu)./freqSig;
                end
         
         
        norm = LFP_Spectrum;
end       
end
end

%% Band Spectrum
function [HHData] = bandSpectrum(HHData,SpectrumFrequencies,choice,averageOrNot)

% Initialize Variables
spectralParameters = bandParams(SpectrumFrequencies);
fullSpectrum = HHData.Data.LFP.Spectrum;

theta = spectralParameters.theta;
alpha = spectralParameters.alpha;
beta = spectralParameters.beta;
lowGamma = spectralParameters.lowGamma;
highGamma = spectralParameters.highGamma;

%% Spectral Band Derivation

switch choice
    case 'theta'
matchTheta(1) = find(SpectrumFrequencies  == theta(1));
matchTheta(2) = find(SpectrumFrequencies  == theta(2));
HHData.ML.thetaSpectrum = fullSpectrum(matchTheta(1):matchTheta(2),:,:,:);

if averageOrNot
    HHData.ML.thetaSpectrum = mean(HHData.ML.thetaSpectrum);
end

    case 'alpha'

matchAlpha(1) = find(SpectrumFrequencies  == alpha(1));
matchAlpha(2) = find(SpectrumFrequencies  == alpha(2));
HHData.ML.alphaSpectrum = fullSpectrum(matchAlpha(1):matchAlpha(2),:,:,:);

if averageOrNot
    HHData.ML.alphaSpectrum = mean(HHData.ML.alphaSpectrum);
end

    case 'beta'

matchBeta(1) = find(SpectrumFrequencies==beta(1));
matchBeta(2) = find(SpectrumFrequencies==beta(2));
HHData.ML.betaSpectrum = fullSpectrum(matchBeta(1):matchBeta(2),:,:,:);

if averageOrNot
    HHData.ML.betaSpectrum = mean(HHData.ML.betaSpectrum);
end

    case 'lowGamma'

matchGamma_L(1) = find(SpectrumFrequencies==lowGamma(1));
matchGamma_L(2) = find(SpectrumFrequencies==lowGamma(2));
HHData.ML.lowGammaSpectrum = fullSpectrum(matchGamma_L(1):matchGamma_L(2),:,:,:);

if averageOrNot
    HHData.ML.lowGammaSpectrum = mean(HHData.ML.lowGammaSpectrum);
end

    case 'highGamma'

matchGamma_H(1) = find(SpectrumFrequencies==highGamma(1));
matchGamma_H(2) = find(SpectrumFrequencies==highGamma(2));
HHData.ML.highGammaSpectrum = fullSpectrum(matchGamma_H(1):matchGamma_H(2),:,:,:);

if averageOrNot
    HHData.ML.highGammaSpectrum = mean(HHData.ML.highGammaSpectrum);
end

end
end

%% Band Signal
function [HHData] = bandSignal(HHData,SpectrumFrequencies,samplingFreq,choice)

% Initialize Variables
spectralParameters = bandParams(SpectrumFrequencies);
fullSignal = HHData.Data.LFP.LFP;

theta = spectralParameters.theta;
alpha = spectralParameters.alpha;
beta = spectralParameters.beta;
lowGamma = spectralParameters.lowGamma;
highGamma = spectralParameters.highGamma;

%% If Full Signal
if ndims(fullSignal) < 3
    switch choice
case 'theta'
HHData.ML.thetaSignal =  (bandpass(fullSignal',theta,samplingFreq))';
case 'alpha'
HHData.ML.alphaSignal = (bandpass(fullSignal',alpha,samplingFreq))';
case 'beta'
HHData.ML.betaSignal = (bandpass(fullSignal',beta,samplingFreq))';
case 'lowGamma'
HHData.ML.lowGammaSignal = (bandpass(fullSignal',lowGamma,samplingFreq))';
case 'highGamma'
HHData.ML.highGammaSignal = (bandpass(fullSignal',highGamma,samplingFreq))';
    end


%% 
else
fullSignal = squeeze(fullSignal);
for ii = 1:size(fullSignal,3)
    toBand = fullSignal(:,:,ii);
switch choice
    case 'theta'
HHData.ML.thetaSignal(:,:,ii) = (bandpass(toBand',theta,samplingFreq))';
case 'alpha'
HHData.ML.alphaSignal(:,:,ii) = (bandpass(toBand',alpha,samplingFreq))';
case 'beta'
HHData.ML.betaSignal(:,:,ii) = (bandpass(toBand',beta,samplingFreq))';
case 'lowGamma'
HHData.ML.lowGammaSignal(:,:,ii) = (bandpass(toBand',lowGamma,samplingFreq))';
case 'highGamma'
HHData.ML.highGammaSignal(:,:,ii) = (bandpass(toBand',highGamma,samplingFreq))';
end
end
end
end

%% Band Params
function [SpectralAnalysis] = bandParams(freqUsed)

%% Specify Band Bounds (in Hz) 
theta = [4 8];
alpha = [8 12];
beta = [16 24];
lowGamma = [25, 55];
highGamma = [65, 140];


%% Match Bounds to Actual Frequency Bins
for ii = 1:2
[minValue,closestIndex] = min(abs(freqUsed-theta(ii)'));
    SpectralAnalysis.theta(ii) = freqUsed(closestIndex);

[minValue,closestIndex] = min(abs(freqUsed-alpha(ii)'));
    SpectralAnalysis.alpha(ii) = freqUsed(closestIndex);

[minValue,closestIndex] = min(abs(freqUsed-beta(ii)'));
SpectralAnalysis.beta(ii) = freqUsed(closestIndex);


[minValue,closestIndex] = min(abs(freqUsed-lowGamma(ii)'));
   SpectralAnalysis.lowGamma(ii) = freqUsed(closestIndex);

[minValue,closestIndex] = min(abs(freqUsed-highGamma(ii)'));
   SpectralAnalysis.highGamma(ii) = freqUsed(closestIndex);
end
end

%% VISUALIZATION CODE
%% Multi-Panel DATA VISUALIZATION Function
        
function [] = Signal_Spectrum_Events_Polygons(data, allEvents,parameters, channelNumber,intervalTimes,colorUnit, limitTypes, saveDir,TrialOrEventCenter,windowing)%,timeBin,freqBin,band)
% Input 1: {Single Row/Channel of LFP Signal, Single Row/Channel of LFP Spectrum}
% Input 2: HHData.Events
% Input 3: parameters
% Input 4: Channel Number
% Input 5: Interval Times
% Input 6: Colorbar Axis Label ('e.g. Percent Change')
% Input 7: Limit Type (norm or raw)
% Input 8: Save Directory
% Input 9: Apply log to values (Set as 1 if not normalized) or not (as 0 if normalized) 
window = [-.5,.5];
if nargin < 9
    TrialOrEventCenter = 'Event';
    windowing = 'SAMPLE_RESPONSE';
end
if nargin < 10
    if (strcmp(TrialOrEventCenter,'Event'))
        windowing = 'SAMPLE_RESPONSE';
        intSelection = 51;
    else
        windowing = 10;
        intSelection = 5;
    end
end

if (strcmp(TrialOrEventCenter,'Event'))
        intSelection = 51;
else
        intSelection = 5;
end
    
fs = parameters.Derived.samplingFreq;
% Parameters to Load and/or Derive
    dataSignalRaw = data{1};
    dataSignalLFP = data{2};
    spectralData = data{3};
    freq = linspace(parameters.Choices.freqMin,parameters.Choices.freqMax,size(spectralData,1));

if ~exist(saveDir,'dir')
mkdir(saveDir);
end

    %% Initialize Figures
    % Bounds
    if strcmp(limitTypes,'norm')
         vBound = 5;
         clims = [-5,5];
    elseif strcmp(limitTypes,'raw')
        %vBound = max(abs([min(dataSignalLFP) max(dataSignalLFP)]));
         vBound = 1000 %vBound*1.2;
         clims = [-130,-50];
    end
    % Subplot Pattern
    numRows = 30;
    numCols = 8;
    templateSub = [2:numCols];
    numPlots = 3;
    
    firstThird = templateSub;
    height = floor(((numRows)/4))
    w = numCols - 1;
    remainder = numRows-(numPlots*height);
    for ii = 1:height
    firstThird = [firstThird, templateSub + ii*numCols];
    end
    
    secondThird = firstThird+((numCols)*floor((remainder/2)))+(height*numCols)
    thirdThird = secondThird+((numCols)*floor((remainder/2)))+(height*numCols)
    
    specThirds= zeros(2,length(secondThird))
    specThirds(1,:) = [secondThird];
    specThirds(2,:) = [thirdThird];
    
     figFull = figure('Position',[50 50 1700 800],'visible','off');
    h(2) = subplot(numRows,8,firstThird);
    if strcmp(limitTypes,'norm')
        %plot((dataSignalRaw(:,:)')),'c'); hold on;
        plot((dataSignalLFP(:,:)'),'k');
        ylabel('Z-Score'); ylim([-vBound vBound])
    elseif strcmp(limitTypes,'raw')
    plot((dataSignalRaw(:,:)')*(10^6),'c'); hold on;
    plot((dataSignalLFP(:,:)')*(10^6),'k');
            ylabel('uV'); ylim([-vBound vBound])
    end
            xticks([]);
            xlim([0 length(dataSignalLFP)]);
    for specPlot = 1:2        
    h(2+specPlot) = subplot(numRows,8,specThirds(specPlot,:));
    
            originalSize1 = get(gca, 'Position');
            
            % Plot the Image
           if specPlot == 1
            imagesc([0 length(dataSignalLFP)-1],freq,spectralData);
            set(gca,'ydir','normal');
            ytickskip = 20:40:length(freq);
            newTicks = (round(freq(ytickskip)));
            yticks(newTicks)
            yticklabels(cellstr(num2str(round((newTicks')))));
            xticks(fs*[0:0.1:parameters.Derived.durationSeconds]);
            xticklabels((xticks/fs))
            xlabel('Time (s)');
            hcb2=colorbar;
            colormap(jet);
            ylabel(hcb2,colorUnit);
            caxis(clims);
            ylabel('Frequency') ;
            set(gca, 'Position', originalSize1);
           elseif specPlot == 2
            time = linspace(0,parameters.Derived.durationSeconds,length(spectralData));% in ms
            pcolor(time,freq,spectralData);
            shading interp
            ytickskip = 20:40:length(freq);
            newTicks = (round(freq(ytickskip)));
            yticks(newTicks)
            yticklabels(cellstr(num2str(round((newTicks')))));
             xticks(fs*[0:0.1:parameters.Derived.durationSeconds]);
             xticklabels((xticks/fs))
            xlabel('Time (s)');
            hcb2=colorbar;
            colormap(jet);
            ylabel(hcb2,colorUnit);
            caxis(clims);
            ylabel('Frequency') ;
            set(gca, 'Position', originalSize1);
           end
    end      
    text( -.275,.75+1.5,['Channel ', num2str(channelNumber)],'Units','Normalized','FontSize',30,'FontWeight','bold');
 
            
%% Take Interval Snapshots
if (strcmp(TrialOrEventCenter,'Event'))
    intervalWindows = size(intervalTimes,2);
else
    intervalWindows = size(intervalTimes,2)/windowing;         
end

for iWin = intSelection % 1:intervalWindows
    if (strcmp(TrialOrEventCenter,'Event'))
        start =  allEvents.(windowing)(iWin)+window(1);
        stop = allEvents.(windowing)(iWin)+window(2);
    else
        start =  1+(windowing*(iWin-1));
        stop = (windowing*iWin);
    end
   
   [polyStructure] = polyEvents(allEvents,windowing,start,stop,vBound,fs,iWin);
   
% Shift Signal

   set(figFull,'CurrentAxes',h(2));
   if (strcmp(TrialOrEventCenter,'Event'))
       if start < 0
           start = 0;
       elseif stop > allEvents.MATCH_RESPONSE(end)
           stop = allEvents.MATCH_RESPONSE(end);
       end
       xlim([(start*fs), (stop*fs)]);
   else
   xlim([(allEvents.FOCUS_ON(start)-1)*fs, (allEvents.MATCH_RESPONSE(stop)+1)*fs]);
   end
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
   for specPlot = 1:2
   set(figFull,'CurrentAxes',h(2+specPlot))
   if (strcmp(TrialOrEventCenter,'Event'))
       if specPlot ==1
        xlim([start*fs, stop*fs]);
       else
          xlim([start, stop]); 
       end
   else
   xlim([(allEvents.FOCUS_ON(start)-1)*fs, (allEvents.MATCH_RESPONSE(stop)+1)*fs]);
   end
   end
   
   if (strcmp(TrialOrEventCenter,'Event'))
   sText = text( -.275,1.5+.5,['Trial ', num2str(iWin)],'Units','Normalized','FontSize',20);
   eText = text( -.275,1.5+.25,['Event: ',replace(windowing,'_',' ')],'Units','Normalized','FontSize',10);
   saveas(figFull,fullfile(saveDir,[limitTypes,'Trial_', num2str(iWin),'_Event_',windowing, '.png']));
   delete(sText);
   delete(eText);
   else
   sText = text( -.275,.75+1.5+ .5,['Trials ', num2str(start), ' - ',num2str(stop)],'Units','Normalized','FontSize',20);
   saveas(figFull,fullfile(saveDir,[limitTypes,'_Trials ', num2str(start), ' - ',num2str(stop), '.png']));
   delete(sText);
   end
   
end
close all;
end


function [rasterPolygons] = polyEvents(Events,windowing,start,stop,vBound,fs,trial)

if isempty(Events)
    % Rat Data Does Not Contain Events
else
    
    
 % Create Blocks
   if isnumeric(windowing)
       trialStarts = Events.FOCUS_ON(start:stop)*fs;
       trialStops = Events.MATCH_RESPONSE(start:stop)*fs;
   else
       trialStarts = start*fs;
       trialStops = stop*fs;
   end

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
   
   for ii = 1:windowing-1
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
    if isnumeric(windowing)
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
    else
        switch currentBehavior
            case 'FOCUS_ON'
                 rasterPolygons.Events.FO = Y(trial)*fs;
            case 'SAMPLE_ON'
                 rasterPolygons.Events.SO = Y(trial)*fs;
            case 'SAMPLE_RESPONSE'
                 rasterPolygons.Events.SR = Y(trial)*fs;
            case 'MATCH_ON'
                 rasterPolygons.Events.MO = Y(trial)*fs;
            case 'MATCH_RESPONSE'
                 rasterPolygons.Events.MR = Y(trial)*fs;
        end 
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


    