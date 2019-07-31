
%% Dashboard for LFP Memory Decoding
% Project: USC RAM
% Author: Garrett Flynn
% Date: July 26th, 2019

clear; clc; close all;

%% Function Path
addpath(genpath('C:\SuperUser\Documents\GitHub\LFP-Memory-Decoding'));

%% NPMK Path
addpath(genpath('E:\Useful MATLAB Scripts\NPMK'));

%% Core Choices
% Specifying multiple options will result in iteration over that parameter.

dataChoices = {'Rat_Data'}; % ClipArt2 | Recording003 | Rat_Data | Other
    % Additional data filepaths can be specified in loadFiles.m
    
dataFormat = {'Spectrum'};%,'thetaSpectrum','alphaSpectrum','betaSpectrum','lowGammaSpectrum','highGammaSpectrum'}; % [band]Signal/Spectrum 
    % Note: Spectrums AND Signals are Normalized to % Change (hardcoded in runPipeline.m)

featureMethod = {'PCA'}; % Raw | PCA

bspline = 1;
    BSOrder = 2;
    resChoice = 50:150;

mlScope = {'MCA'}; % MCA | CA1 | CA3

mlAlgorithms = {'kMeans','LassoGLM','naiveBayes','SVM'}; % | kMeans | LassoGLM | naiveBayes | 
% | SVM | linear | kernel | knn | tree | RUSBoost | CNN_SVM

saveHHData = 0;                                                                  


%% PIPELINE BEGINS HERE
% Run ML Pipeline
runPipeline;