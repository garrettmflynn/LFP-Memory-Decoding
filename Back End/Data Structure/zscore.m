function [Zstruct] = zscore(LFP_Cell,parameters)   


if ~strncmp(tf_method,'Morlet',4)
fprintf('Now Creating ZScore Data\n');

LFP_Data = LFP_Cell{1};
LFP_Spectrum = LFP_Cell{2};
    
% ITI Spectral Sampling for Baseline Measurements
LFP_ITI = sampleData(LFP_Data,parameters.Intervals.ITIOneSecond,parameters);

for ITIi = 1:size(LFP_ITI,3)
[ITI_Power(:,:,:,ITIi), timeZ] = makeSpectrum(LFP_ITI(:,:,ITIi),parameters);
% [Trial_Power(:,:,:,ITIi), timeT] = makeSpectrum(LFP_Trials(:,:,ITIi),parameters);
% makeImage(timeZ,parameters.Derived.freq,ITI_Power(:,:,:,ITIi),['D:\ClipArt_2\ITI Images\Image', num2str(ITIi),'.png'])
% makeImage(timeT,parameters.Derived.freq,Trial_Power(:,:,:,ITIi),['D:\ClipArt_2\Trial Images\Image', num2str(ITIi),'.png'])
end



ITI_PowerTAveraged = squeeze(mean(permute(ITI_Power,[4,2,1,3])));
ITI_LFPTAveraged = squeeze(mean(permute(LFP_ITI,[3,2,1])));

if ndims(squeeze(LFP_ITI)) == 3
    
% ITI Averaged Mean and STD
frequencyMu = mean(ITI_LFPTAveraged);
frequencySigma = std(ITI_LFPTAveraged);
LFP_Signal_ZScore = ((LFP_Data'-frequencyMu)./frequencySigma)';


frequencyMu = squeeze(mean(ITI_PowerTAveraged));

frequencySigma = squeeze(std(ITI_PowerTAveraged));

LFP_Spectrum_ZScore = permute(((permute(LFP_Spectrum,[1,3,2])-frequencyMu)./frequencySigma),[1,3,2]);

% If you only have one channel to keep track of
else
frequencyMu = mean(ITI_LFPTAveraged');
frequencySigma = std(ITI_LFPTAveraged');
LFP_Signal_ZScore = ((LFP_Data'-frequencyMu)./frequencySigma)';


frequencyMu = squeeze(mean(ITI_PowerTAveraged));
frequencySigma = squeeze(std(ITI_PowerTAveraged));

LFP_Spectrum_ZScore = ((LFP_Spectrum'-frequencyMu)./frequencySigma)';



% Make Zscore Images
% Trial_Power = squeeze(Trial_Power);
% 
% for ITIi = 1:size(Trial_Power,3)
% ZTrials(:,:,ITIi) = ((Trial_Power(:,:,ITIi)'-frequencyMu)./frequencySigma)';
% makeImage(timeT,parameters.Derived.freq,ZTrials(:,:,ITIi),['D:\ClipArt_2\Trial Z\Image', num2str(ITIi),'.png']);
% end
% 
 end

LFP_Bands_ZScore = bandLFP(LFP_Spectrum_ZScore,parameters,LFP_Signal_ZScore);


Zstruct = LFP_Bands_ZScore;
Zstruct.Signal = LFP_Signal_ZScore;
Zstruct.Spectrum = LFP_Spectrum_ZScore;
Zstruct.ITI_Power = ITI_Power;
Zstruct.LFP_ITI = LFP_ITI;

else
%% Figure 18.3

% define baseline period
% baselinetime = [ -500 -200 ]; % in ms
% 
% % convert baseline window time to indices
% [~,baselineidx(1)]=min(abs(EEG.times-baselinetime(1)));
% [~,baselineidx(2)]=min(abs(EEG.times-baselinetime(2)));

% dB-correct
baseline_power = mean(mean(tf_data_ITI,3),2);
dbconverted = 10*log10( bsxfun(@rdivide,tf_data,baseline_power));
% FYI: the following lines of code are equivalent to the previous line:
% dbconverted = 10*( bsxfun(@minus,log10(tf_data),log10(baseline_power)));
% dbconverted = 10*log10( tf_data ./ repmat(baseline_power,1,EEG.pnts) );
% dbconverted = 10*( log10(tf_data) - log10(repmat(baseline_power,1,EEG.pnts)) );

figure
contourf(dbconverted,40,'linecolor','none')
set(gca,'ytick',round(linspace(frequencies(1),frequencies(end),10)*100)/100,'xlim',[0 4000],'clim',[-12 12])
title('Color limit of -12 to +12 dB')
hcb2=colorbar;
ylabel(hcb2, 'dB Change from ITI-Averaged Baseline');
colormap jet;

%% Figure 18.6
% real data: percent change
baseline_power = mean(mean(tf_data_ITI,3),2);
pctchange = 100 * (tf_data-repmat(baseline_power,1,size(HHData.LFP.LFPData,2)))./ repmat(baseline_power,1,size(HHData.LFP.LFPData,2));
baselinediv = tf_data ./ repmat(baseline_power,1,size(HHData.LFP.LFPData,2));


baseline_power = mean(tf_data_ITI,3);
% Z-transform
baselineZ = (tf_data-repmat(mean(baseline_power,2),1,size(tf_data,2))) ./ repmat(std(baseline_power,[],2),1,size(tf_data,2));

%% Figure 18.7

figure

% plot dB-converted power
subplot(221)
imagesc(HHData.IntervalInformation.Times(:,26),[],dbconverted)
set(gca,'ytick',ytickskip,'yticklabel',round(frequencies(ytickskip)),'ydir','normal','clim',[-10 10])
title('dB change from baseline')
hcb2=colorbar;
ylabel(hcb2, 'dB Change from ITI-Averaged Baseline');
colormap jet;


% plot percent-change
subplot(222)
imagesc(HHData.IntervalInformation.Times(:,26),[],pctchange)
set(gca,'ytick',ytickskip,'yticklabel',round(frequencies(ytickskip)),'ydir','normal','clim',[-500 500])
title('Percent change from baseline')
hcb2=colorbar;
ylabel(hcb2, 'Percent Change from ITI-Averaged Baseline');
colormap jet;


% divide by baseline
subplot(223)
imagesc(HHData.IntervalInformation.Times(:,26),[],baselinediv)
set(gca,'ytick',ytickskip,'yticklabel',round(frequencies(ytickskip)),'ydir','normal','clim',[-7.5 7.5])
title('Divide by baseline')
hcb2=colorbar;
ylabel(hcb2, 'Division from ITI-Averaged Baseline');
colormap jet;


% z-transform
subplot(224)
imagesc(HHData.IntervalInformation.Times(:,26),[],baselineZ)
set(gca,'ytick',ytickskip,'yticklabel',round(frequencies(ytickskip)),'ydir','normal','clim',[-3.5 3.5])
title('Z-transform')
hcb2=colorbar;
ylabel(hcb2, 'Z-Score Using ITI-Averaged Baseline');
colormap jet;

% figure
% 
% imagesc([0 1],[],squeeze((10*log10(tf_data_ITI(:,:,:)))));
% set(gca,'ytick',ytickskip,'yticklabel',round(frequencies(ytickskip)),'ydir','normal','clim',[-100 100])
% title('Baseline')
% hcb2=colorbar;
% ylabel(hcb2, 'Power (Conventional dB)');
% colormap jet;

end