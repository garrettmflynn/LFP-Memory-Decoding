
clear; clc; close all;
%% What to Run?
% Function Path
addpath(genpath('C:\SuperUser\Documents\GitHub\LFP-Memory-Decoding'));

% NPMK Path
addpath(genpath('E:\Useful MATLAB Scripts\NPMK'));

% Data Choices
data003 = 1;
ClipArt2 = 1;
other = 0;

% Data Structure Choices
norm = [0 1]; % Carries over to ML, if chosen // A vector of two values results in two iterations
saveHHData = 0;

% ML Choices
    Raw = 1;
    PCA = 1;
    
% Unsupervised
Kmeans = 1;

% Supervised
allBasicClassifiers = 1;
 linear = 1; % Currently set to lasso
 kernel = 1;
 knn = 1;
 naivebayes = 1;
 svm = 1;
 tree = 1;

    
CNN_SVM = 0;
    mlChoice = [1 3 4]; % 1 = MCA
                     % 2 = SCA
                     % 3 = CA1
                     % 4 = CA3

%% ML Pipeline
dataChoices = [data003,ClipArt2,other];
learnerTypes = [linear kernel knn naivebayes svm tree];

for dataChoice = 1:length(dataChoices)

for iter = 1:length(norm)
HHDataStructure;
iterateThroughML;
%unpackMLResults(results,HHData.Labels,parameters.Directories.filePath); % Need to work on this
clear HHData
clear dataML
clear results
end

end