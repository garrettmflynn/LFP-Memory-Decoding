
%% Dashboard
% Dashboard.m allows Memory Decoders to easily specify +
% iterate through many parameters.


                                                                            % Project: USC RAM
                                                                            % Author: Garrett Flynn
                                                                            % Date: July 26th, 2019

clear; clc; close all;

%% Function Path
addpath(genpath('C:\SuperUser\Documents\GitHub\LFP-Memory-Decoding'));

%% NPMK Path
addpath(genpath('E:\Useful MATLAB Scripts\NPMK'));

%% Patient Choices
dataChoices = {'ClipArt2'}; %{'Recording003','ClipArt2','Other'}
% Note: Data filepaths can be specified in HHDataStructure.m
                                                                            %   Current Choices
                                                                            %         - ClipArt2
                                                                            %         - Recording003
                                                                            %         - Other

%% Data Format
dataFormat = {'alphaSpectrum','Signal'};
saveHHData = 0;
                                                                            %   (1) Signal, or (2) Spectrum
                                                                            
                                                                            %   Additional Prefixes (for spectrum only)
                                                                            %         - theta
                                                                            %         - alpha
                                                                            %         - beta
                                                                            %         - lowGamma
                                                                            %         - highGamma


%% Feature Methods
featureMethod = {'Raw'};
bspline = 1;
    BSOrder = 2;
    resChoice = 50:150;
norm = 1; % Carries over to ML, if chosen // A vector of two values results in two iterations
windowOfInterest = 1;  % Seconds before and after SAMPLE_RESPONSE

%% ML Scope
mlScope = {'MCA'};
                                                                            % Choices: MCA, CA1, and CA3

%% ML Algorithms
mlAlgorithms = {'lassoGLM','kMeans'};
                                                                            % Unsupervised 
                                                                            %   - kMeans
                                                                            % Supervised
                                                                            %   - lassoGLM
                                                                            %   - naiveBayes
                                                                            %   - SVM
                                                                            %   - linear
                                                                            %   - kernel
                                                                            %   - knn
                                                                            %   - tree
                                                                            %   - RUSBoost
                                                                            % Image Based
                                                                            %   - CNN_SVM

%% PIPELINE BEGINS HERE
% Run ML Pipeline
runPipeline;