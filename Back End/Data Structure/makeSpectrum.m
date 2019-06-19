function [spectrum] = makeSpectrum(inputData,parameters)

freq = parameters.Derived.freq;
winSize = parameters.Choices.timeBin * parameters.Derived.samplingFreq;
overlap = parameters.Derived.overlap;



for channels = 1:size(inputData,1)
[s,f,t, PSDs, fc, tc] = spectrogram(inputData(channels,:),taylorwin(winSize),overlap,freq, parameters.Derived.samplingFreq,'yaxis');
spectrum(:,:,channels) = (10*log10(PSDs)).*freq';
end