function [finalresults] = processAllClassesToResults(results,firstField)

typeFields = fieldnames(results.(firstField));
labelFields = fieldnames(results.(firstField).(typeFields{1}));
numLabels = length(labelFields);
numTypes = length(typeFields);

for jj = 1:numTypes
for ii = 1:numLabels
if typeFields{jj} == 'SCA'
multiClassVector(ii,:) = results.(firstField).(typeFields{jj}).(labelFields{ii});
else
multiClassVector(ii) = results.(firstField).(typeFields{jj}).(labelFields{ii});
end
end
meanForAll = nanmean(multiClassVector);
nans = isnan(multiClassVector);
if sum(sum(nans)) > 1
numNans = sum(nans);
finalresults.(firstField).(typeFields{jj}).AllClasses{2} = ['numNans = ' num2str(numNans)];
end
finalresults.(firstField).(typeFields{jj}).AllClasses{1} = meanForAll;
end
end