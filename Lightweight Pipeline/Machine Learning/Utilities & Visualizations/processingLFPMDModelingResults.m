% This script is used to process the modeling results of the LFP MD model
% between Permute-based vs. PCA-based vs. Raw Signal based cases
% Multi-Channle (MCA) case
% Author : Xiwei She
% Date: 29/07/2019

rPattern = fullfile(resultsDir, ['singleTestResult_*.mat']);
rMatch = dir(rPattern);
if ~isempty(rMatch)
for formatChoice = 1:length(rMatch)
currentTestResult = rMatch.name;

%% Load modeling result
% New Structure:
 %    1D = Input Format ([band]Signal/Spectrum)
 %    2D = Learner
 %    3D = Category
 %    4D = FeatureType
 %    5D = PCA Coefficient
 %    6D = BSpline Resolution
load(fullfile(resultsDir, currentTestResult));
formats{formatChoice} = extractBetween(currentTestResult,'_','.')

% Only Extract MCA
choiceMethod = cResults.MCA;

% Collect All Bands in One Structure
results(formatChoice,:,:,:,:,:) = choiceMethod;
end

% Unpack Dimensions
[numFormats,numLearners,numCategories,numFeatures,numCoeffs,numRes] = size(results);
learners = cResults.MetaData.usedLearners;
categories = cResults.MetaData.usedCategories;
features = cResults.MetaData.caseNames;
resolutions = cResults.MetaData.Resolutions
coeffs = cResults.MetaData.pcaCoefficients

if length(unique(resolutions)) > length(unique(coeffs))
x = resolutions;
elseif length(unique(coeffs)) > length(unique(resolutions))
x = coeffs;
else
    disp('Confusion regarding what to put on the x-axis. Manually inspect code');
end

for cChoice = 1:numCategories
for fChoice = 1:numFeatures
figure();
for formatChoice = 1:numFormats
    currentFormat = formats{formatChoice};

%% MCC vs. Resolution Plots
% Learners by Features
dataChoice = squeeze(results(formatChoice,:,cChoice,fChoice,:,:));

ax = subplot(numFormats,formatChoice,1);
plot(x,dataChoice'); hold on;
xlim(x); ylim([-1 1]);
title([currentFormat, ' LFP MD performance | ', features{fChoice}]);

if formatChoice == 1
originalSize1 = get(gca, 'Position');
legend(learners,'Location','northeastoutside');
set(ax, 'Position', originalSize1);
end
end
end

sgtitle(categories{cChoices},'fontweight','bold','FontSize','30')
end



%% MCC Bar Plots

for fChoice = 1:numFeatures
figure();
    currentFormat = formats{formatChoice};
    
% Learners by Features
dataChoice = squeeze(results(formatChoice,:,:,fChoice,:,:));
dataMax = max(dataChoice,3);

% Each row is a separate category
if size(dataMax,2) > 1
    dataMax = dataMax(:);
end

ax = subplot(numFormats,formatChoice,1);
bar(dataMax', 'FaceColor', 'flat'); hold on;
xlim(x); ylim([-1 1]);
title([' Bar Plot for LFP MD Model | ', currentFormat]);

if formatChoice == 1
originalSize1 = get(gca, 'Position');
legend(learners,'Location','northeastoutside');
set(ax, 'Position', originalSize1);
end
end

sgtitle(categories{cChoices},'fontweight','bold','FontSize','30')

else
    error('No Results Found');
end










% % This script is used to process the modeling results of the LFP MD model
% % between Permute-based vs. PCA-based vs. Raw Signal based cases
% % Multi-Channle (MCA) case
% % Author : Xiwei She
% % Date: 29/07/2019
% 
% %% Alpha band LFP
% % Load modeling result
% cd resultsDir
% load('singleTestResult_alphaSpectrum.mat');
% 
% % Claim variable for saving results
% numOfKnots = numel(fieldnames(cResults.MCA));
% 
% % Permute-based
% alpha_Animal_permute = zeros(numOfKnots, 1);
% alpha_Building_permute = zeros(numOfKnots, 1);
% alpha_Plant_permute = zeros(numOfKnots, 1);
% alpha_Tool_permute = zeros(numOfKnots, 1);
% alpha_Vehicle_permute = zeros(numOfKnots, 1);
% % PCA-based
% alpha_Animal_pca = zeros(numOfKnots, 1);
% alpha_Building_pca = zeros(numOfKnots, 1);
% alpha_Plant_pca = zeros(numOfKnots, 1);
% alpha_Tool_pca = zeros(numOfKnots, 1);
% alpha_Vehicle_pca = zeros(numOfKnots, 1);
% % Signal-based
% alpha_Animal_signal = zeros(numOfKnots, 1);
% alpha_Building_signal = zeros(numOfKnots, 1);
% alpha_Plant_signal = zeros(numOfKnots, 1);
% alpha_Tool_signal = zeros(numOfKnots, 1);
% alpha_Vehicle_signal = zeros(numOfKnots, 1);
% 
% % Processing results
% fieldNamePool = fieldnames(cResults.MCA);
% for tempVar = 1:numOfKnots % Loop through all 50:150 knots
%     currentFiledName = fieldNamePool{tempVar};
%     alpha_Animal_permute(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Animal.PermuteResult;
%     alpha_Building_permute(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Building.PermuteResult;
%     alpha_Plant_permute(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Plant.PermuteResult;
%     alpha_Tool_permute(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Tool.PermuteResult;
%     alpha_Vehicle_permute(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Vehicle.PermuteResult;
%     
%     alpha_Animal_pca(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Animal.PCAResult;
%     alpha_Building_pca(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Building.PCAResult;
%     alpha_Plant_pca(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Plant.PCAResult;
%     alpha_Tool_pca(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Tool.PCAResult;
%     alpha_Vehicle_pca(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Vehicle.PCAResult;
%     
%     alpha_Animal_signal(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Animal.SignalResult;
%     alpha_Building_signal(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Building.SignalResult;
%     alpha_Plant_signal(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Plant.SignalResult;
%     alpha_Tool_signal(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Tool.SignalResult;
%     alpha_Vehicle_signal(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Vehicle.SignalResult;
% end
% 
% %% Beta band LFP
% % Load modeling result
% load('singleTestResult_betaSpectrum.mat');
% 
% % Claim variable for saving results
% numOfKnots = numel(fieldnames(cResults.MCA));
% 
% % Permute-based
% beta_Animal_permute = zeros(numOfKnots, 1);
% beta_Building_permute = zeros(numOfKnots, 1);
% beta_Plant_permute = zeros(numOfKnots, 1);
% beta_Tool_permute = zeros(numOfKnots, 1);
% beta_Vehicle_permute = zeros(numOfKnots, 1);
% % PCA-based
% beta_Animal_pca = zeros(numOfKnots, 1);
% beta_Building_pca = zeros(numOfKnots, 1);
% beta_Plant_pca = zeros(numOfKnots, 1);
% beta_Tool_pca = zeros(numOfKnots, 1);
% beta_Vehicle_pca = zeros(numOfKnots, 1);
% % Signal-based
% beta_Animal_signal = zeros(numOfKnots, 1);
% beta_Building_signal = zeros(numOfKnots, 1);
% beta_Plant_signal = zeros(numOfKnots, 1);
% beta_Tool_signal = zeros(numOfKnots, 1);
% beta_Vehicle_signal = zeros(numOfKnots, 1);
% 
% % Processing results
% fieldNamePool = fieldnames(cResults.MCA);
% for tempVar = 1:numOfKnots % Loop through all 50:150 knots
%     currentFiledName = fieldNamePool{tempVar};
%     beta_Animal_permute(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Animal.PermuteResult;
%     beta_Building_permute(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Building.PermuteResult;
%     beta_Plant_permute(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Plant.PermuteResult;
%     beta_Tool_permute(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Tool.PermuteResult;
%     beta_Vehicle_permute(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Vehicle.PermuteResult;
%     
%     beta_Animal_pca(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Animal.PCAResult;
%     beta_Building_pca(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Building.PCAResult;
%     beta_Plant_pca(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Plant.PCAResult;
%     beta_Tool_pca(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Tool.PCAResult;
%     beta_Vehicle_pca(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Vehicle.PCAResult;
%     
%     beta_Animal_signal(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Animal.SignalResult;
%     beta_Building_signal(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Building.SignalResult;
%     beta_Plant_signal(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Plant.SignalResult;
%     beta_Tool_signal(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Tool.SignalResult;
%     beta_Vehicle_signal(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Vehicle.SignalResult;
% end
% 
% %% Theta band LFP
% % Load modeling result
% load('singleTestResult_thetaSpectrum.mat');
% 
% % Claim variable for saving results
% numOfKnots = numel(fieldnames(cResults.MCA));
% 
% % Permute-based
% theta_Animal_permute = zeros(numOfKnots, 1);
% theta_Building_permute = zeros(numOfKnots, 1);
% theta_Plant_permute = zeros(numOfKnots, 1);
% theta_Tool_permute = zeros(numOfKnots, 1);
% theta_Vehicle_permute = zeros(numOfKnots, 1);
% % PCA-based
% theta_Animal_pca = zeros(numOfKnots, 1);
% theta_Building_pca = zeros(numOfKnots, 1);
% theta_Plant_pca = zeros(numOfKnots, 1);
% theta_Tool_pca = zeros(numOfKnots, 1);
% theta_Vehicle_pca = zeros(numOfKnots, 1);
% % Signal-based
% theta_Animal_signal = zeros(numOfKnots, 1);
% theta_Building_signal = zeros(numOfKnots, 1);
% theta_Plant_signal = zeros(numOfKnots, 1);
% theta_Tool_signal = zeros(numOfKnots, 1);
% theta_Vehicle_signal = zeros(numOfKnots, 1);
% 
% % Processing results
% fieldNamePool = fieldnames(cResults.MCA);
% for tempVar = 1:numOfKnots % Loop through all 50:150 knots
%     currentFiledName = fieldNamePool{tempVar};
%     theta_Animal_permute(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Animal.PermuteResult;
%     theta_Building_permute(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Building.PermuteResult;
%     theta_Plant_permute(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Plant.PermuteResult;
%     theta_Tool_permute(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Tool.PermuteResult;
%     theta_Vehicle_permute(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Vehicle.PermuteResult;
%     
%     theta_Animal_pca(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Animal.PCAResult;
%     theta_Building_pca(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Building.PCAResult;
%     theta_Plant_pca(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Plant.PCAResult;
%     theta_Tool_pca(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Tool.PCAResult;
%     theta_Vehicle_pca(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Vehicle.PCAResult;
%     
%     theta_Animal_signal(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Animal.SignalResult;
%     theta_Building_signal(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Building.SignalResult;
%     theta_Plant_signal(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Plant.SignalResult;
%     theta_Tool_signal(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Tool.SignalResult;
%     theta_Vehicle_signal(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Vehicle.SignalResult;
% end
% 
% %% LowGamma band LFP
% % Load modeling result
% load('singleTestResult_lowGammaSpectrum.mat');
% 
% % Claim variable for saving results
% numOfKnots = numel(fieldnames(cResults.MCA));
% 
% % Permute-based
% lowGamma_Animal_permute = zeros(numOfKnots, 1);
% lowGamma_Building_permute = zeros(numOfKnots, 1);
% lowGamma_Plant_permute = zeros(numOfKnots, 1);
% lowGamma_Tool_permute = zeros(numOfKnots, 1);
% lowGamma_Vehicle_permute = zeros(numOfKnots, 1);
% % PCA-based
% lowGamma_Animal_pca = zeros(numOfKnots, 1);
% lowGamma_Building_pca = zeros(numOfKnots, 1);
% lowGamma_Plant_pca = zeros(numOfKnots, 1);
% lowGamma_Tool_pca = zeros(numOfKnots, 1);
% lowGamma_Vehicle_pca = zeros(numOfKnots, 1);
% % Signal-based
% lowGamma_Animal_signal = zeros(numOfKnots, 1);
% lowGamma_Building_signal = zeros(numOfKnots, 1);
% lowGamma_Plant_signal = zeros(numOfKnots, 1);
% lowGamma_Tool_signal = zeros(numOfKnots, 1);
% lowGamma_Vehicle_signal = zeros(numOfKnots, 1);
% 
% % Processing results
% fieldNamePool = fieldnames(cResults.MCA);
% for tempVar = 1:numOfKnots % Loop through all 50:150 knots
%     currentFiledName = fieldNamePool{tempVar};
%     lowGamma_Animal_permute(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Animal.PermuteResult;
%     lowGamma_Building_permute(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Building.PermuteResult;
%     lowGamma_Plant_permute(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Plant.PermuteResult;
%     lowGamma_Tool_permute(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Tool.PermuteResult;
%     lowGamma_Vehicle_permute(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Vehicle.PermuteResult;
%     
%     lowGamma_Animal_pca(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Animal.PCAResult;
%     lowGamma_Building_pca(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Building.PCAResult;
%     lowGamma_Plant_pca(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Plant.PCAResult;
%     lowGamma_Tool_pca(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Tool.PCAResult;
%     lowGamma_Vehicle_pca(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Vehicle.PCAResult;
%     
%     lowGamma_Animal_signal(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Animal.SignalResult;
%     lowGamma_Building_signal(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Building.SignalResult;
%     lowGamma_Plant_signal(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Plant.SignalResult;
%     lowGamma_Tool_signal(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Tool.SignalResult;
%     lowGamma_Vehicle_signal(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Vehicle.SignalResult;
% end
% 
% %% HighGamma band LFP
% % Load modeling result
% load('singleTestResult_highGammaSpectrum.mat');
% 
% % Claim variable for saving results
% numOfKnots = numel(fieldnames(cResults.MCA));
% 
% % Permute-based
% highGamma_Animal_permute = zeros(numOfKnots, 1);
% highGamma_Building_permute = zeros(numOfKnots, 1);
% highGamma_Plant_permute = zeros(numOfKnots, 1);
% highGamma_Tool_permute = zeros(numOfKnots, 1);
% highGamma_Vehicle_permute = zeros(numOfKnots, 1);
% % PCA-based
% highGamma_Animal_pca = zeros(numOfKnots, 1);
% highGamma_Building_pca = zeros(numOfKnots, 1);
% highGamma_Plant_pca = zeros(numOfKnots, 1);
% highGamma_Tool_pca = zeros(numOfKnots, 1);
% highGamma_Vehicle_pca = zeros(numOfKnots, 1);
% % Signal-based
% highGamma_Animal_signal = zeros(numOfKnots, 1);
% highGamma_Building_signal = zeros(numOfKnots, 1);
% highGamma_Plant_signal = zeros(numOfKnots, 1);
% highGamma_Tool_signal = zeros(numOfKnots, 1);
% highGamma_Vehicle_signal = zeros(numOfKnots, 1);
% 
% % Processing results
% fieldNamePool = fieldnames(cResults.MCA);
% for tempVar = 1:numOfKnots % Loop through all 50:150 knots
%     currentFiledName = fieldNamePool{tempVar};
%     highGamma_Animal_permute(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Animal.PermuteResult;
%     highGamma_Building_permute(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Building.PermuteResult;
%     highGamma_Plant_permute(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Plant.PermuteResult;
%     highGamma_Tool_permute(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Tool.PermuteResult;
%     highGamma_Vehicle_permute(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Vehicle.PermuteResult;
%     
%     highGamma_Animal_pca(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Animal.PCAResult;
%     highGamma_Building_pca(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Building.PCAResult;
%     highGamma_Plant_pca(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Plant.PCAResult;
%     highGamma_Tool_pca(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Tool.PCAResult;
%     highGamma_Vehicle_pca(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Vehicle.PCAResult;
%     
%     highGamma_Animal_signal(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Animal.SignalResult;
%     highGamma_Building_signal(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Building.SignalResult;
%     highGamma_Plant_signal(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Plant.SignalResult;
%     highGamma_Tool_signal(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Tool.SignalResult;
%     highGamma_Vehicle_signal(tempVar, 1) = cResults.MCA.(currentFiledName).lassoGLM.Vehicle.SignalResult;
% end
% 
% %% Save processed results
% save('LFPMDModelingResults_Processed.mat');
