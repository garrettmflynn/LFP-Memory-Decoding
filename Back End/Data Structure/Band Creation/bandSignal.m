function [Signal_Bands] = bandSignal(fullSignal,SpectrumFrequencies,samplingFreq)

spectralParameters = bandParams(SpectrumFrequencies);

theta = spectralParameters.Theta;
alpha = spectralParameters.Alpha;
beta = spectralParameters.Beta;
lowGamma = spectralParameters.Gamma_L;
highGamma = spectralParameters.Gamma_H;


Signal_Bands.Theta.Signal =  (bandpass(fullSignal',theta,samplingFreq))';
Signal_Bands.Alpha.Signal = (bandpass(fullSignal',alpha,samplingFreq))';
Signal_Bands.Beta.Signal = (bandpass(fullSignal',beta,samplingFreq))';
Signal_Bands.Gamma_L.Signal = (bandpass(fullSignal',lowGamma,samplingFreq))';
Signal_Bands.Gamma_H.Signal = (bandpass(fullSignal',highGamma,samplingFreq))';

end

