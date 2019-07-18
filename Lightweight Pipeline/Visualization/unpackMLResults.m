function [] = unpackMLResults(results,labels,filePath)


labelFields = fieldnames(results.(firstField));
typeFields = fieldnames(results.(firstField).(labelFields{1}));
numLabels = length(labelFields);
numTypes = length(typeFields);

for jj = 1:numTypes
for ii = 1:numLabels
if typeFields{jj} == 'SCA'
multiClassVector(ii,:) = results.(firstField).(labelFields{ii}).(typeFields{jj});
else
multiClassVector(ii) = results.(firstField).(labelFields{ii}).(typeFields{jj});
end
end
meanForAll = nanmean(multiClassVector);
nans = isnan(multiClassVector);
if sum(sum(nans)) > 1
numNans = sum(nans);
results.(firstField).AllClasses.(typeFields{jj}){2} = ['numNans = ' num2str(numNans)];
end
results.(firstField).AllClasses.(typeFields{jj}){1} = meanForAll;
end


supMCC = meanForAll;

  saveSupMCC = fullfile(filePath,'MCC Bar Plots','Supervised',typeFields{jj})
            
makeMCCBars(supMCC,supMCC_Categories,labels,0,typeFields{jj},norm(iter),saveSupMCC)
end