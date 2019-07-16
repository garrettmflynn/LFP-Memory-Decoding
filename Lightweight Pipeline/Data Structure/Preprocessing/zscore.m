function [normStruct] = zscore(LFP_Cell,parameters)  

LFP_Data = LFP_Cell{1};
LFP_Spectrum = LFP_Cell{2};


%% Signal Normalization | ZScore
frequencyMu = mean(LFP_Data');
frequencySigma = std(LFP_Data');
LFP_Signal_ZScore = ((LFP_Data'-frequencyMu)./frequencySigma)';

normStruct.Signal = LFP_Signal_ZScore;


%% Spectral Normalization

if strncmp(parameters.Optional.methods,'STFT',4)
fprintf('Now Creating ZScore Data\n');

%% Many Channels | STFT
if ndims(squeeze(LFP_Spectrum)) == 3
    
frequencyMu = squeeze(mean(permute(LFP_Spectrum,[2,1,3])));

frequencySigma = squeeze(std(permute(LFP_Spectrum,[2,1,3])));

LFP_Spectrum_ZScore = permute(((permute(LFP_Spectrum,[1,3,2])-frequencyMu)./frequencySigma),[1,3,2]);    

%% One Channel | STFT
else
frequencyMu = squeeze(mean(LFP_Spectrum'));

frequencySigma = squeeze(std(LFP_Spectrum'));

LFP_Spectrum_ZScore = ((LFP_Spectrum'-frequencyMu)./frequencySigma)';
end

normStruct.Spectrum = LFP_Spectrum_ZScore;


elseif strncmp(parameters.Optional.methods,'Morlet',4)
%% Wavelet dB Change
if strncmpi(parameters.Optional.normMethod,'dB',2)
%[-10 10]
baseline_power = mean(LFP_Spectrum,2);
spectrumNorm = 10*log10( bsxfun(@rdivide,LFP_Spectrum,baseline_power));

% elseif strncmpi(parameters.Optional.normMethod,'Percent',2)
% % Percent Change from ITI-Averaged Baseline [-500 500]
% baseline_power = squeeze(mean(LFP_Spectrum,2));
% 
% for channeli = 1:size(LFP_Spectrum,3)
% pctchange(:,:,channeli) = 100 * (LFP_Spectrum(:,:,channeli)-baseline_power(:,channeli)) ./ (baseline_power(:,channeli));
% baselinediv(:,:,channeli) = LFP_Spectrum(:,:,channeli) ./ baseline_power(:,channeli)
% end

%% Wavelet ZScore
elseif strncmpi(parameters.Optional.normMethod,'ZScore',2)
%  [-3.5 3.5]
spectrumNorm = ((LFP_Spectrum-repmat(mean(LFP_Spectrum,2),1,size(LFP_Spectrum,2))) ./ repmat(std(LFP_Spectrum,[],2),1,size(LFP_Spectrum,2)));
end

normStruct.Spectrum = spectrumNorm;


end






visualizationSpecified(normStruct.Spectrum, [], times, samplingFreq, dataName, channelNumber,intervalTimes,colorUnit, lims, saveDir, whichtypes,logSignal)






end