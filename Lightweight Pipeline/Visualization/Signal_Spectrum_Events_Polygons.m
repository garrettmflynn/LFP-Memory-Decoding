function [] = Signal_Spectrum_Events_Polygons(data, allEvents,parameters, channelNumber,intervalTimes,colorUnit, clims, saveDir,logSignal,timeBin,freqBin,band)

if nargin < 14
    band = 'Signal';
end


fs = parameters.Derived.samplingFreq;
%% This script is written for building visualizations of recorded Human Hippocampal neural signals.
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
            
            % Convert to Decibels If Not Already Done
            if ~logSignal
                 imagesc([0 length(dataSignalLFP)],freq,spectralData);
            else
               imagesc([0 length(dataSignalLFP)],freq,(10*log10(spectralData)));
            end
            set(gca,'ydir','normal');
            ytickskip = 20:40:length(freq);
            newTicks = (round(freq(ytickskip)));
            yticks(newTicks)
            yticklabels(cellstr(num2str(round((newTicks')))));
            hcb2=colorbar;
            colormap jet;
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
   colors = parula(numF);

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
