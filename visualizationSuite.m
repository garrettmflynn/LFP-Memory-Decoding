function [] = visualizationSuite(HHData,saveDir)

%% This script is written for building visualizations for recorded Human Hippocampal neural signals.
% Parameters to Change
channelsToVisualize = [38]; %HHData.Channels.CA1_Channels;
intervalsToVisualize = [26,32,40];
partitions =  1;
voltagelimRaw = [-15000 20000];
voltagelimIntervals = [-7500 7500];
thetaLim = [-3000 3000];
alphaLim = [-750 750];
betaLim = [-800 800];
lowGammaLim = [-600 600];
highGammaLim = [-100 100];

% Parameters to Load and/or Derive
parameters = HHData.Parameters;

neuronNames = fieldnames(HHData.Spikes);
for jj = 1:length(neuronNames)
    neuronChannels(jj) = str2double(neuronNames{jj,1}(:,9:10));
end

for  ii = 1:length(channelsToVisualize)
    indicesToVisualize(ii) = find(HHData.Channels.sChannels == channelsToVisualize(ii));
end

mkdir(fullfile(saveDir,'Intervals'));


if ~isfield(HHData.LFP,'Zscore')
    signalDataRaw = HHData.RawData;
    signalData =  HHData.LFP.LFPData;
    spectralData =  HHData.LFP.Spectrum;
    cLims = [-100 100];
    vLim = {thetaLim alphaLim betaLim lowGammaLim highGammaLim};
else
    signalDataRaw = HHData.LFP.LFPData; % Replace raw data with unnormalized LFP
    signalData =  HHData.LFP.Zscore.Signal;
    spectralData =  HHData.LFP.Zscore.Spectrum;
    cLims = [-100 100];
    vLim = {cLims cLims cLims cLims cLims};
    
end

if parameters.Choices.doBands
    Bands(1,:) = parameters.SpectralAnalysis.Theta;
    Bands(2,:) = parameters.SpectralAnalysis.Alpha;
    Bands(3,:) = parameters.SpectralAnalysis.Beta;
    Bands(4,:) = parameters.SpectralAnalysis.Gamma_L;
    Bands(5,:) = parameters.SpectralAnalysis.Gamma_H;
    nameBands = {'Theta' 'Alpha' 'Beta' 'Gamma_L' 'Gamma_H'};
else
    Bands = 1;
end

if isempty(intervalsToVisualize)
intervalsToVisualize = 1:length(HHData.Events.SAMPLE_RESPONSE);
end


if isempty(channelsToVisualize)
channelsToVisualize = 1:length(HHData.Channels.sChannels);
end

for interval = intervalsToVisualize
    for choice = 1:length(channelsToVisualize)
        
        channelNeurons = neuronNames(find(neuronChannels == channelsToVisualize(choice)));
        for ii = 1:length(channelNeurons)
            spikesForChannel{ii} = HHData.Spikes.(channelNeurons{ii});
        end
        
        for type = (parameters.Choices.doTypes(parameters.Choices.doTypes~=0))
            for partition = 1:partitions
                
                lenEvent = length(HHData.Events.FOCUS_ON);
                intervalPartitioned = ((partition-1)*lenEvent/partitions(end))+1:((partition*lenEvent/partitions(end)));
                if partition == 1
                    secondsInterval = [(HHData.Events.FOCUS_ON(intervalPartitioned(1))) HHData.Events.MATCH_RESPONSE(intervalPartitioned(end))];
                else
                    secondsInterval = [(HHData.Events.FOCUS_ON(intervalPartitioned(1)-1)) HHData.Events.MATCH_RESPONSE(intervalPartitioned(end))];
                end
                pointsInterval = ([secondsInterval(1) secondsInterval(end)]*parameters.Derived.samplingFreq)+1;
                
                
                
                %% Full Figures Only | Signal and Spectrograms
                
                
                figRaw = figure('Position',[50 50 1700 800],'visible','on'); 
                rastAx(1) = subplot(15,8,[2:8,10:16,18:24]);
                rasterEvents(HHData.Events);
                xlim(secondsInterval);
                
                dataAx = subplot(15,8,[26:32,34:40,42:48,50:56,58:64,66:72,74:80,82:88,90:96,98:104,106:112,114:120]);
                
                switch type
                    case 1
                        h(1) = plot(signalDataRaw(indicesToVisualize(choice),:),'k');hold on;
                        h(2) = plot(signalData(indicesToVisualize(choice),:),'c');
                        xlim( secondsInterval*parameters.Derived.samplingFreq );ylabel('Voltage'); ylim(voltagelimRaw);
                        xT = xticks;
                        xticklabels(cellstr(num2str((xT/parameters.Derived.samplingFreq)')));
                        xlabel('Time (seconds)');
                        sText = text( -.25,.6,'Session Raw','Units','Normalized','FontSize',30,'FontWeight','bold');
                        text( -.25,.7,[num2str(partition),'/',num2str(partitions(end))],'Units','Normalized','FontSize',20,'FontWeight','bold');
                        text( -.25,.5,['Channel ', num2str(channelsToVisualize(choice)), ' Signal'],'Units','Normalized','FontSize',15);
                        
                        cols = cell2mat(get(h, 'color'));
                        [~, uidx] = unique(cols, 'rows', 'stable');
                        legend(h(uidx), {'Raw Signal' 'LFP Signal'});
                        
                        saveName = ['SignalRaw',num2str(channelsToVisualize(choice)),'Partition',num2str(partition),'.png'];
                    case 2
                        originalSize1 = get(gca, 'Position');
                        
                        % Convert to Decibels If Not Already Done
                        if isfield(HHData.LFP,'Zscore')
                        imagesc([HHData.LFP.TimeforSpectra(indicesToVisualize(choice),1) HHData.LFP.TimeforSpectra(indicesToVisualize(choice),end)],[],spectralData(:,:,indicesToVisualize(choice)));
                        else
                        imagesc([HHData.LFP.TimeforSpectra(indicesToVisualize(choice),1) HHData.LFP.TimeforSpectra(indicesToVisualize(choice),end)],[],(10*log10(spectralData(:,:,indicesToVisualize(choice)))));
                        end
                        
                        
                        if  size(spectralData,2) ==  size(signalDataRaw,2)
                        ytickskip = 2:4:size(spectralData,1); 
                        else
                        ytickskip = 20:20:size(spectralData,1); 
                        end
                        set(gca,'ytick',ytickskip,'yticklabel',round(parameters.Derived.freq(ytickskip)),'ydir','normal','clim',[-100 100]);
                        hcb2=colorbar;
                        colormap jet;
                        ylabel(hcb2, 'Power (dB/Hz)');
                        caxis(cLims);
                        xlim(secondsInterval ); ylabel('Frequency') ;xlabel('Time (seconds)');
                        set(gca, 'Position', originalSize1);
                        sText = text( -.25,.6,'Session LFP','Units','Normalized','FontSize',30,'FontWeight','bold');
                        text( -.25,.7,[num2str(partition),'/',num2str(partitions(end))],'Units','Normalized','FontSize',20,'FontWeight','bold');
                        text( -.25,.5,['Channel ', num2str(channelsToVisualize(choice)),' Spectrum'],'Units','Normalized','FontSize',15);
                        saveName = ['SpectrumRaw',num2str(channelsToVisualize(choice)),'Partition',num2str(partition),'.png'];
                end
                
                
                saveas(figRaw,fullfile(saveDir,saveName));
                
                
                %% Visualization - trial segments without bands
                if partition == 1
                        if type == 2
                            int = [HHData.IntervalInformation.Times(1,interval) HHData.IntervalInformation.Times(2,interval)];
                            
                            set(0, 'currentfigure', figRaw); hold on;
                            xlim(rastAx,int);
                            xlim(dataAx,int);
                            delete(sText);
                            sText = text( -.25,.6,['Interval ' num2str(interval)],'Units','Normalized','FontSize',30,'FontWeight','bold');
                            saveas(figRaw,fullfile(saveDir,'Intervals',['Spectrum',num2str(interval),'FullRange.png']));
                        end
                        
                        if type == 1
                            legendLabels = [];
                            set(0, 'currentfigure', figRaw); hold on;
                            % Spike Visualization
                            colorstring = parula(length(spikesForChannel));
                            for kk = 1:length(spikesForChannel)
                                legendLabels = [legendLabels {['Neuron ' num2str(kk)]}];
                                for zz = 1:length(spikesForChannel{kk}*parameters.Derived.samplingFreq)
                                    h2(kk) = plot(spikesForChannel{kk}(zz)*parameters.Derived.samplingFreq,signalData(indicesToVisualize(choice),round(spikesForChannel{kk}(zz)*parameters.Derived.samplingFreq)),'o','Color', colorstring(kk,:),'LineWidth',.25,'MarkerFaceColor',colorstring(kk,:));
                                end
                            end
                            
                            cols = cell2mat(get(h2, 'color'));
                            [~, uidx] = unique(cols, 'rows', 'stable');
                            legend(h2(uidx), legendLabels)
                            
                            
                            
                            int = [HHData.IntervalInformation.Times(1,intervalCount) HHData.IntervalInformation.Times(2,intervalCount)];
                            set(0, 'currentfigure', figRaw); hold on;
                            ylim(dataAx,voltagelimIntervals);
                            xlim(rastAx,int);
                            xlim(dataAx,int*parameters.Derived.samplingFreq);
                            newTicks = (floor(int(1)/10)*10*parameters.Derived.samplingFreq):parameters.Derived.samplingFreq/5:(ceil(int(2)/10)*10*parameters.Derived.samplingFreq);
                            xticks(newTicks);
                            xticklabels(cellstr(num2str((newTicks/parameters.Derived.samplingFreq)')));
                            delete(sText);
                            sText = text( -.25,.6,['Interval ' num2str(interval)],'Units','Normalized','FontSize',30,'FontWeight','bold');
                            saveas(figRaw,fullfile(saveDir,'Intervals',['Signal',num2str(interval),'FullRange.png']));
                            
                        end
                    end
                end
                
%% All Bands Visualization Occurs Below Here
                
if parameters.Choices.doBands
                 for band = 1:size(Bands,1)   
                    
                    
                    if ~isfield(HHData.LFP,'Zscore')
                        bandSig = HHData.LFP.(nameBands{band}).Signal;
                    else
                        bandSig = HHData.LFP.Zscore.(nameBands{band}).Signal;
                    end
                    
                    switch type
                        case 1
                            % Needs Work
                            hB = plot(bandSig(indicesToVisualize(choice),:),'k');hold on;
                            xlim( secondsInterval*parameters.Derived.samplingFreq );ylabel('Voltage');
                            xT = xticks;
                            xticklabels(cellstr(num2str((xT/parameters.Derived.samplingFreq)')));
                            xlabel('Time (seconds)');
                            delete(sText)
                            sText = text( -.25,.6,nameBands{band},'Units','Normalized','FontSize',30,'FontWeight','bold');
                            text( -.25,.7,[num2str(partition),'/',num2str(partitions(end))],'Units','Normalized','FontSize',20,'FontWeight','bold');
                            text( -.25,.5,['Channel ', num2str(channelsToVisualize(choice)),' Signal'],'Units','Normalized','FontSize',15);
                            if exist('rangeText','var')
                                erase(rangeText);
                            end
                            rangeText = text( -.25,.45,[num2str(round(Bands(band,1))) ,' Hz to ' ,num2str(round(Bands(band,2))), ' Hz'],'Units','Normalized','FontSize',10);
                            ylim(vLim{band});
                            legend(hB, {'Raw Signal'});
                            saveName = ['Signal',nameBands{band},num2str(channelsToVisualize(choice)),'Partition',num2str(partition),'.png'];
                        case 2
                        if  size(spectralData,2) ==  size(signalDataRaw,2)
                        ylim(Bands(band,:)/2);
                        ytickskip = 2:2:size(spectralData,1); 
                        else
                        ylim(2*Bands(band,:));
                        ytickskip = 2:4:size(spectralData,1); 
                        end
                        set(gca,'ytick',ytickskip,'yticklabel',round(parameters.Derived.freq(ytickskip)),'ydir','normal','clim',[-100 100]);
                        
                        
                        
                            xlim(secondsInterval ); ylabel('Frequency') ;xlabel('Time (seconds)');
                            set(gca, 'Position', originalSize1);
                            delete(sText)
                            sText = text( -.25,.6,nameBands{band},'Units','Normalized','FontSize',30,'FontWeight','bold');
                            if exist('rangeText','var')
                                delete(rangeText);
                            end
                            rangeText = text( -.25,.45,[num2str(Bands(band,1)) ,' Hz to ' ,num2str(Bands(band,2)), ' Hz'],'Units','Normalized','FontSize',10);
                            saveName = ['Spectrum',nameBands{band},num2str(channelsToVisualize(choice)),'Partition',num2str(partition),'.png'];
                    end
                    
                    saveas(figRaw,fullfile(saveDir,saveName));
                    
                    
                    
                    %% Visualization - trial segments (for Bands Only)
                    if partition == 1
                            if type == 2
                                int = [HHData.IntervalInformation.Times(1,interval) HHData.IntervalInformation.Times(2,interval)];
                                set(0, 'currentfigure', figRaw);
                                xlim(rastAx,int);
                                xlim(dataAx,int);
                                delete(sText)
                                sText = text( -.25,.6,[nameBands{band},' ',num2str(interval)],'Units','Normalized','FontSize',30,'FontWeight','bold');
                                saveas(figRaw,[saveDir,'/Intervals/Spectrum',num2str(interval),saveName]);
                            end
                            
                            if type == 1
                                legendLabelsB = [];
                                set(0, 'currentfigure', figRaw); hold on;
                                % Spike Visualization
                                colorstring = parula(length(spikesForChannel));
                                for kk = 1:length(spikesForChannel)
                                    legendLabelsB = [legendLabelsB {['Neuron ' num2str(kk)]}];
                                    for zz = 1:length(spikesForChannel{kk}*parameters.Derived.samplingFreq)
                                        hB2(kk) = plot(spikesForChannel{kk}(zz)*parameters.Derived.samplingFreq,bandSig(indicesToVisualize(choice),round(spikesForChannel{kk}(zz)*parameters.Derived.samplingFreq)),'o','Color', colorstring(kk,:),'LineWidth',.25,'MarkerFaceColor',colorstring(kk,:));
                                    end
                                end
                                cols = cell2mat(get(hB2, 'color'));
                                [~, uidx] = unique(cols, 'rows', 'stable');
                                legend(hB2(uidx), legendLabelsB)
                                
                                set(0, 'currentfigure', figRaw); hold on;
                                xlim(rastAx,int);
                                xlim(dataAx,int*parameters.Derived.samplingFreq);
                                newTicks = (floor(int(1)/10)*10*parameters.Derived.samplingFreq):parameters.Derived.samplingFreq/5:(ceil(int(2)/10)*10*parameters.Derived.samplingFreq);
                                xticks(newTicks);
                                xticklabels(cellstr(num2str((newTicks/parameters.Derived.samplingFreq)')));
                                delete(sText)
                                sText = text( -.25,.6,[nameBands{band},' ',num2str(interval)],'Units','Normalized','FontSize',30,'FontWeight','bold');
                                saveas(figRaw,fullfile(saveDir,'Intervals',['Signal',num2str(interval),erase(saveName,'Partition1')]));
                            end
                    end
                 end
                end
                                    close all;
        end
    end
    end
end



