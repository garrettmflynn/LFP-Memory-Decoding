
%% Run Pipeline
% This script begins the Memory Decoding Pipeline after initialization
% using dashboard.m

                                                                            % Project: USC RAM
                                                                            % Author: Garrett Flynn
                                                                            % Date: July 26th, 2019

for chosenData = 1:length(dataChoices)
for iter = 1:length(norm)
for range = windowOfInterest
    
% Creates Core Data Structure
HHDataStructure

% Creates a New Matrix from HHData (with additional variables for ML)
prepareForML

% Iterates Through Selected Machine Learning Techniques
iterateThroughML

% Cleanup Before Next Data Choice
clear HHData
clear dataML
clear results
end
end

end