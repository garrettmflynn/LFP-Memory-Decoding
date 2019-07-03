function LFP = extractLFP(rawData, parameters)
% This file is used to extract LFP from raw NSx recordings
filterLP = parameters.Filters.lowPass;
filterNotch = parameters.Filters.notchFilter;

%% Extract LFP
% IF INE SESSION IN THE FILE
if (size(rawData,2) > 5)
    % Fill Arrays with Data
    toProcess = (double(rawData))';
    
    processedData = lowpass(toProcess,filterLP,2000);
    % Added Notch Filter to get rid of line noise
    LFP = filtfilt(filterNotch,processedData);
    
% IF MANY SESSIONS IN THE FILE
elseif ~(size(rawData,2) > 5)
    % Process initial session
    toProcess = (double(rawData))';
    processedData = lowpass(toProcess,filterLP,2000);
    LFP = filtfilt(filterNotch, processedData);
    
    % Process subsequent sessions & append to initial array
    for i = 2:size(rawData,2)
        tempData = double(rawData{1,i})';
        tempData = lowpass(tempData,filterLP,2000);
        tempData = filtfilt(filterNotch,tempData);
        LFP = [LFP; tempData];
    end    
end

LFP = LFP';
end
