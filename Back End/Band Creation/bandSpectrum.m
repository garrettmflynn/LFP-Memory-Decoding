function [Spectrum_Bands] = bandSpectrum(fullSpectrum,SpectrumFrequencies)

bandParams(SpectrumFrequencies);

%% Spectral Band Derivation

if nargin == 3
    fullSignal = NaN;
end

matchTheta(1) = SpectrumFrequencies (SpectrumFrequencies  == theta(1));
matchTheta(2) = SpectrumFrequencies (SpectrumFrequencies  == theta(2));
Spectrum_Bands.Theta = fullSpectrum(matchTheta(1):matchTheta(2),:,:,:)

Spectrum_Bands.Alpha = (bandpass(fullSignal',alpha,samplingFreq))';

Spectrum_Bands.Beta = (bandpass(fullSignal',beta,samplingFreq))';


Spectrum_Bands.Gamma_L = (bandpass(fullSignal',lowGamma,samplingFreq))';

Spectrum_Bands.Gamma_H = (bandpass(fullSignal',highGamma,samplingFreq))';

end

