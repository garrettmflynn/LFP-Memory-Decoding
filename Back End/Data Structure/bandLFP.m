function [LFP_Bands] = bandLFP(spectrumMatrix,parameters,fullSignal)

freq = parameters.Derived.freq;
theta = parameters.SpectralAnalysis.Theta;
alpha = parameters.SpectralAnalysis.Alpha;
beta = parameters.SpectralAnalysis.Beta;
lowGamma = parameters.SpectralAnalysis.Gamma_L;
highGamma = parameters.SpectralAnalysis.Gamma_H;

LFP_Bands.Theta.Signal =  (bandpass(fullSignal',theta,parameters.Derived.samplingFreq))';
LFP_Bands.Theta.Spectrum = spectrumMatrix(find(freq == theta(1)):find(freq == theta(2)),:,:);

LFP_Bands.Alpha.Signal = (bandpass(fullSignal',alpha,parameters.Derived.samplingFreq))';
LFP_Bands.Alpha.Spectrum = spectrumMatrix(find(freq == alpha(1)):find(freq == alpha(2)),:,:);

LFP_Bands.Beta.Signal = (bandpass(fullSignal',beta,parameters.Derived.samplingFreq))';
LFP_Bands.Beta.Spectrum = spectrumMatrix(find(freq == beta(1)):find(freq == beta(2)),:,:);


LFP_Bands.LowGamma.Signal = (bandpass(fullSignal',lowGamma,parameters.Derived.samplingFreq))';
LFP_Bands.LowGamma.Spectrum = spectrumMatrix(find(freq == lowGamma(1)):find(freq == lowGamma(2)),:,:);

LFP_Bands.HighGamma.Signal = (bandpass(fullSignal',highGamma,parameters.Derived.samplingFreq))';
LFP_Bands.HighGamma.Spectrum = spectrumMatrix(find(freq == highGamma(1)):find(freq == highGamma(2)),:,:);

end

