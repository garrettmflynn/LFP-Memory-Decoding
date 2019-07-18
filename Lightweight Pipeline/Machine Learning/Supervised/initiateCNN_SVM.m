function [results] = initiateCNN_SVM(dataML,labels,MCA_or_SCA,saveImages)

channelLabels  = dataML.Channels.sChannels;

% Determine Channel Method to Use
if MCA_or_SCA == 1
    fprintf(['\tApplying ML to All Channels\n']);
    saveImageX = fullfile(saveImages,['All Channels']);
    numChannels = 1;
    if isfield('dataML','ML')
    replicate = size(dataML.ML.Data,3);
    else
        replicate = size(dataML.Data,3);
    end
elseif MCA_or_SCA == 2
    if isfield('dataML','ML')
    numChannels = 1:size(dataML.ML.Data,3);
    else
        numChannels = 1:size(dataML.Data,3);
    end
    replicate = 1;
elseif MCA_or_SCA == 3
    numChannels = dataML.Channels.CA1_Channels;
    replicate = length(dataML.Channels.CA1_Channels);
elseif MCA_or_SCA == 4
   numChannels = dataML.Channels.CA3_Channels;
    replicate = length(dataML.Channels.CA3_Channels);
end

% Individual or Total Channel 
if MCA_or_SCA == 1 || MCA_or_SCA == 2
for channels = numChannels
    if MCA_or_SCA == 2
        fprintf(['\tApplying ML to Channel_',num2str(channelLabels(channels)), '\n']);
        saveImageX = fullfile(saveImages,['Channel',num2str(channelLabels(channels))]);
    end
    imds = imageDatastore(saveImageX);
    imds.Files = natsortfiles(imds.Files);
    imds.Labels  = repmat(labels,replicate,1);
    
    if MCA_or_SCA == 1
    [MCC_MCA STD] = CNN_SVM(imds);
    else
    [MCC_SCA(channels) STD(channels)] = CNN_SVM(imds);
    end
end

elseif MCA_or_SCA == 3 || MCA_or_SCA == 4
saveImageX = cell(1,length(numChannels));
channelCount = 1;
for channels = find(ismember(channelLabels,numChannels))
if ~isempty(saveImageX)
saveImageX{channelCount} = fullfile(saveImages,['Channel',num2str(channelLabels(channels))]);
end
channelCount = channelCount + 1;
end
    imds = imageDatastore(saveImageX);
    imds.Files = natsortfiles(imds.Files);
    imds.Labels  = repmat(labels,replicate,1);
    
    if MCA_or_SCA == 3
     fprintf(['\tApplying ML to CA1\n']);   
    [MCC_CA1 STD] = CNN_SVM(imds);
    elseif MCA_or_SCA == 4
        fprintf(['\tApplying ML to CA3\n']);   
    [MCC_CA3 STD] = CNN_SVM(imds);
    end
end

if MCA_or_SCA == 1
results = MCC_MCA;
elseif MCA_or_SCA == 2
results = MCC_SCA;
elseif MCA_or_SCA == 3
results = MCC_CA1;
elseif MCA_or_SCA == 4
results = MCC_CA3;
end
end