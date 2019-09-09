
%% Dashboard for LFP Memory Decoding
% Project: USC RAM
% Author: Garrett Flynn
% Date: July 26th, 2019

clear; clc; close all;

%% PATH
addpath(genpath('C:\Users\flynn\Documents\Github\LFP-Memory-Decoding'));

%% SETTINGS
dataChoices = {'ClipArt2'}; % ClipArt2 | Recording003 | Rat_Data | Other
    % Additional data filepaths can be specified in HHDataStructure.m
    % Many other parameters hardcoded in runPipeline.m
    
dataFormat = {'Spectrum','Signal','thetaSpectrum','alphaSpectrum','betaSpectrum','lowGammaSpectrum','highGammaSpectrum','thetaSignal','alphaSignal','betaSignal','lowGammaSignal','highGammaSignal'}; 

mlScope = {'MCA'}; 
% MCA | CA1 | CA3

mlAlgorithms = {'LassoGLM','naiveBayes','SVM'}; 
%| kMeans | LassoGLM | naiveBayes | SVM | linear | kernel | knn | tree | RUSBoost | CNN_SVM

saveHHData = 0;  
quickDebug = 0;

% Methods Parameters
reduceChannels = 1;
bspline = 1;
    BSOrder = 2;
    resChoice = 50:150;
    
bandAveragedPower = 1; % Currently only when bands are specified

% Data Processing Parameters
notchOn = 0;
downSample = []; %Samples/s (500 is ideal for our frequency range)
norm = 1;
tf_method = {'Hanning'};
tB = 100;
fB = .5;

if ~bspline
   resChoice = 1;
end

%% PIPELINE BEGINS HERE
for chosenData = 1:length(dataChoices)
for iter = 1:length(norm)
    windowOfInterest = 1; % Hardcoded for now
    centerEvent = 'SAMPLE_RESPONSE';
for range = windowOfInterest 
        
% Creates Core Data Structure
LFPMD_0_Structure

% Creates a New Matrix from HHData (with additional variables for ML)
LFPMD_1_Preprocess

% Iterates Through Selected Machine Learning Techniques
LFPMD_2_Model

% Visualize MD Modeling Results
LFPMD_3_Visualize

% Cleanup Before Next Data Choice
clear HHData
clear dataML
clear results
end
end

end