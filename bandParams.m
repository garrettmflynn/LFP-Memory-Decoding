function [] = bandParams(freqUsed)

% Band Bounds (in Hz) | Actual Values Will Be Derived Later
theta = [4 8];
alpha = [8 12];
beta = [16 24];
lowGamma = [25, 55];
highGamma = [65, 140];

for ii = 1:2
[minValue,closestIndex] = min(abs(freqUsed-theta(ii)'));
    parameters.SpectralAnalysis.Theta(ii) = freqUsed(closestIndex);

[minValue,closestIndex] = min(abs(freqUsed-alpha(ii)'));
    parameters.SpectralAnalysis.Alpha(ii) = freqUsed(closestIndex);

[minValue,closestIndex] = min(abs(freqUsed-beta(ii)'));
 parameters.SpectralAnalysis.Beta(ii) = freqUsed(closestIndex);


[minValue,closestIndex] = min(abs(freqUsed-lowGamma(ii)'));
    parameters.SpectralAnalysis.Gamma_L(ii) = freqUsed(closestIndex);
    
if parameters.Choices.freqMax < highGamma(2)
    highGamma(2) = parameters.Choices.freqMax;
end

[minValue,closestIndex] = min(abs(freqUsed-highGamma(ii)'));
    parameters.SpectralAnalysis.Gamma_H(ii) = freqUsed(closestIndex);
end

clear highGamma
clear alpha
clear beta
clear lowGamma
clear theta