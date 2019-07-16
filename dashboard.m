
clear; clc; close all;
%% What to Run?
% Function Path
addpath(genpath('C:\SuperUser\Documents\GitHub\LFP-Memory-Decoding'));

% Data Choices
data003 = 0;
ClipArt2 = 1;
other = 0;

% Data Structure Choices
norm = 1;%[0 1]; % Carries over to ML, if chosen // A vector of two values results in two iterations
saveHHData = 1;

% ML Choices
saveMLInputs = 1;
Raw = 1;
PCA = 1;

%% ML Pipeline
for iter = 1:length(norm)
HHDataStructure;
prepareForML;
iterateThroughML;
end