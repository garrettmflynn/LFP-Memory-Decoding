function [Spectrum_Bands] = bandSpectrum(fullSpectrum,SpectrumFrequencies)

spectralParameters = bandParams(SpectrumFrequencies);

theta = spectralParameters.Theta;
alpha = spectralParameters.Alpha;
beta = spectralParameters.Beta;
lowGamma = spectralParameters.Gamma_L;
highGamma = spectralParameters.Gamma_H;

%% Spectral Band Derivation

if nargin == 3
    fullSignal = NaN;
end

matchTheta(1) = find(SpectrumFrequencies  == theta(1));
matchTheta(2) = find(SpectrumFrequencies  == theta(2));
Spectrum_Bands.Theta = fullSpectrum(matchTheta(1):matchTheta(2),:,:,:);

matchAlpha(1) = find(SpectrumFrequencies  == alpha(1));
matchAlpha(2) = find(SpectrumFrequencies  == alpha(2));
Spectrum_Bands.Alpha = fullSpectrum(matchAlpha(1):matchAlpha(2),:,:,:);

matchBeta(1) = find(SpectrumFrequencies==beta(1));
matchBeta(2) = find(SpectrumFrequencies==beta(2));
Spectrum_Bands.Beta = fullSpectrum(matchBeta(1):matchBeta(2),:,:,:);

matchGamma_L(1) = find(SpectrumFrequencies==lowGamma(1));
matchGamma_L(2) = find(SpectrumFrequencies==lowGamma(2));
Spectrum_Bands.Gamma_L = fullSpectrum(matchGamma_L(1):matchGamma_L(2),:,:,:);

matchGamma_H(1) = find(SpectrumFrequencies==highGamma(1));
matchGamma_H(2) = find(SpectrumFrequencies==highGamma(2));
Spectrum_Bands.Gamma_H = fullSpectrum(matchGamma_H(1):matchGamma_H(2),:,:,:);
end

