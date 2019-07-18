
if ~exist('HHData','var') && ~exist('dataML','var')
load("E:\LFP\ClipArt_2\ClipArt_2HHDataNorm.mat");
end
saveImages = 'E:\LFP\ClipArt_2\Images';
isML = 0;

if exist('dataML','var')
    HHData = dataML;
    clear dataML
    isML = 1;
end

%% Save Labels
fields = fieldnames(HHData.Labels);
fieldLabels = erase(fields,'Label_');
labels = cell(size(HHData.Labels.(fields{1}),1),1);
for jj = 1:length(fields)
    currentField = HHData.Labels.(fields{jj});
    for qq = 1:size(currentField,1)
        if currentField(qq) == 1
            if ~isempty(labels{qq})
                labels{qq} = [labels{qq}, '_',fieldLabels{jj}] ;
            else
                labels{qq} = fieldLabels{jj};
            end
        end    
    end
end

for qq = 1:size(currentField,1)
if isempty(labels{qq});
    zero = qq;
    labels{zero} = 'None';
end
end

labels = categorical(labels);

for iter = 1:2
    if iter == 1
saveImageX = fullfile(saveImages,['All Channels']);
    else
      saveImageX = fullfile(saveImages,['Channel1']);
    end
if ~exist(saveImageX);
%% Save Images
channelLabels = HHData.Channels.sChannels;
if isML
    numChannels = size(HHData.ML.Data,3);
    for channels = 1:numChannels
       if iter == 2
      saveImageX = fullfile(saveImages,['Channel' num2str(channels)]);  
       end
        if ~exist(saveImageX,'dir');
            mkdir(saveImageX);
        end
        for ii = 1:size(HHData.Data,4)
            data  = squeeze(HHData.ML.Data(:,:,channels,ii));
                        imwrite(im2uint8(mat2gray(data)), fullfile(saveImageX,['ImageC',num2str(channelLabels(channels)),'_',num2str(ii),'.jpg']));
        end
        imds{channels} = imageDatastore(saveImageX);
        imds{channels}.Labels  = labels;
    end
else
    numChannels = size(HHData.ML.Data,3);
    for channels = 1:numChannels
        if ~exist(saveImageX,'dir');
            mkdir(saveImageX);
        end
        for ii = 1:size(HHData.ML.Data,4)
            data  = squeeze(HHData.ML.Data(:,:,channels,ii));
            imwrite(im2uint8(mat2gray(data)), fullfile(saveImageX,['ImageC',num2str(channelLabels(channels)),'_',num2str(ii),'.jpg']));
        end
    end
       imds = imageDatastore(saveImageX);
           imds.Files = natsortfiles(imds.Files);
       imds.Labels  = repmat(labels,numChannels,1);
end

save(fullfile(saveImages,'imds'),'imds');
else
    if iter == 1
saveImageX = fullfile(saveImages,['All Channels']);
numChannels = 1;
    end
    for channels = 1:numChannels
       if iter == 2
      saveImageX = fullfile(saveImages,['Channel' num2str(channels)]);  
       end
     numChan = size(HHData.ML.Data,3);
     imds = imageDatastore(saveImageX);
     imds.Files = natsortfiles(imds.Files);
     imds.Labels  = repmat(labels,numChan,1);
     
     CNN_SVM(imds)
    end
end
end

