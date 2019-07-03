function [] = standardImage(data, allEvents,parameters, samplingFreq, dataName, channelNumber,intervalNumber,intervalTimes,colorUnit, lims, saveDir, whichtypes,logSignal,band)

if nargin < 14
    band = 'Signal';
end

%% This script is written for building visualizations of recorded Human Hippocampal neural signals.
% Parameters to Load and/or Derive
if strncmpi(whichtypes,'Signal',4)
    types = 1;
    vlims = lims;
    %dataSignalRaw = data{1};
    dataSignalLFP = data;
elseif strncmpi(whichtypes,'Spectrum',4)
    types = 2;
    clims = lims;
    spectralData = data;
    freq = linspace(parameters.Choices.freqMin,parameters.Choices.freqMax,size(spectralData,1));
end

if ~exist(saveDir,'dir')
mkdir(saveDir);
end

for type = types
    %% Initialize Figures
    figRaw = figure('Position',[50 50 1700 800],'visible','off');
    rastAx(1) = subplot(15,8,[98:104,106:112,114:120]);
    rasterEvents(allEvents);
    xlim(intervalTimes);
    
    dataAx = subplot(15,8,[2:8,10:16,18:24,26:32,34:40,42:48,50:56,58:64,66:72,74:80,82:88]);
    
    switch type
        case 1
            %h(1) = plot(dataSignalRaw(:,:),'k');hold on;
            h(2) = plot(dataSignalLFP(:,:),'k');
            ylabel('Voltage'); ylim(vlims)
            xticks([]);
            text( -.25,.5,['Channel ', num2str(channelNumber)],'Units','Normalized','FontSize',15);
            sText = text( -.25,.6,[band num2str(intervalNumber)],'Units','Normalized','FontSize',30,'FontWeight','bold');
        saveas(figRaw,fullfile(saveDir,[dataName, '.png']));
            
            %cols = cell2mat(get(h, 'color'));
            %[~, uidx] = unique(cols, 'rows', 'stable');
            %legend(h(uidx), {'Raw Signal' 'LFP Signal'});
        case 2
            originalSize1 = get(gca, 'Position');
            
            % Convert to Decibels If Not Already Done
            if ~logSignal
                imagesc([intervalTimes(1) intervalTimes(end)],freq,spectralData);
            else
                imagesc([intervalTimes(1) intervalTimes(end)],freq,(10*log10(spectralData)));
            end
            
            
%             if strncmpi(colorUnit,'dB',2)
%                 ytickskip = 2:4:size(spectralData,1);
%             else
%                 ytickskip = 20:20:size(spectralData,1);
%             end

            set(gca,'ydir','normal');
            ytickskip = 20:20:length(freq);
            newTicks = (round(freq(ytickskip)));
            yticks(newTicks)
            yticklabels(cellstr(num2str(round((newTicks')))));
            hcb2=colorbar;
            colormap jet;
            ylabel(hcb2,colorUnit);
            caxis(clims);
            ylabel('Frequency') ;xlabel('Time (seconds)');
            set(gca, 'Position', originalSize1);
            text( -.25,.5,['Channel ', num2str(channelNumber)],'Units','Normalized','FontSize',15);
            sText = text( -.25,.6,['Interval ' num2str(intervalNumber)],'Units','Normalized','FontSize',30,'FontWeight','bold');
        saveas(figRaw,fullfile(saveDir,[dataName, '.png']));
    end
    
close all;
end
end
