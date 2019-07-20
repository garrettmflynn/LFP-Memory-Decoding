
clear; clc; close all;
%% What to Run?
% Function Path
addpath(genpath('C:\SuperUser\Documents\GitHub\LFP-Memory-Decoding'));

% NPMK Path
addpath(genpath('E:\Useful MATLAB Scripts\NPMK'));

% Data Choices
data003 = 0;
ClipArt2 = 1;
other = 0;

% Data Structure Choices
norm = [0 1]; % Carries over to ML, if chosen // A vector of two values results in two iterations
windowOfInterest = 1; % Second before and after SAMPLE_RESPONSE
saveHHData = 0;

%% ML Choices
Raw = 1;
PCA = 1;
    
    % Unsupervised
    Kmeans = 0;

    % Supervised
    allBasicClassifiers = 1;
        linear = 0; % Currently set to lasso
        kernel = 0;
        knn = 0;
        naivebayes = 0;
        svm = 0;
         tree = 0;
         RUSBoost = 1; % Specializes in unbalanced classes

    % Image Based
    CNN_SVM = 0;
        mlChoice = [1 3 4]; % 1 = MCA
                            % 2 = SCA
                            % 3 = CA1
                            % 4 = CA3

%% ML Pipeline
dataChoices = [data003,ClipArt2,other];
learnerTypes = [linear kernel knn naivebayes svm tree RUSBoost];

for dataChoice = 1:length(dataChoices)

for iter = 1:length(norm)
for range = [1,3,5]
HHDataStructure;
iterateThroughML;
clear HHData
clear dataML
clear results
end
end

end