%% This script is written for building data structures for recorded Human Hippocampal neural signals.
% Project: USC RAM
% Author: Xiwei She and Garrett Flynn
% Date: 2019 June 14
clear;clc

%% Variables may need to be modified by user (in loadParameters.m)
parameters = loadParameters();

%% Load Data
% Neural Data collected from BlackRock Microsystem
neuralData = extractNSx(parameters.Directories.filePath,parameters.Directories.dataName); % Fixed for all .nsX files

% Spike and Experimental Behavioral Data collectred from DMS memory task
nexFileData = readNexFile([parameters.Directories.filePath, '\', parameters.Directories.dataName, '.nex']);

%% Choose Appropriate Pipeline
if size(neuralData.Data,1) == 1
    %  Update Parameters with Sampling Frequency & Session Length
    parameters = loadParameters(parameters,neuralData.MetaTags.SamplingFreq,size(neuralData.Data{1,1},2));
    for session = 1:size(neuralData.Data,2)
        [HHData] = singlePipeline(neuralData,nexFileData,parameters,session);
        fprintf(['Session' , num2str(session), 'Created\n']);
        fprintf(['\tNow Visualizing Session at ' ,parameters.Directories.filePath, '\Visualizations\Session',num2str(session)]);
        visualizationSuite(HHData,[parameters.Directories.filePath, '\Visualizations\Session',num2str(session)]);
        
        HHDataMultiple.([session,num2str(session)]) = HHData;
        clear HHData
    end
    
else
    
    
    if ~parameters.Optional.VizLoop
        %  Update Parameters with Sampling Frequency & Session Length
        parameters = loadParameters(parameters,neuralData.MetaTags.SamplingFreq,size(neuralData.Data,2));
        
        [HHData] = singlePipeline(neuralData,nexFileData,parameters);
        
        fprintf('Now Visualizing All Specified Channels\n');
        
        visualizationSuite(HHData,[parameters.Directories.filePath, '\VisualizationsShanechiHamming']); % Actually Taylor
        
        
        %% Only For Visualization Loop Where Windowing is Experimented With
    else
        parameters = loadParameters(parameters,neuralData.MetaTags.SamplingFreq,size(neuralData.Data,2));
        for ii = [1.5 2:4:18]
            for kk = 1/16:3/16:1
                for qq = 1:5
                    
                    
                    parameters.Choices.freqBin = qq;
                    parameters.Choices.timeBin = kk;
                    parameters.Derived.overlap = round((parameters.Choices.timeBin * parameters.Derived.samplingFreq)/ii);
                    parameters.Optional.iteration = [];
                    vizLoop(neuralData,nexFileData,parameters);
                    close all;
                    for jj = 1:length(parameters.Optional.methods)
                        parameters.Optional.iteration = jj;
                        
                        vizLoop(neuralData,nexFileData,parameters);
                    end
                    
                end
            end
        end
    end
    
end
