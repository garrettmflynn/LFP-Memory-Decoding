% This script is used to measure and visualize the performance comparison
% between Permute-based vs. PCA-based vs. Raw Signal based LFP MD model
% Multi-Channle (MCA) case
% Author : Xiwei She
% Date: 29/07/2019

%% Load processed result from the script: processingLFPMDModelingResults.m
% Load modeling result
save('LFPMDModelingResults_Processed.mat');

%% Visualization - MCC vs. Resolution plots
% Animal
figure();
subplot(5,1,1)
plot(alpha_Animal_permute(:, 1), 'r'); hold on;
plot(alpha_Animal_pca(:, 1), 'g'); hold on;
plot(alpha_Animal_signal(:, 1), 'b'); hold on;
xlim([1 101]); ylim([0 1]);
legend('Permute based', 'PCA based', 'Signal based');
title('Alpha band LFP MD performance');
subplot(5,1,2)
plot(beta_Animal_permute(:, 1), 'r'); hold on;
plot(beta_Animal_pca(:, 1), 'g'); hold on;
plot(beta_Animal_signal(:, 1), 'b'); hold on;
xlim([1 101]); ylim([0 1]);
legend('Permute based', 'PCA based', 'Signal based');
title('Beta band LFP MD performance');
subplot(5,1,3)
plot(theta_Animal_permute(:, 1), 'r'); hold on;
plot(theta_Animal_pca(:, 1), 'g'); hold on;
plot(theta_Animal_signal(:, 1), 'b'); hold on;
xlim([1 101]); ylim([0 1]);
legend('Permute based', 'PCA based', 'Signal based');
title('Theta band LFP MD performance');
subplot(5,1,4)
plot(lowGamma_Animal_permute(:, 1), 'r'); hold on;
plot(lowGamma_Animal_pca(:, 1), 'g'); hold on;
plot(lowGamma_Animal_signal(:, 1), 'b'); hold on;
xlim([1 101]); ylim([0 1]);
legend('Permute based', 'PCA based', 'Signal based');
title('Low Gamma band LFP MD performance');
subplot(5,1,5)
plot(highGamma_Animal_permute(:, 1), 'r'); hold on;
plot(highGamma_Animal_pca(:, 1), 'g'); hold on;
plot(highGamma_Animal_signal(:, 1), 'b'); hold on;
xlim([1 101]); ylim([0 1]);
legend('Permute based', 'PCA based', 'Signal based');
title('High Gamma band LFP MD performance');

% Building
figure();
subplot(5,1,1)
plot(alpha_Building_permute(:, 1), 'r'); hold on;
plot(alpha_Building_pca(:, 1), 'g'); hold on;
plot(alpha_Building_signal(:, 1), 'b'); hold on;
xlim([1 101]); ylim([0 1]);
legend('Permute based', 'PCA based', 'Signal based');
title('Alpha band LFP MD performance');
subplot(5,1,2)
plot(beta_Building_permute(:, 1), 'r'); hold on;
plot(beta_Building_pca(:, 1), 'g'); hold on;
plot(beta_Building_signal(:, 1), 'b'); hold on;
xlim([1 101]); ylim([0 1]);
legend('Permute based', 'PCA based', 'Signal based');
title('Beta band LFP MD performance');
subplot(5,1,3)
plot(theta_Building_permute(:, 1), 'r'); hold on;
plot(theta_Building_pca(:, 1), 'g'); hold on;
plot(theta_Building_signal(:, 1), 'b'); hold on;
xlim([1 101]); ylim([0 1]);
legend('Permute based', 'PCA based', 'Signal based');
title('Theta band LFP MD performance');
subplot(5,1,4)
plot(lowGamma_Building_permute(:, 1), 'r'); hold on;
plot(lowGamma_Building_pca(:, 1), 'g'); hold on;
plot(lowGamma_Building_signal(:, 1), 'b'); hold on;
xlim([1 101]); ylim([0 1]);
legend('Permute based', 'PCA based', 'Signal based');
title('Low Gamma band LFP MD performance');
subplot(5,1,5)
plot(highGamma_Building_permute(:, 1), 'r'); hold on;
plot(highGamma_Building_pca(:, 1), 'g'); hold on;
plot(highGamma_Building_signal(:, 1), 'b'); hold on;
xlim([1 101]); ylim([0 1]);
legend('Permute based', 'PCA based', 'Signal based');
title('High Gamma band LFP MD performance');

% Plant
figure();
subplot(5,1,1)
plot(alpha_Plant_permute(:, 1), 'r'); hold on;
plot(alpha_Plant_pca(:, 1), 'g'); hold on;
plot(alpha_Plant_signal(:, 1), 'b'); hold on;
xlim([1 101]); ylim([0 1]);
legend('Permute based', 'PCA based', 'Signal based');
title('Alpha band LFP MD performance');
subplot(5,1,2)
plot(beta_Plant_permute(:, 1), 'r'); hold on;
plot(beta_Plant_pca(:, 1), 'g'); hold on;
plot(beta_Plant_signal(:, 1), 'b'); hold on;
xlim([1 101]); ylim([0 1]);
legend('Permute based', 'PCA based', 'Signal based');
title('Beta band LFP MD performance');
subplot(5,1,3)
plot(theta_Plant_permute(:, 1), 'r'); hold on;
plot(theta_Plant_pca(:, 1), 'g'); hold on;
plot(theta_Plant_signal(:, 1), 'b'); hold on;
xlim([1 101]); ylim([0 1]);
legend('Permute based', 'PCA based', 'Signal based');
title('Theta band LFP MD performance');
subplot(5,1,4)
plot(lowGamma_Plant_permute(:, 1), 'r'); hold on;
plot(lowGamma_Plant_pca(:, 1), 'g'); hold on;
plot(lowGamma_Plant_signal(:, 1), 'b'); hold on;
xlim([1 101]); ylim([0 1]);
legend('Permute based', 'PCA based', 'Signal based');
title('Low Gamma band LFP MD performance');
subplot(5,1,5)
plot(highGamma_Plant_permute(:, 1), 'r'); hold on;
plot(highGamma_Plant_pca(:, 1), 'g'); hold on;
plot(highGamma_Plant_signal(:, 1), 'b'); hold on;
xlim([1 101]); ylim([0 1]);
legend('Permute based', 'PCA based', 'Signal based');
title('High Gamma band LFP MD performance');

% Tool
figure();
subplot(5,1,1)
plot(alpha_Tool_permute(:, 1), 'r'); hold on;
plot(alpha_Tool_pca(:, 1), 'g'); hold on;
plot(alpha_Tool_signal(:, 1), 'b'); hold on;
xlim([1 101]); ylim([0 1]);
legend('Permute based', 'PCA based', 'Signal based');
title('Alpha band LFP MD performance');
subplot(5,1,2)
plot(beta_Tool_permute(:, 1), 'r'); hold on;
plot(beta_Tool_pca(:, 1), 'g'); hold on;
plot(beta_Tool_signal(:, 1), 'b'); hold on;
xlim([1 101]); ylim([0 1]);
legend('Permute based', 'PCA based', 'Signal based');
title('Beta band LFP MD performance');
subplot(5,1,3)
plot(theta_Tool_permute(:, 1), 'r'); hold on;
plot(theta_Tool_pca(:, 1), 'g'); hold on;
plot(theta_Tool_signal(:, 1), 'b'); hold on;
xlim([1 101]); ylim([0 1]);
legend('Permute based', 'PCA based', 'Signal based');
title('Theta band LFP MD performance');
subplot(5,1,4)
plot(lowGamma_Tool_permute(:, 1), 'r'); hold on;
plot(lowGamma_Tool_pca(:, 1), 'g'); hold on;
plot(lowGamma_Tool_signal(:, 1), 'b'); hold on;
xlim([1 101]); ylim([0 1]);
legend('Permute based', 'PCA based', 'Signal based');
title('Low Gamma band LFP MD performance');
subplot(5,1,5)
plot(highGamma_Tool_permute(:, 1), 'r'); hold on;
plot(highGamma_Tool_pca(:, 1), 'g'); hold on;
plot(highGamma_Tool_signal(:, 1), 'b'); hold on;
xlim([1 101]); ylim([0 1]);
legend('Permute based', 'PCA based', 'Signal based');
title('High Gamma band LFP MD performance');

% Vehicle
figure();
subplot(5,1,1)
plot(alpha_Vehicle_permute(:, 1), 'r'); hold on;
plot(alpha_Vehicle_pca(:, 1), 'g'); hold on;
plot(alpha_Vehicle_signal(:, 1), 'b'); hold on;
xlim([1 101]); ylim([0 1]);
legend('Permute based', 'PCA based', 'Signal based');
title('Alpha band LFP MD performance');
subplot(5,1,2)
plot(beta_Vehicle_permute(:, 1), 'r'); hold on;
plot(beta_Vehicle_pca(:, 1), 'g'); hold on;
plot(beta_Vehicle_signal(:, 1), 'b'); hold on;
xlim([1 101]); ylim([0 1]);
legend('Permute based', 'PCA based', 'Signal based');
title('Beta band LFP MD performance');
subplot(5,1,3)
plot(theta_Vehicle_permute(:, 1), 'r'); hold on;
plot(theta_Vehicle_pca(:, 1), 'g'); hold on;
plot(theta_Vehicle_signal(:, 1), 'b'); hold on;
xlim([1 101]); ylim([0 1]);
legend('Permute based', 'PCA based', 'Signal based');
title('Theta band LFP MD performance');
subplot(5,1,4)
plot(lowGamma_Vehicle_permute(:, 1), 'r'); hold on;
plot(lowGamma_Vehicle_pca(:, 1), 'g'); hold on;
plot(lowGamma_Vehicle_signal(:, 1), 'b'); hold on;
xlim([1 101]); ylim([0 1]);
legend('Permute based', 'PCA based', 'Signal based');
title('Low Gamma band LFP MD performance');
subplot(5,1,5)
plot(highGamma_Vehicle_permute(:, 1), 'r'); hold on;
plot(highGamma_Vehicle_pca(:, 1), 'g'); hold on;
plot(highGamma_Vehicle_signal(:, 1), 'b'); hold on;
xlim([1 101]); ylim([0 1]);
legend('Permute based', 'PCA based', 'Signal based');
title('High Gamma band LFP MD performance');

%% Visualization - MCC bar plots
% Alpha - Animal
maxPermuteTemp_alpha_Animal = max(alpha_Animal_permute(:, 1));
if length(maxPermuteTemp_alpha_Animal) > 1
    maxPermuteTemp_alpha_Animal = maxPermuteTemp_alpha_Animal(1);
end
maxPCATemp_alpha_Animal = max(alpha_Animal_pca(:, 1));
if length(maxPCATemp_alpha_Animal) > 1
    maxPCATemp_alpha_Animal = maxPCATemp_alpha_Animal(1);
end
maxSignalTemp_alpha_Animal = max(alpha_Animal_signal(:, 1));
if length(maxSignalTemp_alpha_Animal) > 1
    maxSignalTemp_alpha_Animal = maxSignalTemp_alpha_Animal(1);
end

% Alpha - Building
maxPermuteTemp_alpha_Building = max(alpha_Building_permute(:, 1));
if length(maxPermuteTemp_alpha_Building) > 1
    maxPermuteTemp_alpha_Building = maxPermuteTemp_alpha_Building(1);
end
maxPCATemp_alpha_Building = max(alpha_Building_pca(:, 1));
if length(maxPCATemp_alpha_Building) > 1
    maxPCATemp_alpha_Building = maxPCATemp_alpha_Building(1);
end
maxSignalTemp_alpha_Building = max(alpha_Building_signal(:, 1));
if length(maxSignalTemp_alpha_Building) > 1
    maxSignalTemp_alpha_Building = maxSignalTemp_alpha_Building(1);
end

% Alpha - Plant
maxPermuteTemp_alpha_Plant = max(alpha_Plant_permute(:, 1));
if length(maxPermuteTemp_alpha_Plant) > 1
    maxPermuteTemp_alpha_Plant = maxPermuteTemp_alpha_Plant(1);
end
maxPCATemp_alpha_Plant = max(alpha_Plant_pca(:, 1));
if length(maxPCATemp_alpha_Plant) > 1
    maxPCATemp_alpha_Plant = maxPCATemp_alpha_Plant(1);
end
maxSignalTemp_alpha_Plant = max(alpha_Plant_signal(:, 1));
if length(maxSignalTemp_alpha_Plant) > 1
    maxSignalTemp_alpha_Plant = maxSignalTemp_alpha_Plant(1);
end

% Alpha - Tool
maxPermuteTemp_alpha_Tool = max(alpha_Tool_permute(:, 1));
if length(maxPermuteTemp_alpha_Tool) > 1
    maxPermuteTemp_alpha_Tool = maxPermuteTemp_alpha_Tool(1);
end
maxPCATemp_alpha_Tool = max(alpha_Tool_pca(:, 1));
if length(maxPCATemp_alpha_Tool) > 1
    maxPCATemp_alpha_Tool = maxPCATemp_alpha_Tool(1);
end
maxSignalTemp_alpha_Tool = max(alpha_Tool_signal(:, 1));
if length(maxSignalTemp_alpha_Tool) > 1
    maxSignalTemp_alpha_Tool = maxSignalTemp_alpha_Tool(1);
end

% Alpha Vehicle
maxPermuteTemp_alpha_Vehicle = max(alpha_Vehicle_permute(:, 1));
if length(maxPermuteTemp_alpha_Vehicle) > 1
    maxPermuteTemp_alpha_Vehicle = maxPermuteTemp_alpha_Vehicle(1);
end
maxPCATemp_alpha_Vehicle = max(alpha_Vehicle_pca(:, 1));
if length(maxPCATemp_alpha_Vehicle) > 1
    maxPCATemp_alpha_Vehicle = maxPCATemp_alpha_Vehicle(1);
end
maxSignalTemp_alpha_Vehicle = max(alpha_Vehicle_signal(:, 1));
if length(maxSignalTemp_alpha_Vehicle) > 1
    maxSignalTemp_alpha_Vehicle = maxSignalTemp_alpha_Vehicle(1);
end

% beta - Animal
maxPermuteTemp_beta_Animal = max(beta_Animal_permute(:, 1));
if length(maxPermuteTemp_beta_Animal) > 1
    maxPermuteTemp_beta_Animal = maxPermuteTemp_beta_Animal(1);
end
maxPCATemp_beta_Animal = max(beta_Animal_pca(:, 1));
if length(maxPCATemp_beta_Animal) > 1
    maxPCATemp_beta_Animal = maxPCATemp_beta_Animal(1);
end
maxSignalTemp_beta_Animal = max(beta_Animal_signal(:, 1));
if length(maxSignalTemp_beta_Animal) > 1
    maxSignalTemp_beta_Animal = maxSignalTemp_beta_Animal(1);
end

% beta - Building
maxPermuteTemp_beta_Building = max(beta_Building_permute(:, 1));
if length(maxPermuteTemp_beta_Building) > 1
    maxPermuteTemp_beta_Building = maxPermuteTemp_beta_Building(1);
end
maxPCATemp_beta_Building = max(beta_Building_pca(:, 1));
if length(maxPCATemp_beta_Building) > 1
    maxPCATemp_beta_Building = maxPCATemp_beta_Building(1);
end
maxSignalTemp_beta_Building = max(beta_Building_signal(:, 1));
if length(maxSignalTemp_beta_Building) > 1
    maxSignalTemp_beta_Building = maxSignalTemp_beta_Building(1);
end

% beta - Plant
maxPermuteTemp_beta_Plant = max(beta_Plant_permute(:, 1));
if length(maxPermuteTemp_beta_Plant) > 1
    maxPermuteTemp_beta_Plant = maxPermuteTemp_beta_Plant(1);
end
maxPCATemp_beta_Plant = max(beta_Plant_pca(:, 1));
if length(maxPCATemp_beta_Plant) > 1
    maxPCATemp_beta_Plant = maxPCATemp_beta_Plant(1);
end
maxSignalTemp_beta_Plant = max(beta_Plant_signal(:, 1));
if length(maxSignalTemp_beta_Plant) > 1
    maxSignalTemp_beta_Plant = maxSignalTemp_beta_Plant(1);
end

% beta - Tool
maxPermuteTemp_beta_Tool = max(beta_Tool_permute(:, 1));
if length(maxPermuteTemp_beta_Tool) > 1
    maxPermuteTemp_beta_Tool = maxPermuteTemp_beta_Tool(1);
end
maxPCATemp_beta_Tool = max(beta_Tool_pca(:, 1));
if length(maxPCATemp_beta_Tool) > 1
    maxPCATemp_beta_Tool = maxPCATemp_beta_Tool(1);
end
maxSignalTemp_beta_Tool = max(beta_Tool_signal(:, 1));
if length(maxSignalTemp_beta_Tool) > 1
    maxSignalTemp_beta_Tool = maxSignalTemp_beta_Tool(1);
end

% beta Vehicle
maxPermuteTemp_beta_Vehicle = max(beta_Vehicle_permute(:, 1));
if length(maxPermuteTemp_beta_Vehicle) > 1
    maxPermuteTemp_beta_Vehicle = maxPermuteTemp_beta_Vehicle(1);
end
maxPCATemp_beta_Vehicle = max(beta_Vehicle_pca(:, 1));
if length(maxPCATemp_beta_Vehicle) > 1
    maxPCATemp_beta_Vehicle = maxPCATemp_beta_Vehicle(1);
end
maxSignalTemp_beta_Vehicle = max(beta_Vehicle_signal(:, 1));
if length(maxSignalTemp_beta_Vehicle) > 1
    maxSignalTemp_beta_Vehicle = maxSignalTemp_beta_Vehicle(1);
end

% theta - Animal
maxPermuteTemp_theta_Animal = max(theta_Animal_permute(:, 1));
if length(maxPermuteTemp_theta_Animal) > 1
    maxPermuteTemp_theta_Animal = maxPermuteTemp_theta_Animal(1);
end
maxPCATemp_theta_Animal = max(theta_Animal_pca(:, 1));
if length(maxPCATemp_theta_Animal) > 1
    maxPCATemp_theta_Animal = maxPCATemp_theta_Animal(1);
end
maxSignalTemp_theta_Animal = max(theta_Animal_signal(:, 1));
if length(maxSignalTemp_theta_Animal) > 1
    maxSignalTemp_theta_Animal = maxSignalTemp_theta_Animal(1);
end

% theta - Building
maxPermuteTemp_theta_Building = max(theta_Building_permute(:, 1));
if length(maxPermuteTemp_theta_Building) > 1
    maxPermuteTemp_theta_Building = maxPermuteTemp_theta_Building(1);
end
maxPCATemp_theta_Building = max(theta_Building_pca(:, 1));
if length(maxPCATemp_theta_Building) > 1
    maxPCATemp_theta_Building = maxPCATemp_theta_Building(1);
end
maxSignalTemp_theta_Building = max(theta_Building_signal(:, 1));
if length(maxSignalTemp_theta_Building) > 1
    maxSignalTemp_theta_Building = maxSignalTemp_theta_Building(1);
end

% theta - Plant
maxPermuteTemp_theta_Plant = max(theta_Plant_permute(:, 1));
if length(maxPermuteTemp_theta_Plant) > 1
    maxPermuteTemp_theta_Plant = maxPermuteTemp_theta_Plant(1);
end
maxPCATemp_theta_Plant = max(theta_Plant_pca(:, 1));
if length(maxPCATemp_theta_Plant) > 1
    maxPCATemp_theta_Plant = maxPCATemp_theta_Plant(1);
end
maxSignalTemp_theta_Plant = max(theta_Plant_signal(:, 1));
if length(maxSignalTemp_theta_Plant) > 1
    maxSignalTemp_theta_Plant = maxSignalTemp_theta_Plant(1);
end

% theta - Tool
maxPermuteTemp_theta_Tool = max(theta_Tool_permute(:, 1));
if length(maxPermuteTemp_theta_Tool) > 1
    maxPermuteTemp_theta_Tool = maxPermuteTemp_theta_Tool(1);
end
maxPCATemp_theta_Tool = max(theta_Tool_pca(:, 1));
if length(maxPCATemp_theta_Tool) > 1
    maxPCATemp_theta_Tool = maxPCATemp_theta_Tool(1);
end
maxSignalTemp_theta_Tool = max(theta_Tool_signal(:, 1));
if length(maxSignalTemp_theta_Tool) > 1
    maxSignalTemp_theta_Tool = maxSignalTemp_theta_Tool(1);
end

% theta Vehicle
maxPermuteTemp_theta_Vehicle = max(theta_Vehicle_permute(:, 1));
if length(maxPermuteTemp_theta_Vehicle) > 1
    maxPermuteTemp_theta_Vehicle = maxPermuteTemp_theta_Vehicle(1);
end
maxPCATemp_theta_Vehicle = max(theta_Vehicle_pca(:, 1));
if length(maxPCATemp_theta_Vehicle) > 1
    maxPCATemp_theta_Vehicle = maxPCATemp_theta_Vehicle(1);
end
maxSignalTemp_theta_Vehicle = max(theta_Vehicle_signal(:, 1));
if length(maxSignalTemp_theta_Vehicle) > 1
    maxSignalTemp_theta_Vehicle = maxSignalTemp_theta_Vehicle(1);
end

% lowGamma - Animal
maxPermuteTemp_lowGamma_Animal = max(lowGamma_Animal_permute(:, 1));
if length(maxPermuteTemp_lowGamma_Animal) > 1
    maxPermuteTemp_lowGamma_Animal = maxPermuteTemp_lowGamma_Animal(1);
end
maxPCATemp_lowGamma_Animal = max(lowGamma_Animal_pca(:, 1));
if length(maxPCATemp_lowGamma_Animal) > 1
    maxPCATemp_lowGamma_Animal = maxPCATemp_lowGamma_Animal(1);
end
maxSignalTemp_lowGamma_Animal = max(lowGamma_Animal_signal(:, 1));
if length(maxSignalTemp_lowGamma_Animal) > 1
    maxSignalTemp_lowGamma_Animal = maxSignalTemp_lowGamma_Animal(1);
end

% lowGamma - Building
maxPermuteTemp_lowGamma_Building = max(lowGamma_Building_permute(:, 1));
if length(maxPermuteTemp_lowGamma_Building) > 1
    maxPermuteTemp_lowGamma_Building = maxPermuteTemp_lowGamma_Building(1);
end
maxPCATemp_lowGamma_Building = max(lowGamma_Building_pca(:, 1));
if length(maxPCATemp_lowGamma_Building) > 1
    maxPCATemp_lowGamma_Building = maxPCATemp_lowGamma_Building(1);
end
maxSignalTemp_lowGamma_Building = max(lowGamma_Building_signal(:, 1));
if length(maxSignalTemp_lowGamma_Building) > 1
    maxSignalTemp_lowGamma_Building = maxSignalTemp_lowGamma_Building(1);
end

% lowGamma - Plant
maxPermuteTemp_lowGamma_Plant = max(lowGamma_Plant_permute(:, 1));
if length(maxPermuteTemp_lowGamma_Plant) > 1
    maxPermuteTemp_lowGamma_Plant = maxPermuteTemp_lowGamma_Plant(1);
end
maxPCATemp_lowGamma_Plant = max(lowGamma_Plant_pca(:, 1));
if length(maxPCATemp_lowGamma_Plant) > 1
    maxPCATemp_lowGamma_Plant = maxPCATemp_lowGamma_Plant(1);
end
maxSignalTemp_lowGamma_Plant = max(lowGamma_Plant_signal(:, 1));
if length(maxSignalTemp_lowGamma_Plant) > 1
    maxSignalTemp_lowGamma_Plant = maxSignalTemp_lowGamma_Plant(1);
end

% lowGamma - Tool
maxPermuteTemp_lowGamma_Tool = max(lowGamma_Tool_permute(:, 1));
if length(maxPermuteTemp_lowGamma_Tool) > 1
    maxPermuteTemp_lowGamma_Tool = maxPermuteTemp_lowGamma_Tool(1);
end
maxPCATemp_lowGamma_Tool = max(lowGamma_Tool_pca(:, 1));
if length(maxPCATemp_lowGamma_Tool) > 1
    maxPCATemp_lowGamma_Tool = maxPCATemp_lowGamma_Tool(1);
end
maxSignalTemp_lowGamma_Tool = max(lowGamma_Tool_signal(:, 1));
if length(maxSignalTemp_lowGamma_Tool) > 1
    maxSignalTemp_lowGamma_Tool = maxSignalTemp_lowGamma_Tool(1);
end

% lowGamma Vehicle
maxPermuteTemp_lowGamma_Vehicle = max(lowGamma_Vehicle_permute(:, 1));
if length(maxPermuteTemp_lowGamma_Vehicle) > 1
    maxPermuteTemp_lowGamma_Vehicle = maxPermuteTemp_lowGamma_Vehicle(1);
end
maxPCATemp_lowGamma_Vehicle = max(lowGamma_Vehicle_pca(:, 1));
if length(maxPCATemp_lowGamma_Vehicle) > 1
    maxPCATemp_lowGamma_Vehicle = maxPCATemp_lowGamma_Vehicle(1);
end
maxSignalTemp_lowGamma_Vehicle = max(lowGamma_Vehicle_signal(:, 1));
if length(maxSignalTemp_lowGamma_Vehicle) > 1
    maxSignalTemp_lowGamma_Vehicle = maxSignalTemp_lowGamma_Vehicle(1);
end

% highGamma - Animal
maxPermuteTemp_highGamma_Animal = max(highGamma_Animal_permute(:, 1));
if length(maxPermuteTemp_highGamma_Animal) > 1
    maxPermuteTemp_highGamma_Animal = maxPermuteTemp_highGamma_Animal(1);
end
maxPCATemp_highGamma_Animal = max(highGamma_Animal_pca(:, 1));
if length(maxPCATemp_highGamma_Animal) > 1
    maxPCATemp_highGamma_Animal = maxPCATemp_highGamma_Animal(1);
end
maxSignalTemp_highGamma_Animal = max(highGamma_Animal_signal(:, 1));
if length(maxSignalTemp_highGamma_Animal) > 1
    maxSignalTemp_highGamma_Animal = maxSignalTemp_highGamma_Animal(1);
end

% highGamma - Building
maxPermuteTemp_highGamma_Building = max(highGamma_Building_permute(:, 1));
if length(maxPermuteTemp_highGamma_Building) > 1
    maxPermuteTemp_highGamma_Building = maxPermuteTemp_highGamma_Building(1);
end
maxPCATemp_highGamma_Building = max(highGamma_Building_pca(:, 1));
if length(maxPCATemp_highGamma_Building) > 1
    maxPCATemp_highGamma_Building = maxPCATemp_highGamma_Building(1);
end
maxSignalTemp_highGamma_Building = max(highGamma_Building_signal(:, 1));
if length(maxSignalTemp_highGamma_Building) > 1
    maxSignalTemp_highGamma_Building = maxSignalTemp_highGamma_Building(1);
end

% highGamma - Plant
maxPermuteTemp_highGamma_Plant = max(highGamma_Plant_permute(:, 1));
if length(maxPermuteTemp_highGamma_Plant) > 1
    maxPermuteTemp_highGamma_Plant = maxPermuteTemp_highGamma_Plant(1);
end
maxPCATemp_highGamma_Plant = max(highGamma_Plant_pca(:, 1));
if length(maxPCATemp_highGamma_Plant) > 1
    maxPCATemp_highGamma_Plant = maxPCATemp_highGamma_Plant(1);
end
maxSignalTemp_highGamma_Plant = max(highGamma_Plant_signal(:, 1));
if length(maxSignalTemp_highGamma_Plant) > 1
    maxSignalTemp_highGamma_Plant = maxSignalTemp_highGamma_Plant(1);
end

% highGamma - Tool
maxPermuteTemp_highGamma_Tool = max(highGamma_Tool_permute(:, 1));
if length(maxPermuteTemp_highGamma_Tool) > 1
    maxPermuteTemp_highGamma_Tool = maxPermuteTemp_highGamma_Tool(1);
end
maxPCATemp_highGamma_Tool = max(highGamma_Tool_pca(:, 1));
if length(maxPCATemp_highGamma_Tool) > 1
    maxPCATemp_highGamma_Tool = maxPCATemp_highGamma_Tool(1);
end
maxSignalTemp_highGamma_Tool = max(highGamma_Tool_signal(:, 1));
if length(maxSignalTemp_highGamma_Tool) > 1
    maxSignalTemp_highGamma_Tool = maxSignalTemp_highGamma_Tool(1);
end

% highGamma Vehicle
maxPermuteTemp_highGamma_Vehicle = max(highGamma_Vehicle_permute(:, 1));
if length(maxPermuteTemp_highGamma_Vehicle) > 1
    maxPermuteTemp_highGamma_Vehicle = maxPermuteTemp_highGamma_Vehicle(1);
end
maxPCATemp_highGamma_Vehicle = max(highGamma_Vehicle_pca(:, 1));
if length(maxPCATemp_highGamma_Vehicle) > 1
    maxPCATemp_highGamma_Vehicle = maxPCATemp_highGamma_Vehicle(1);
end
maxSignalTemp_highGamma_Vehicle = max(highGamma_Vehicle_signal(:, 1));
if length(maxSignalTemp_highGamma_Vehicle) > 1
    maxSignalTemp_highGamma_Vehicle = maxSignalTemp_highGamma_Vehicle(1);
end

% Processing
barPermute_alpha = [maxPermuteTemp_alpha_Animal;maxPermuteTemp_alpha_Building;maxPermuteTemp_alpha_Plant;maxPermuteTemp_alpha_Tool;maxPermuteTemp_alpha_Vehicle];
barPCA_alpha = [maxPCATemp_alpha_Animal;maxPCATemp_alpha_Building;maxPCATemp_alpha_Plant;maxPCATemp_alpha_Tool;maxPCATemp_alpha_Vehicle];
barSignal_alpha = [maxSignalTemp_alpha_Animal;maxSignalTemp_alpha_Building;maxSignalTemp_alpha_Plant;maxSignalTemp_alpha_Tool;maxSignalTemp_alpha_Vehicle];

barPermute_beta = [maxPermuteTemp_beta_Animal;maxPermuteTemp_beta_Building;maxPermuteTemp_beta_Plant;maxPermuteTemp_beta_Tool;maxPermuteTemp_beta_Vehicle];
barPCA_beta = [maxPCATemp_beta_Animal;maxPCATemp_beta_Building;maxPCATemp_beta_Plant;maxPCATemp_beta_Tool;maxPCATemp_beta_Vehicle];
barSignal_beta = [maxSignalTemp_beta_Animal;maxSignalTemp_beta_Building;maxSignalTemp_beta_Plant;maxSignalTemp_beta_Tool;maxSignalTemp_beta_Vehicle];

barPermute_theta = [maxPermuteTemp_theta_Animal;maxPermuteTemp_theta_Building;maxPermuteTemp_theta_Plant;maxPermuteTemp_theta_Tool;maxPermuteTemp_theta_Vehicle];
barPCA_theta = [maxPCATemp_theta_Animal;maxPCATemp_theta_Building;maxPCATemp_theta_Plant;maxPCATemp_theta_Tool;maxPCATemp_theta_Vehicle];
barSignal_theta = [maxSignalTemp_theta_Animal;maxSignalTemp_theta_Building;maxSignalTemp_theta_Plant;maxSignalTemp_theta_Tool;maxSignalTemp_theta_Vehicle];

barPermute_lowGamma = [maxPermuteTemp_lowGamma_Animal;maxPermuteTemp_lowGamma_Building;maxPermuteTemp_lowGamma_Plant;maxPermuteTemp_lowGamma_Tool;maxPermuteTemp_lowGamma_Vehicle];
barPCA_lowGamma = [maxPCATemp_lowGamma_Animal;maxPCATemp_lowGamma_Building;maxPCATemp_lowGamma_Plant;maxPCATemp_lowGamma_Tool;maxPCATemp_lowGamma_Vehicle];
barSignal_lowGamma = [maxSignalTemp_lowGamma_Animal;maxSignalTemp_lowGamma_Building;maxSignalTemp_lowGamma_Plant;maxSignalTemp_lowGamma_Tool;maxSignalTemp_lowGamma_Vehicle];

barPermute_highGamma = [maxPermuteTemp_highGamma_Animal;maxPermuteTemp_highGamma_Building;maxPermuteTemp_highGamma_Plant;maxPermuteTemp_highGamma_Tool;maxPermuteTemp_highGamma_Vehicle];
barPCA_highGamma = [maxPCATemp_highGamma_Animal;maxPCATemp_highGamma_Building;maxPCATemp_highGamma_Plant;maxPCATemp_highGamma_Tool;maxPCATemp_highGamma_Vehicle];
barSignal_highGamma = [maxSignalTemp_highGamma_Animal;maxSignalTemp_highGamma_Building;maxSignalTemp_highGamma_Plant;maxSignalTemp_highGamma_Tool;maxSignalTemp_highGamma_Vehicle];

% Bar plot
figure()
subplot(5,1,1)
bar([barPermute_alpha,barPCA_alpha,barSignal_alpha], 'FaceColor', 'flat');
title('Bar Plot of LFP MD model - Alpha band');
legend('Permute Based', 'PCA Based', 'Signal Based');
subplot(5,1,2)
bar([barPermute_beta,barPCA_beta,barSignal_beta], 'FaceColor', 'flat');
title('Bar Plot of LFP MD model - Beta band');
subplot(5,1,3)
bar([barPermute_theta,barPCA_theta,barSignal_theta], 'FaceColor', 'flat');
title('Bar Plot of LFP MD model - Theta band');
subplot(5,1,4)
bar([barPermute_lowGamma,barPCA_lowGamma,barSignal_lowGamma], 'FaceColor', 'flat');
title('Bar Plot of LFP MD model - Low Gamma band');
subplot(5,1,5)
bar([barPermute_highGamma,barPCA_highGamma,barSignal_highGamma], 'FaceColor', 'flat');
title('Bar Plot of LFP MD model - High Gamma band');

