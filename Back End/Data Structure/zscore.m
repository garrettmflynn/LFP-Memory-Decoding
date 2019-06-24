function [Zstruct] = zscore([LFP_Data,LFP_Spectrum],parameters)   

fprintf('Now Creating ZScore Data\n');
    
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
end