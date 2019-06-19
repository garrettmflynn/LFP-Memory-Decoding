function [LFP_Bands] = bandLFP(spectrumMatrix,parameters,fullSignal)

freq = parameters.Derived.freq;
theta = parameters.SpectralAnalysis.Theta;
alpha = parameters.SpectralAnalysis.Alpha;
beta = parameters.SpectralAnalysis.Beta;
gamma = parameters.SpectralAnalysis.Gamma;


LFP_Bands.Theta.Signal =  (bandpass(fullSignal',theta,parameters.Derived.samplingFreq))';
LFP_Bands.Theta.Spectrum = spectrumMatrix(find(freq == theta(1)):find(freq == theta(2)),:,:);

LFP_Bands.Alpha.Signal = (bandpass(fullSignal',alpha,parameters.Derived.samplingFreq))';
LFP_Bands.Alpha.Spectrum = spectrumMatrix(find(freq == alpha(1)):find(freq == alpha(2)),:,:);

LFP_Bands.Beta.Signal = (bandpass(fullSignal',beta,parameters.Derived.samplingFreq))';
LFP_Bands.Beta.Spectrum = spectrumMatrix(find(freq == beta(1)):find(freq == beta(2)),:,:);


LFP_Bands.Gamma.Signal = (bandpass(fullSignal',gamma,parameters.Derived.samplingFreq))';
LFP_Bands.Gamma.Spectrum = spectrumMatrix(find(freq == gamma(1)):find(freq == gamma(2)),:,:);

end
