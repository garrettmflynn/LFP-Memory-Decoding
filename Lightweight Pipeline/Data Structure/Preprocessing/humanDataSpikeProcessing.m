function [parameters] = humanDataSpikeProcessing(nexFileData,parameters)


% This file is used to extract data information from patients nex or nex5
% data can save them into mat file for Memory Decoding Project
% Written By Xiwei She - 02/08/2017
% Modified By Garrett Flynn - 06/14/19

% DIO_00001 SESSION_START
% DIO_00002 ITI_ON
% DIO_00004 FOCUS_ON
% DIO_00008 SAMPLE_ON
% DIO_00016 SAMPLE_RESPONSE
% DIO_00032 MATCH_ON
% DIO_00064 MATCH_RESPONSE
% DIO_00128 CORRECT_RESPONSE
% DIO_00256 END_SESSION

%% Extract Information - Change according to different patient
% For Events TimeStamps
for i = 1:length(nexFileData.events)
    if strcmp(nexFileData.events{i,1}.name, 'DIO_00002') || strcmp(nexFileData.events{i,1}.name, 'DIO_65533') % ITI_ON
        parameters.Times.ITI_ON = nexFileData.events{i,1}.timestamps;
    elseif strcmp(nexFileData.events{i,1}.name, 'DIO_00004') || strcmp(nexFileData.events{i,1}.name, 'DIO_65531') % FOCUS_ON
        parameters.Times.FOCUS_ON = nexFileData.events{i,1}.timestamps;
        parameters.Times.FOCUS_ON = [0; parameters.Times.FOCUS_ON(1:(end-1))]; % Shift and remove the last focus ring
    elseif strcmp(nexFileData.events{i,1}.name, 'DIO_00008') || strcmp(nexFileData.events{i,1}.name, 'DIO_65527') % SAMPLE_ON
       parameters.Times.SAMPLE_ON = nexFileData.events{i,1}.timestamps;
    elseif strcmp(nexFileData.events{i,1}.name, 'DIO_00016') || strcmp(nexFileData.events{i,1}.name, 'DIO_65519') % SAMPLE_RESPONSE
        parameters.Times.SAMPLE_RESPONSE = nexFileData.events{i,1}.timestamps;
    elseif strcmp(nexFileData.events{i,1}.name, 'DIO_00032') || strcmp(nexFileData.events{i,1}.name, 'DIO_65503') % MATCH_ON
        parameters.Times.MATCH_ON = nexFileData.events{i,1}.timestamps;
    elseif strcmp(nexFileData.events{i,1}.name, 'DIO_00064') || strcmp(nexFileData.events{i,1}.name, 'DIO_65471') % MATCH_RESPONSE
        parameters.Times.MATCH_RESPONSE = nexFileData.events{i,1}.timestamps;
    elseif strcmp(nexFileData.events{i,1}.name, 'DIO_00128') || strcmp(nexFileData.events{i,1}.name, 'DIO_65407') % END_SESSION
        parameters.Times.END_SESSION = nexFileData.events{i,1}.timestamps;
    elseif strcmp(nexFileData.events{i,1}.name, 'DIO_00256') || strcmp(nexFileData.events{i,1}.name, 'DIO_65279') % CORRECT_RESPONSE    
        parameters.Times.CORRECT_RESPONSE = nexFileData.events{i,1}.timestamps;
    elseif strcmp(nexFileData.events{i,1}.name, 'DIO_Changed') % DIO_Changed 
        parameters.Times.DIO_Changed = nexFileData.events{i,1}.timestamps;
    end
    
end

% For Neurons TimeStamps
if isfield(nexFileData,'neurons')
    
%     for jj = 1:length(nexFileData.neurons)
%     NameStr = nexFileData.neurons{jj,1}.name;
%     parameters.Neuron = nexFileData.neurons{jj,1};
    
else
for i = 1:length(nexFileData.events)
    NameStr = nexFileData.events{i,1}.name;
    if strcmp(NameStr(1:2), 'nr') && (NameStr(end) ~= '0') % Make sure those are REAL neurons
        channelNum = str2double(NameStr(4:6));
        if ismember(channelNum, parameters.Channels.CA1_Channels)
            parameters.Neuron.(['CA1_', NameStr]) = nexFileData.events{i,1}.timestamps;
        elseif ismember(channelNum, parameters.Channels.CA3_Channels)
            parameters.Neuron.(['CA3_', NameStr]) = nexFileData.events{i,1}.timestamps;
        end
    end
end
end
end