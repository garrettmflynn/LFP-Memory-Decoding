function [spectrum,time,freq] = makeSpectrum(inputData,parameters)

tf_method = parameters.Optional.methods;


if ~strncmp(tf_method,'Morlet',4)
freq = parameters.Derived.freq;
winSize = parameters.Choices.timeBin * parameters.Derived.samplingFreq;
overlap = (parameters.Derived.overlap);
method = 'Hanning';

for channels = 1:size(inputData,1)

switch tf_method
    case 'Hamming'
            [s,f,t, PSDs, fc, tc] = spectrogram(inputData(channels,:),hamming(winSize),overlap,freq, parameters.Derived.samplingFreq,'yaxis');
            spectrum(:,:,channels) = PSDs;
            time = t;
        
        %spectrogram(HHData.LFP.Sampled(:,:,1),hamming(winSize),overlap,freq,parameters.Derived.samplingFreq,'yaxis');
        
    case 'Hanning'
            [s,f,t, PSDs, fc, tc] = spectrogram(inputData(channels,:),hann(winSize),overlap,freq, parameters.Derived.samplingFreq,'yaxis');
            spectrum(:,:,channels) = PSDs;
            time = t;
        
    case 'Kaiser'
            [s,f,t, PSDs, fc, tc] = spectrogram(inputData(channels,:),kaiser(winSize,5),overlap,freq, parameters.Derived.samplingFreq,'yaxis');
            spectrum(:,:,channels) =PSDs;
            time = t;
        
    case 'Taylor'
            [s,f,t, PSDs, fc, tc] = spectrogram(inputData(channels,:),taylorwin(winSize,4,-75),overlap,freq, parameters.Derived.samplingFreq,'yaxis');
            spectrum(:,:,channels) =PSDs;
            time = t;
end
end


%% All Morlet Analyses and Visualizations
elseif strncmp(tf_method,'Morlet',4)
% wavelet parameters
min_freq = parameters.Choices.freqMin;
max_freq = parameters.Choices.freqMax;
num_frex = round((max_freq-min_freq)/2);

% other wavelet parameters
frequencies = linspace(min_freq,max_freq,num_frex);
time = -1:1/parameters.Choices.downSample:1;
half_of_wavelet_size = (length(time)-1)/2;

% FFT parameters (use next-power-of-2)
n_wavelet     = length(time);
n_data        = size(inputData,2);
n_convolution = n_wavelet+n_data-1;
n_conv_pow2   = pow2(nextpow2(n_convolution));
wavelet_cycles= 12;


% initialize output time-frequency data
spectrum = NaN(length(frequencies),size(inputData,2),size(inputData,1));

for channeli = 1:size(inputData,1)
% FFT of data (note: this doesn't change on frequency iteration)
fft_data = fft(squeeze(inputData(channeli,:)),n_conv_pow2);

for fi=1:length(frequencies)
    
    % create wavelet and get its FFT
    wavelet = (pi*frequencies(fi)*sqrt(pi))^-.5 * exp(2*1i*pi*frequencies(fi).*time) .* exp(-time.^2./(2*( wavelet_cycles /(2*pi*frequencies(fi)))^2))/frequencies(fi);
    fft_wavelet = fft(wavelet,n_conv_pow2);

    % run convolution
    convolution_result_fft = ifft(fft_wavelet.*fft_data,n_conv_pow2);
    convolution_result_fft = convolution_result_fft(1:n_convolution); % note: here we remove the extra points from the power-of-2 FFT
    convolution_result_fft = convolution_result_fft(half_of_wavelet_size+1:end-half_of_wavelet_size);
    
    % put power data into time-frequency matrix
    spectrum(fi,:,channeli) = abs(convolution_result_fft).^2;
end
end


ytickskip = 2:4:num_frex; 
time = linspace(0,(size(inputData,2)-1)/parameters.Choices.downSample,(size(inputData,2)));
freq = frequencies;
end
end
    