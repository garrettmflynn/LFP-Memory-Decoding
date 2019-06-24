function [spectrum,time] = makeSpectrum(inputData,parameters)

freq = parameters.Derived.freq;
winSize = parameters.Choices.timeBin * parameters.Derived.samplingFreq;
overlap = parameters.Derived.overlap;

for channels = 1:size(inputData,1)
if ~isempty(parameters.Optional.iteration)
method = parameters.Optional.methods{parameters.Optional.iteration};

switch method
    case 'Hamming'
            [s,f,t, PSDs, fc, tc] = spectrogram(inputData(channels,:),hamming(winSize),overlap,freq, parameters.Derived.samplingFreq,'yaxis');
            spectrum(:,:,channels) = (10*log10(PSDs)).*freq';
            time(channels,:) = t;
        
        %spectrogram(HHData.LFP.Sampled(:,:,1),hamming(winSize),overlap,freq,parameters.Derived.samplingFreq,'yaxis');
        
    case 'Hanning'
            [s,f,t, PSDs, fc, tc] = spectrogram(inputData(channels,:),hann(winSize),overlap,freq, parameters.Derived.samplingFreq,'yaxis');
            spectrum(:,:,channels) = (10*log10(PSDs)).*freq';
            time(channels,:) = t;
        
    case 'Kaiser'
            [s,f,t, PSDs, fc, tc] = spectrogram(inputData(channels,:),kaiser(winSize),overlap,freq, parameters.Derived.samplingFreq,'yaxis');
            spectrum(:,:,channels) = (10*log10(PSDs)).*freq';
            time(channels,:) = t;
        
    case 'Taylor'
            [s,f,t, PSDs, fc, tc] = spectrogram(inputData(channels,:),taylorwin(winSize),overlap,freq, parameters.Derived.samplingFreq,'yaxis');
            spectrum(:,:,channels) = (10*log10(PSDs)).*freq';
            time(channels,:) = t;
end

else 
[s,f,t, PSDs, fc, tc] = spectrogram(inputData(channels,:),(winSize),overlap,freq, parameters.Derived.samplingFreq,'yaxis');
spectrum(:,:,channels) = (10*log10(PSDs)).*freq';  
time(channels,:) = t;
end
end

end