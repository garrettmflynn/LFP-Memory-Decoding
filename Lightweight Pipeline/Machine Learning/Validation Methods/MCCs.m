function [MCC,MCC_Categories] = MCCs(hitMatrix,labels,nIntervals,k,excludeTrials)
% Determine Edgewise MCCs from Clustering Output


fields = fieldnames(labels);
MCC = NaN;

if nargin < 5
    excludeTrials = [];
end

%% Populate Matrices
tpMatrix = NaN(nIntervals,nIntervals);
fpMatrix = NaN(nIntervals,nIntervals);

for classi = 1:size(fields,1)
    for pairi = classi:size(fields,1)
        classLabels = (labels.(fields{classi})==1);
        classLabels(excludeTrials) = 0;
        pairLabels = (labels.(fields{pairi})==1);
        pairLabels(excludeTrials) = 0;
    fpMatrix(find(classLabels),find(pairLabels)) = 1;
    fpMatrix(find(pairLabels),find(classLabels)) = 1;
    end
tpMatrix(find(classLabels),find(classLabels)) = 1;
fpMatrix(find(classLabels),find(classLabels)) = NaN;
categoryMCCs.(fields{classi}).tP = tpMatrix;
categoryMCCs.(fields{classi}).fP = fpMatrix;
end

% Delete Match with Itself
totalIters = hitMatrix(1,1);

 for n = 1:nIntervals
 tpMatrix(n,n) = NaN;
 fpMatrix(n,n) = NaN;
 end

for iters = 1:size(hitMatrix,3)
tp = triu(hitMatrix(:,:,iters).*tpMatrix);
fp = triu(hitMatrix(:,:,iters).*fpMatrix);
fn = triu(totalIters-tp);
tn = triu(totalIters-fp);

 tpTotalCount = nansum(nansum(tp));
 fpTotalCount = nansum(nansum(fp));
 fnTotalCount = nansum(nansum(fn));
 tnTotalCount = nansum(nansum(tn));

%% Output
MCC(iters) = ((tpTotalCount*tnTotalCount)-(fpTotalCount*fnTotalCount))/sqrt((tpTotalCount+fpTotalCount)*(tpTotalCount+fnTotalCount)*(tnTotalCount+fpTotalCount)*(tnTotalCount+fnTotalCount));


%% Do MCC Individually for Each Iteration
for fi = 1:length(fields)
 tPMatrix = categoryMCCs.(fields{fi}).tP;
 fPMatrix = categoryMCCs.(fields{fi}).fP;
 
% Delete Match with Itself
totalIters = hitMatrix(1,1);

 for n = 1:nIntervals
 tPMatrix(n,n) = NaN;
 fPMatrix(n,n) = NaN;
 end

tP = triu(hitMatrix(:,:,iters).*tPMatrix);
fP= triu(hitMatrix(:,:,iters).*fPMatrix);
fN = triu(totalIters-tP);
tN = triu(totalIters-fP);

 tpTotalCount = nansum(nansum(tP));
 fpTotalCount = nansum(nansum(fP));
 fnTotalCount = nansum(nansum(fN));
 tnTotalCount = nansum(nansum(tN));
 
 denominator = sqrt((tpTotalCount+fpTotalCount)*(tpTotalCount+fnTotalCount)*(tnTotalCount+fpTotalCount)*(tnTotalCount+fnTotalCount));

 if denominator ~= 0
MCC_Categories(fi,iters) = ((tpTotalCount*tnTotalCount)-(fpTotalCount*fnTotalCount))/denominator;
 else
     MCC_Categories(fi,iters) = 0;
 end
end
end
end


%% Old Method of Validation
% prevalenceHits = (correctMatrix.*hitMatrix/hitMatrix(1,1));
% 
% rawCorrectPercentage = nanmean(nanmean(prevalenceHits));
% 
% chance = 1/k;
%  
% confidence = (rawCorrectPercentage-chance)/(1-chance);

