function [] = Signal_Spectrum_Events(data, allEvents,parameters, channelNumber,intervalTimes,colorUnit, clims, saveDir,logSignal,timeBin,freqBin,band)

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
    
    firstThird = templateSub;
    for ii = 1:((numRows/3) - 1)
    firstThird = [firstThird, templateSub + numCols*(ii)];
    end
    
    secondThird = firstThird + numCols*(numRows/3);
    secondThird = secondThird((1*length(templateSub)+1):end);
    
    lastThirdOG = secondThird + numCols*(numRows/3);
    lastThird = lastThirdOG((1*length(templateSub)+1):end);
    
        
    clear lastThirdOG
    
     figFull = figure('Position',[50 50 1700 800],'visible','off');
      h(1) = subplot(numRows,8,lastThird);
     rasterEvents(allEvents);
     xlim(fullRange);
    
    h(2) = subplot(numRows,8,firstThird);
    plot(dataSignalLFP(:,:)','k');
            ylabel('Voltage'); ylim([-vBound vBound])
            xticks([]);
            xlim([0 length(dataSignalLFP)]);
            
    h(3) = subplot(numRows,8,secondThird);
    
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
            xticks([]);
            hcb2=colorbar;
            colormap jet;
            ylabel(hcb2,colorUnit);
            caxis(clims);
            ylabel('Frequency') ;
            set(gca, 'Position', originalSize1);
            text( -.275,.75,['Channel ', num2str(channelNumber)],'Units','Normalized','FontSize',30,'FontWeight','bold');
            
 
            
%% Take Interval Snapshots
intervalWindows = size(intervalTimes,2)/10; % Ten Trials per Window            
            
for iWin = 1:intervalWindows
   start =  1+(10*(iWin-1));
   stop = (10*iWin);
   
   [polyStructure] = polyEvents(allEvents,start,stop,vBound,fs);
   
    % Shift Events
    set(figFull,'CurrentAxes',h(1))
    xlim([allEvents.FOCUS_ON(start)-1, allEvents.MATCH_RESPONSE(stop)+1]);
   
   
% Shift Signal

   set(figFull,'CurrentAxes',h(2));
   xlim([(allEvents.FOCUS_ON(start)-1)*fs, (allEvents.MATCH_RESPONSE(stop)+1)*fs]);
   
   % Shift Spectrum
   set(figFull,'CurrentAxes',h(3))
   xlim([(allEvents.FOCUS_ON(start)-1)*fs, (allEvents.MATCH_RESPONSE(stop)+1)*fs]);
   sText = text( -.275,.55,['Trials ', num2str(start), ' - ',num2str(stop)],'Units','Normalized','FontSize',20);
saveas(figFull,fullfile(saveDir,['Trials ', num2str(start), ' - ',num2str(stop), '.png']));
 delete(sText);
end
close all;
end
