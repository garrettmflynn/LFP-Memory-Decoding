
clear; clc; close all;
%% What to Run?
% Note: Data filepaths can be specified in HHDataStructure.m


% Function Path
addpath(genpath('C:\SuperUser\Documents\GitHub\LFP-Memory-Decoding'));

% NPMK Path
addpath(genpath('E:\Useful MATLAB Scripts\NPMK'));

% Data Choices
dataChoices = {'ClipArt2'}; %{'Recording003','ClipArt2','Other'}
saveHHData = 0;

%% Data Format
dataFormat = {'alphaSpectrum','Signal'};
                                                                            %   Suffixes
                                                                            %         - Spectrum
                                                                            %         - Signal
                                                                            %   Prefixes (for spectrum only)
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

%% Run ML Pipeline
runPipeline;