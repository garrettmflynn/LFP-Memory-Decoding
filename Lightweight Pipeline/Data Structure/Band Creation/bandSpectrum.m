function [HHData] = bandSpectrum(HHData,SpectrumFrequencies,choice)

% Initialize Variables
spectralParameters = bandParams(SpectrumFrequencies);
fullSpectrum = HHData.Data.LFP.Spectrum;

theta = spectralParameters.theta;
alpha = spectralParameters.alpha;
beta = spectralParameters.beta;
lowGamma = spectralParameters.lowGamma;
highGamma = spectralParameters.highGamma;

%% Spectral Band Derivation

switch choice
    case 'theta'
matchTheta(1) = find(SpectrumFrequencies  == theta(1));
matchTheta(2) = find(SpectrumFrequencies  == theta(2));
HHData.ML.thetaSpectrum = fullSpectrum(matchTheta(1):matchTheta(2),:,:,:);

    case 'alpha'

matchAlpha(1) = find(SpectrumFrequencies  == alpha(1));
matchAlpha(2) = find(SpectrumFrequencies  == alpha(2));
HHData.ML.alphaSpectrum = fullSpectrum(matchAlpha(1):matchAlpha(2),:,:,:);

    case 'beta'

matchBeta(1) = find(SpectrumFrequencies==beta(1));
matchBeta(2) = find(SpectrumFrequencies==beta(2));
HHData.ML.betaSpectrum = fullSpectrum(matchBeta(1):matchBeta(2),:,:,:);

    case 'lowGamma'

matchGamma_L(1) = find(SpectrumFrequencies==lowGamma(1));
matchGamma_L(2) = find(SpectrumFrequencies==lowGamma(2));
HHData.ML.lowGammaSpectrum = fullSpectrum(matchGamma_L(1):matchGamma_L(2),:,:,:);

    case 'highGamma'

matchGamma_H(1) = find(SpectrumFrequencies==highGamma(1));
matchGamma_H(2) = find(SpectrumFrequencies==highGamma(2));
HHData.ML.highGammaSpectrum = fullSpectrum(matchGamma_H(1):matchGamma_H(2),:,:,:);
end
end

