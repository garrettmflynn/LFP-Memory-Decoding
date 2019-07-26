function [HHData] = bandSignal(HHData,SpectrumFrequencies,samplingFreq,choice)

% Initialize Variables
spectralParameters = bandParams(SpectrumFrequencies);
fullSignal = HHData.Data.LFP.LFP;

theta = spectralParameters.theta;
alpha = spectralParameters.alpha;
beta = spectralParameters.beta;
lowGamma = spectralParameters.lowGamma;
highGamma = spectralParameters.highGamma;

%% If Full Signal
if ndims(fullSignal) < 3
    switch choice
case 'theta'
HHData.ML.thetaSignal =  (bandpass(fullSignal',theta,samplingFreq))';
case 'alpha'
HHData.ML.alphaSignal = (bandpass(fullSignal',alpha,samplingFreq))';
case 'beta'
HHData.ML.betaSignal = (bandpass(fullSignal',beta,samplingFreq))';
case 'lowGamma'
HHData.ML.lowGammaSignal = (bandpass(fullSignal',lowGamma,samplingFreq))';
case 'highGamma'
HHData.ML.highGammaSignal = (bandpass(fullSignal',highGamma,samplingFreq))';
    end


%% 
else
fullSignal = squeeze(fullSignal);
for ii = 1:size(fullSignal,3)
    toBand = fullSignal(:,:,ii);
switch choice
    case 'theta'
HHData.ML.thetaSignal(:,:,ii) = (bandpass(toBand',theta,samplingFreq))';
case 'alpha'
HHData.ML.alphaSignal(:,:,ii) = (bandpass(toBand',alpha,samplingFreq))';
case 'beta'
HHData.ML.betaSignal(:,:,ii) = (bandpass(toBand',beta,samplingFreq))';
case 'lowGamma'
HHData.ML.lowGammaSignal(:,:,ii) = (bandpass(toBand',lowGamma,samplingFreq))';
case 'highGamma'
HHData.ML.highGammaSignal(:,:,ii) = (bandpass(toBand',highGamma,samplingFreq))';
end
end
end

