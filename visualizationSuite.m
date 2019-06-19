function [] = visualizationSuite(HHData,saveDir)
%% This script is written for building visualizations for recorded Human Hippocampal neural signals.
% Parameters to Change
channelsToVisualize = [1]; %HHData.Channels.CA1_Channels;
intervalsToVisualize = [14];
partitions =  1;
voltagelimRaw = [-7500 9000];
voltagelimIntervals = [-500 500];
thetaLim = [-3000 2000];
alphaLim = [-1000 1000];
betaLim = [-500 500];
gammaLim = [-500 500];

% Parameters to Load and/or Derive
parameters = HHData.Parameters;

neuronNames = fieldnames(HHData.Spikes);
for jj = 1:length(neuronNames)
    neuronChannels(jj) = str2double(neuronNames{jj,1}(:,9:10));
end

for  ii = 1:length(channelsToVisualize)
    indicesToVisualize(ii) = find(HHData.Channels.sChannels == channelsToVisualize(ii));
end

mkdir([saveDir,'/Intervals']);


if ~isfield(HHData.LFP,'Zscore')
    signalDataRaw = HHData.RawData;
    signalData =  HHData.LFP.LFPData;
    spectralData =  HHData.LFP.Spectrum;
    cLims = [0 2000];
    vLim = {thetaLim alphaLim betaLim gammaLim};
else
    signalDataRaw = HHData.LFP.LFPData; % Replace raw data with unnormalized LFP
    signalData =  HHData.LFP.Zscore.Signal;
    spectralData =  HHData.LFP.Zscore.Spectrum;
    cLims = [-5 5];
    vLim = {cLims cLims cLims cLims cLims};

end

%% Visualization Strategy: Separate Figures for Channels,Signals, Spectra, Bands, Etc
Bands(1,:) = parameters.SpectralAnalysis.Theta;
Bands(2,:) = parameters.SpectralAnalysis.Alpha;
Bands(3,:) = parameters.SpectralAnalysis.Beta;
Bands(4,:) = parameters.SpectralAnalysis.Gamma;

nameBands = {'Theta' 'Alpha' 'Beta' 'Gamma'};
for band = 1:size(Bands,1)
    
    
    for choice = 1:length(channelsToVisualize)
        if ~isfield(HHData.LFP,'Zscore')
        bandSig = HHData.LFP.(nameBands{band}).Signal; 
        bandSpec = HHData.LFP.(nameBands{band}).Spectrum;
        else
            bandSig = HHData.LFP.Zscore.(nameBands{band}).Signal;
             bandSpec = HHData.LFP.Zscore.(nameBands{band}).Spectrum;
        end
        
        channelNeurons = neuronNames(find(neuronChannels == channelsToVisualize(choice)));
        for ii = 1:length(channelNeurons)
            spikesForChannel{ii} = HHData.Spikes.(channelNeurons{ii});
        end
        for type = 1:2
            for partition = 1:partitions
                lenEvent = length(HHData.Events.FOCUS_ON);
                interval = ((partition-1)*lenEvent/partitions(end))+1:((partition*lenEvent/partitions(end)));
                if partition == 1
                    secondsInterval = [(HHData.Events.FOCUS_ON(interval(1))) HHData.Events.MATCH_RESPONSE(interval(end))];
                else
                    secondsInterval = [(HHData.Events.FOCUS_ON(interval(1)-1)) HHData.Events.MATCH_RESPONSE(interval(end))];
                end
                pointsInterval = ([secondsInterval(1) secondsInterval(end)]*parameters.Derived.samplingFreq)+1;
                
                
                figRaw = figure('Position',[50 50 1700 800],'visible','off');
                rastAx(1) = subplot(6,8,[2:8]);
                rasterEvents(HHData.Events.FOCUS_ON);
                xlim( secondsInterval );ylabel('FO');
                rastAx(2) = subplot(6,8,[10:16]);
                rasterEvents(HHData.Events.SAMPLE_ON);
                xlim( secondsInterval );ylabel('SO');
                rastAx(3) = subplot(6,8,[18:24]);
                rasterEvents(HHData.Events.SAMPLE_RESPONSE);
                xlim( secondsInterval );ylabel('SR');
                rastAx(4) = subplot(6,8,[26:32]);
                rasterEvents(HHData.Events.MATCH_ON);
                xlim( secondsInterval );ylabel('MO');
                rastAx(5) = subplot(6,8,[34:40]);
                rasterEvents(HHData.Events.MATCH_RESPONSE);
                xlim( secondsInterval );ylabel('MR');
                
                dataAx = subplot(6,8,[42:48]);
                switch type
                    case 1
                        plot(signalDataRaw(indicesToVisualize(choice),:),'k');hold on;
                        plot(signalData(indicesToVisualize(choice),:),'c');
                        xlim( secondsInterval*parameters.Derived.samplingFreq );ylabel('Voltage'); ylim(voltagelimRaw);
                        xT = xticks;
                        xticklabels(cellstr(num2str((xT/parameters.Derived.samplingFreq)')));
                        xlabel('Time (seconds)');
                        title('Signal');
                        sText = text( -.25,4,'Session Raw','Units','Normalized','FontSize',30,'FontWeight','bold');
                        text( -.25,4.5,[num2str(partition),'/',num2str(partitions(end))],'Units','Normalized','FontSize',20,'FontWeight','bold');
                        text( -.25,3.5,[' Channel ', num2str(channelsToVisualize(choice)), ' Signal'],'Units','Normalized','FontSize',15);
                        saveName = ['SignalRaw',num2str(channelsToVisualize(choice)),'Partition',num2str(partition),'.png'];
                    case 2
                        originalSize1 = get(gca, 'Position');
                        surf(linspace(0,HHData.Events.MATCH_RESPONSE(end),size(spectralData(:,:,indicesToVisualize(choice)),2)),parameters.Derived.freq,spectralData(:,:,indicesToVisualize(choice)),'EdgeColor','none');axis xy; axis tight; colormap(jet); view(0,90);
                        hcb2=colorbar;
                        caxis(cLims);
                        xlim( secondsInterval ); ylabel('Frequency') ;xlabel('Time (seconds)');
                        set(gca, 'Position', originalSize1);
                        sText = text( -.25,4,'Session LFP','Units','Normalized','FontSize',30,'FontWeight','bold');
                        text( -.25,4.5,[num2str(partition),'/',num2str(partitions(end))],'Units','Normalized','FontSize',20,'FontWeight','bold');
                        text( -.25,3.5,[' Channel ', num2str(channelsToVisualize(choice)),' Spectrum'],'Units','Normalized','FontSize',15);
                        saveName = ['SpectrumRaw',num2str(channelsToVisualize(choice)),'Partition',num2str(partition),'.png'];
                end
                
                saveas(figRaw,[saveDir,'/',saveName]);
                
                
                %% Band and Events Plot
                figBands = figure('Position',[50 50 1700 800],'visible','off');
                rastAxBands(1) = subplot(6,8,[2:8]);
                rasterEvents(HHData.Events.FOCUS_ON(interval));
                xlim( secondsInterval );ylabel('FO');
                rastAxBands(2) = subplot(6,8,[10:16]);
                rasterEvents(HHData.Events.SAMPLE_ON(interval));
                xlim( secondsInterval );ylabel('SO');
                rastAxBands(3) = subplot(6,8,[18:24]);
                rasterEvents(HHData.Events.SAMPLE_RESPONSE(interval));
                xlim( secondsInterval );ylabel('SR');
                rastAxBands(4) = subplot(6,8,[26:32]);
                rasterEvents(HHData.Events.MATCH_ON(interval));
                xlim( secondsInterval );ylabel('MO');
                rastAxBands(5) = subplot(6,8,[34:40]);
                rasterEvents(HHData.Events.MATCH_RESPONSE(interval));
                xlim( secondsInterval );ylabel('MR');
                
                dataAxBands = subplot(6,8,[42:48]);
                switch type
                    case 1
                        plot(bandSig(indicesToVisualize(choice),:),'k');hold on;
                        xlim( secondsInterval*parameters.Derived.samplingFreq );ylabel('Voltage');
                        xT = xticks;
                        xticklabels(cellstr(num2str((xT/parameters.Derived.samplingFreq)')));
                        xlabel('Time (seconds)');                        
                        title(['Signal']);
                        btext = text( -.25,4,(nameBands{band}),'Units','Normalized','FontSize',30,'FontWeight','bold');
                        text( -.25,4.5,[num2str(partition),'/',num2str(partitions(end))],'Units','Normalized','FontSize',20,'FontWeight','bold');
                        text( -.25,3.5,[' Channel ', num2str(channelsToVisualize(choice)),' Signal'],'Units','Normalized','FontSize',15);
                        text( -.25,3,[num2str(Bands(band,1)) ,' Hz to ' ,num2str(Bands(band,2)), ' Hz'],'Units','Normalized','FontSize',10);
                        ylim(vLim{band});
                        saveName = ['Signal',nameBands{band},num2str(channelsToVisualize(choice)),'Partition',num2str(partition),'.png'];
                    case 2
                        originalSize1 = get(gca, 'Position');
                        surf(linspace(0,HHData.Events.MATCH_RESPONSE(end),size(bandSpec(:,:,indicesToVisualize(choice)),2)),parameters.Derived.freq(find(parameters.Derived.freq == Bands(band,1)):find(parameters.Derived.freq == Bands(band,2))),bandSpec(:,:,indicesToVisualize(choice)),'EdgeColor','none');axis xy; axis tight; colormap(jet); view(0,90);
                        hcb2=colorbar;
                        hcb2=colorbar;
                        caxis(cLims);
                        xlim( secondsInterval ); ylabel('Frequency') ;xlabel('Time (seconds)');
                        set(gca, 'Position', originalSize1);
                        btext = text( -.25,4,(nameBands{band}),'Units','Normalized','FontSize',30,'FontWeight','bold');
                        text( -.25,4.5,[num2str(partition),'/',num2str(partitions(end))],'Units','Normalized','FontSize',20,'FontWeight','bold');
                        text( -.25,3.5,[' Channel ', num2str(channelsToVisualize(choice)),' Spectrum'],'Units','Normalized','FontSize',15);
                        text( -.25,3,[num2str(Bands(band,1)) ,' Hz to ' ,num2str(Bands(band,2)), ' Hz'],'Units','Normalized','FontSize',10);
                        saveName = ['Spectrum',nameBands{band},num2str(channelsToVisualize(choice)),'Partition',num2str(partition),'.png'];
                end
                saveas(figBands,[saveDir,'/',saveName]);
                
                %% Visualization - trial segments
           if partition == 1
                for interval = intervalsToVisualize
                    
                    set(0, 'currentfigure', figRaw); hold on;
                    % Spike Visualization
                    colorstring = 'rgbym';
                    for kk = 1:length(spikesForChannel)
                        for zz = 1:length(spikesForChannel{kk}*parameters.Derived.samplingFreq)
                            plot(spikesForChannel{kk}(zz)*parameters.Derived.samplingFreq,signalData(indicesToVisualize(choice),round(spikesForChannel{kk}(zz)*parameters.Derived.samplingFreq)),['o' colorstring(kk)],'LineWidth',.25,'MarkerFaceColor',colorstring(kk));
                        end
                    end
                    set(0, 'currentfigure', figBands); hold on;
                    % Spike Visualization
                    colorstring = 'rgbym';
                    for kk = 1:length(spikesForChannel)
                        for zz = 1:length(spikesForChannel{kk}*parameters.Derived.samplingFreq)
                            plot(spikesForChannel{kk}(zz)*parameters.Derived.samplingFreq,bandSig(indicesToVisualize(choice),round(spikesForChannel{kk}(zz)*parameters.Derived.samplingFreq)),['o' colorstring(kk)],'LineWidth',.25,'MarkerFaceColor',colorstring(kk));
                        end
                    end
                    
                    
                    if type == 2
                        int = [HHData.IntervalInformation.Times(1,interval) HHData.IntervalInformation.Times(2,interval)];
                        
                        set(0, 'currentfigure', figRaw); hold on;
                        xlim(rastAx,int);
                        xlim(dataAx,int);
                        delete(sText);
                        sText = text( -.25,4,['Interval ' num2str(interval)],'Units','Normalized','FontSize',30,'FontWeight','bold');
                        saveas(figRaw,[saveDir,'/Intervals/Spectrum',num2str(interval),'FullRange.png']);
                        set(0, 'currentfigure', figBands);
                        xlim(rastAxBands,int);
                        xlim(dataAxBands,int);
                        delete(btext);
                        btext = text( -.25,4,[nameBands{band},' ',num2str(interval)],'Units','Normalized','FontSize',30,'FontWeight','bold');
                        saveas(figBands,[saveDir,'/Intervals/Spectrum',num2str(interval),saveName]);
                    end
                    
                    if type == 1
                        int = [HHData.IntervalInformation.Times(1,interval) HHData.IntervalInformation.Times(2,interval)];
                        set(0, 'currentfigure', figRaw); hold on;
                        ylim(dataAx,voltagelimIntervals);
                        xlim(rastAx,int);
                        xlim(dataAx,int*parameters.Derived.samplingFreq);
                        newTicks = (floor(int(1)/10)*10*parameters.Derived.samplingFreq):parameters.Derived.samplingFreq/5:(ceil(int(2)/10)*10*parameters.Derived.samplingFreq);
                        xticks(newTicks);
                        xticklabels(cellstr(num2str((newTicks/parameters.Derived.samplingFreq)')));
                        delete(sText);
                        sText = text( -.25,4,['Interval ' num2str(interval)],'Units','Normalized','FontSize',30,'FontWeight','bold');
                        saveas(figRaw,[saveDir,'/Intervals/Signal',num2str(interval),'FullRange.png']);
                        
                        
                        set(0, 'currentfigure', figBands); hold on;
                        xlim(rastAxBands,int);
                        xlim(dataAxBands,int*parameters.Derived.samplingFreq);
                        newTicks = (floor(int(1)/10)*10*parameters.Derived.samplingFreq):parameters.Derived.samplingFreq/5:(ceil(int(2)/10)*10*parameters.Derived.samplingFreq);
                        xticks(newTicks);
                        xticklabels(cellstr(num2str((newTicks/parameters.Derived.samplingFreq)')));
                        delete(btext);
                        btext = text( -.25,4,[nameBands{band},' ',num2str(interval)],'Units','Normalized','FontSize',30,'FontWeight','bold');
                        saveas(figBands,[saveDir,'/Intervals/Signal',num2str(interval),erase(saveName,'Partition1')]);
                    end
                    close all;
                end
           end
            end
        end
    end
end
end


