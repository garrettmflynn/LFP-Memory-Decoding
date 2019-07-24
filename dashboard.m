
clear; clc; close all;
%% What to Run?
% Note: Data filepaths can be specified in HHDataStructure.m


% Function Path
addpath(genpath('C:\SuperUser\Documents\GitHub\LFP-Memory-Decoding'));

% NPMK Path
addpath(genpath('E:\Useful MATLAB Scripts\NPMK'));

% Data Choices
data003 = 0;
ClipArt2 = 1;
other = 0;

% Data Structure Choices
norm = 1; % Carries over to ML, if chosen // A vector of two values results in two iterations
windowOfInterest = 1;  % Seconds before and after SAMPLE_RESPONSE
saveHHData = 0;

%% ML Choices
Raw = 1;
PCA = 1;
    normBetweenOneAndZero = 0;
bspline = 1;

% Methods
MCA = 1;
CA1 = 0;
CA3 = 0;
    
    % Unsupervised
    Kmeans = 0;

    % Supervised
    allBasicClassifiers = 1;
        lassoGLM = 1;
        linear = 1; % Currently set to lasso
        kernel = 0;
        knn = 0;
        naivebayes = 1;
        svm = 1;
         tree = 0;
         RUSBoost = 0; % Specializes in unbalanced classes, but does not perform well

    % Image Based
    CNN_SVM = 0;
        mlChoice = [1 3 4]; % 1 = MCA
                            % 2 = SCA
                            % 3 = CA1
                            % 4 = CA3

%% ML Pipeline
dataChoices = [data003,ClipArt2,other];
learnerTypes = [lassoGLM linear kernel knn naivebayes svm tree RUSBoost];

for dataChoice = 1:length(dataChoices)

for iter = 1:length(norm)
for range = windowOfInterest
HHDataStructure;
iterateThroughML;
clear HHData
clear dataML
clear results
end
end

end