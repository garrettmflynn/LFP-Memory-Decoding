
%% Run Pipeline
% This script begins the Memory Decoding Pipeline after initialization
% using dashboard.m

                                                                            % Project: USC RAM
                                                                            % Author: Garrett Flynn
                                                                            % Date: July 26th, 2019

                                                                            
%% Hardcoded Iterators                                                                            
norm = 1;
if ~bspline
   resChoice = 1;
end
tf_method = {'Hanning'};
tB = 100;
fB = .5;


for chosenData = 1:length(dataChoices)
for iter = 1:length(norm)
    windowOfInterest = 1; % Hardcoded for now
    centerEvent = 'SAMPLE_RESPONSE';
for range = windowOfInterest 
    
%% Core Scripts to Execute    
% Creates Core Data Structure
HHDataStructure

% Creates a New Matrix from HHData (with additional variables for ML)
prepareForML

% Iterates Through Selected Machine Learning Techniques
iterateThroughML


% Visualize MD Modeling Results
processingLFPMDModelingResults


% Cleanup Before Next Data Choice
clear HHData
clear dataML
clear results
end
end

end