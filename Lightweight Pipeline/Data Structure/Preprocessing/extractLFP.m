function LFP = extractLFP(rawData, parameters)
% This file is used to extract LFP from raw NSx recordings

filterLP = parameters.Filters.lowPass;
filterNotch = parameters.Filters.notchFilter;

%% Extract LFP
% IF ONE SESSION IN THE FILE
if (size(rawData,2) > 5)
    % Fill Arrays with Data
    toProcess = (double(rawData))';
    clear rawData
    
    processedData = lowpass(toProcess,filterLP,2000);
        clear toProcess
    for ii = 1:size(processedData,2)
    % Added Notch Filter to get rid of line noise
    LFP(:,ii) = filtfilt(filterNotch,processedData(:,ii));
    end
    
% IF MANY SESSIONS IN THE FILE
elseif ~(size(rawData,2) > 5)
    % Process initial session
    toProcess = (double(rawData))';
    rawData{1,1} = [];
    processedData = lowpass(toProcess,filterLP,2000);
    clear toProcess
        for ii = 1:size(processedData,2)
    LFP(:,ii) = filtfilt(filterNotch,processedData(:,ii));
    end
    
    % Process subsequent sessions & append to initial array
    for i = 2:size(rawData,2)
        tempData = double(rawData{1,i})';
        rawData{1,i} = [];
        tempData = lowpass(tempData,filterLP,2000);
            for ii = 1:size(processedData,2)
    tempDataEnd(:,ii) = filtfilt(filterNotch,tempData(:,ii));
            end
        LFP = [LFP; tempDataEnd];
    end    
end

LFP = LFP';
end



%% Failed Partitioning Scheme
% filterLP = parameters.Filters.lowPass;
% filterNotch = parameters.Filters.notchFilter;
% 
% %% Extract LFP
% % IF INE SESSION IN THE FILE
% if (size(rawData,2) > 5)
%     s = size(rawData,2);
% if (s/2044934) > 1
%     partitions = ceil((s/2044934)/10)*10;
%     partSize = floor(s/partitions);
%     partStart = 1;
% else 
% partitions = 1;
%   partSize = floor(s/partitions);
% partStart = 1;
%  end
% 
%     % Fill Arrays with Data
%     toProcess = (double(rawData))';
%     clear rawData
%     processedData = lowpass(toProcess,filterLP,2000);
%     clear toProcess
%     
%     LFP = [];
%     for ii = 1:partitions
%         if ii == partitions
%         partEnd = s;
%         else
%             partEnd = partSize * ii;
%         end
%     partitionData = processedData(partStart:partEnd,:);
%     % Added Notch Filter to get rid of line noise
%     LFP = [LFP;filtfilt(filterNotch,partitionData)];
%     partStart = partEnd + 1;
%     end
%     
% % IF MANY SESSIONS IN THE FILE
% elseif ~(size(rawData,2) > 5)
%     partitions = ceil(s/2044934);
%     partSize = s/partitions;
% 
%     % Process initial session
%     toProcess = (double(rawData{1,1}))';
%     rawData{1,1} = [];
%     processedData = lowpass(toProcess,filterLP,2000);
%     clear toProcess
%     for ii = 1:partitions
%             if ii == partitions
%         partEnd = s;
%         else
%             partEnd = partSize * ii;
%         end
%     partitionData = processedData(partStart:partEnd,:);
%      LFP = [LFP;filtfilt(filterNotch,partitionData)];
%     partStart = partEnd + 1;
%     end
%      clear processedData
%     
%     % Process subsequent sessions & append to initial array
%     for i = 2:size(rawData,2)
%         partitions = ceil(s/2044934);
%         partSize = s/partitions;
%         tempData = double(rawData{1,i})';
%         rawData{1,i} = [];
%         tempData = lowpass(tempData,filterLP,2000);
%         for ii = 1:partitions
%                 if ii == partitions
%         partEnd = s;
%         else
%             partEnd = partSize * ii;
%         end
%         partitionData = processedData(partStart:partEnd,:);
%         LFP = [LFP; filtfilt(filterNotch,partitionData)];
%         partStart = partEnd + 1;
%         end
%     end    
% end
% 
% LFP = LFP';
% end
