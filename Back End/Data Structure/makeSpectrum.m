function [spectrum] = makeSpectrum(inputData,parameters)

freq = parameters.Derived.freq;
winSize = parameters.Choices.timeBin * parameters.Derived.samplingFreq;
overlap = parameters.Derived.overlap;

for channels = 1:size(inputData,1)
if ~isempty(parameters.Optional.iteration)
method = parameters.Optional.methods{parameters.Optional.iteration};

switch method
    case 'Hamming'
        for channels = 1:size(inputData,1)
            [s,f,t, PSDs, fc, tc] = spectrogram(inputData(channels,:),hamming(winSize),overlap,freq, parameters.Derived.samplingFreq,'yaxis');
            spectrum(:,:,channels) = (10*log10(PSDs)).*freq';
        end
        
    case 'Hanning'
        for channels = 1:size(inputData,1)
            [s,f,t, PSDs, fc, tc] = spectrogram(inputData(channels,:),hann(winSize),overlap,freq, parameters.Derived.samplingFreq,'yaxis');
            spectrum(:,:,channels) = (10*log10(PSDs)).*freq';
        end
        
    case 'Kaiser'
        for channels = 1:size(inputData,1)
            [s,f,t, PSDs, fc, tc] = spectrogram(inputData(channels,:),kaiser(winSize),overlap,freq, parameters.Derived.samplingFreq,'yaxis');
            spectrum(:,:,channels) = (10*log10(PSDs)).*freq';
        end
        
    case 'Taylor'
        for channels = 1:size(inputData,1)
            [s,f,t, PSDs, fc, tc] = spectrogram(inputData(channels,:),taylorwin(winSize),overlap,freq, parameters.Derived.samplingFreq,'yaxis');
            spectrum(:,:,channels) = (10*log10(PSDs)).*freq';
        end     
end

else 
[s,f,t, PSDs, fc, tc] = spectrogram(inputData(channels,:),(winSize),overlap,freq, parameters.Derived.samplingFreq,'yaxis');
spectrum(:,:,channels) = (10*log10(PSDs)).*freq';  
end
end

end