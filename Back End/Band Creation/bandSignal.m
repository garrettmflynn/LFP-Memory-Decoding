function [Signal_Bands] = bandSignal(fullSignal,SpectrumFrequencies,samplingFreq)

bandParams(SpectrumFrequencies);


Signal_Bands.Theta.Signal =  (bandpass(fullSignal',theta,samplingFreq))';
Signal_Bands.Alpha.Signal = (bandpass(fullSignal',alpha,samplingFreq))';
Signal_Bands.Beta.Signal = (bandpass(fullSignal',beta,samplingFreq))';
Signal_Bands.Gamma_L.Signal = (bandpass(fullSignal',lowGamma,samplingFreq))';
Signal_Bands.Gamma_H.Signal = (bandpass(fullSignal',highGamma,samplingFreq))';

end

