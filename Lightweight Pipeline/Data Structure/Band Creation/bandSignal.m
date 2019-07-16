function [Signal_Bands] = bandSignal(fullSignal,SpectrumFrequencies,samplingFreq)

spectralParameters = bandParams(SpectrumFrequencies);

theta = spectralParameters.Theta;
alpha = spectralParameters.Alpha;
beta = spectralParameters.Beta;
lowGamma = spectralParameters.Gamma_L;
highGamma = spectralParameters.Gamma_H;

if ndims(fullSignal) < 3
Signal_Bands.Theta =  (bandpass(fullSignal',theta,samplingFreq))';
Signal_Bands.Alpha = (bandpass(fullSignal',alpha,samplingFreq))';
Signal_Bands.Beta = (bandpass(fullSignal',beta,samplingFreq))';
Signal_Bands.Gamma_L = (bandpass(fullSignal',lowGamma,samplingFreq))';
Signal_Bands.Gamma_H = (bandpass(fullSignal',highGamma,samplingFreq))';




else
fullSignal = squeeze(fullSignal);
for ii = 1:size(fullSignal,3)
    toBand = fullSignal(:,:,ii);
Signal_Bands.Theta(:,:,ii) = (bandpass(toBand',theta,samplingFreq))';
Signal_Bands.Alpha(:,:,ii) = (bandpass(toBand',alpha,samplingFreq))';
Signal_Bands.Beta(:,:,ii) = (bandpass(toBand',beta,samplingFreq))';
Signal_Bands.Gamma_L(:,:,ii) = (bandpass(toBand',lowGamma,samplingFreq))';
Signal_Bands.Gamma_H(:,:,ii) = (bandpass(toBand',highGamma,samplingFreq))';
end
end

