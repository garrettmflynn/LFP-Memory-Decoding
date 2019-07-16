function [SpectralAnalysis] = bandParams(freqUsed)

%% Specify Band Bounds (in Hz) 
theta = [4 8];
alpha = [8 12];
beta = [16 24];
lowGamma = [25, 55];
highGamma = [65, 140];


%% Match Bounds to Actual Frequency Bins
for ii = 1:2
[minValue,closestIndex] = min(abs(freqUsed-theta(ii)'));
    SpectralAnalysis.Theta(ii) = freqUsed(closestIndex);

[minValue,closestIndex] = min(abs(freqUsed-alpha(ii)'));
    SpectralAnalysis.Alpha(ii) = freqUsed(closestIndex);

[minValue,closestIndex] = min(abs(freqUsed-beta(ii)'));
SpectralAnalysis.Beta(ii) = freqUsed(closestIndex);


[minValue,closestIndex] = min(abs(freqUsed-lowGamma(ii)'));
   SpectralAnalysis.Gamma_L(ii) = freqUsed(closestIndex);

[minValue,closestIndex] = min(abs(freqUsed-highGamma(ii)'));
   SpectralAnalysis.Gamma_H(ii) = freqUsed(closestIndex);
end

