
saveImages = fullfile(parameters.Directories.filePath,'Images');

%% Save Labels
fields = fieldnames(dataML.Labels);
fieldLabels = erase(fields,'Label_');
labels = cell(size(dataML.Labels.(fields{1}),1),1);
numTrials = size(dataML.Labels.(fields{1}),1);
labelMaker();

%% SPLIT ALL TESTING UP TO BINARY CLASSIFICATION TASKS
% We could treat all pairings as their own class, but this results in very
% few instances of certain classes...

for categoriesToTrain = 1:length(fields)
    labelCache = cell(numTrials,1);
    currentCategory = dataML.Labels.(fields{categoriesToTrain});
    currentField = fieldLabels{categoriesToTrain};
    for qq = 1:numTrials;
    if strfind(labels{qq},currentField)
        labelCache{qq} = currentField;
    else
        labelCache{qq} = ['Not ' currentField];
    end
    end
    
labelCache = categorical(labelCache);

%% Go Through ALL CHANNELS or SPECIFIC CHANNELS
channelLabels = dataML.Channels.sChannels;
fprintf(['Beginning ', currentField, ' Classification\n\n']);
for MCA_or_SCA = mlChoice
    if MCA_or_SCA == 1
        fprintf('\tSaving Images for All Channels\n');
saveImageX = fullfile(saveImages,['All Channels']);
    elseif MCA_or_SCA == 2
      saveImageX = fullfile(saveImages,['Channel',num2str(channelLabels(end))]); % Make sure to run if last channel directory does not exist
    elseif MCA_or_SCA == 3
 fprintf('\tSaving Images for CA1\n');
      saveImageX = fullfile(saveImages,'CA1');
    elseif MCA_or_SCA == 4
fprintf('\tSaving Images for CA3\n');
      saveImageX = fullfile(saveImages,'CA3');
    end
    
if ~exist(saveImageX,'dir');
%% Save Images
    if MCA_or_SCA == 1 || MCA_or_SCA == 2
    numChannels = 1:size(dataML.Data,3);
elseif MCA_or_SCA == 3
numChannels = dataML.Channels.CA1_Channels;
elseif MCA_or_SCA == 4
numChannels = dataML.Channels.CA3_Channels;
end
    for channels = numChannels
       if MCA_or_SCA == 2
      fprintf(['\tSaving Images for Channel_',num2str(channels), '\n']);
      saveImageX = fullfile(saveImages,['Channel',num2str(channelLabels(channels))]);  
       end
        if ~exist(saveImageX,'dir');
            mkdir(saveImageX);
        end
        for ii = 1:size(dataML.Data,4)
            data  = squeeze(dataML.Data(:,:,channels,ii));
                        imwrite(im2uint8(mat2gray(data)), fullfile(saveImageX,['ImageC',num2str(channelLabels(channels)),'_',num2str(ii),'.jpg']));
        end
%        imds = imageDatastore(saveImageX);
%            imds.Files = natsortfiles(imds.Files);
%        imds.Labels  = repmat(labelCache,numChannels,1);
    end

%% Choose Correct Save Field
% Within Directory Creation Loop
if MCA_or_SCA == 1
  results.CNN_SVM.MCA.(currentField) = initiateCNN_SVM(dataML,labelCache, MCA_or_SCA,saveImages);
elseif MCA_or_SCA == 2
 results.CNN_SVM.SCA.(currentField) = initiateCNN_SVM(dataML,labelCache, MCA_or_SCA,saveImages);
elseif MCA_or_SCA == 3
 results.CNN_SVM.CA1.(currentField) = initiateCNN_SVM(dataML,labelCache, MCA_or_SCA,saveImages);
elseif MCA_or_SCA == 4
 results.CNN_SVM.CA3.(currentField) = initiateCNN_SVM(dataML,labelCache, MCA_or_SCA,saveImages);
end

% If Directories Already Exist
else
if MCA_or_SCA == 1
  results.CNN_SVM.MCA.(currentField) = initiateCNN_SVM(dataML,labelCache, MCA_or_SCA,saveImages);
elseif MCA_or_SCA == 2
 results.CNN_SVM.SCA.(currentField) = initiateCNN_SVM(dataML,labelCache, MCA_or_SCA,saveImages);
elseif MCA_or_SCA == 3
 results.CNN_SVM.CA1.(currentField) = initiateCNN_SVM(dataML,labelCache, MCA_or_SCA,saveImages);
elseif MCA_or_SCA == 4
 results.CNN_SVM.CA3.(currentField) = initiateCNN_SVM(dataML,labelCache, MCA_or_SCA,saveImages);
end
end
end
end

