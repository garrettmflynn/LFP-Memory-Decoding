function [F1,MCC] = correctnessIndex(hitMatrix,nIntervals,k)
% Output = Correctness Beyond Chance

Animals = [3,4,8];
Plants = [1,6,14];
Buildings = [5,9,12];

classMatrix = {Animals Plants Buildings};

%% Populate Matrices
tpMatrix = NaN(nIntervals,nIntervals);
fpMatrix = NaN(nIntervals,nIntervals);

for classi = 1:size(classMatrix,2)
    for pairi = classi:size(classMatrix,2)
    fpMatrix(classMatrix{classi},classMatrix{pairi}) = 1;
    fpMatrix(classMatrix{pairi},classMatrix{classi}) = 1;
    end
tpMatrix(classMatrix{classi},classMatrix{classi}) = 1;
fpMatrix(classMatrix{classi},classMatrix{classi}) = NaN;
end

% Delete Match with Itself
totalIters = hitMatrix(1,1);

 for n = 1:nIntervals
 tpMatrix(n,n) = NaN;
 fpMatrix(n,n) = NaN;
 end

tp = hitMatrix.*tpMatrix;
fp = hitMatrix.*fpMatrix;
fn = totalIters-tp;
tn = totalIters-fp;

% tpPlaceCount = sum(sum(tpMatrix);
% fpPlaceCount = sum(sum(fpMatrix);
% fnPlaceCount = sum(sum(fn > 1));
% tnPlaceCount = sum(sum(tn > 1));
 tpTotalCount = nansum(nansum(tp));
 fpTotalCount = nansum(nansum(fp));
 fnTotalCount = nansum(nansum(fn));
 tnTotalCount = nansum(nansum(tn));

% Recall = TP/(TP+FN)
recall = tpTotalCount./(tpTotalCount+fnTotalCount);

% Precision = TP/(TP+FP)
precision = tpTotalCount./(tpTotalCount+fpTotalCount);


%% Output
F1 = 2*((precision.*recall)./(precision+recall));


MCC = ((tpTotalCount*tnTotalCount)-(fpTotalCount*fnTotalCount))/sqrt((tpTotalCount+fpTotalCount)*(tpTotalCount+fnTotalCount)*(tnTotalCount+fpTotalCount)*(tnTotalCount+fnTotalCount));
end



%% Old Method of Validation
% prevalenceHits = (correctMatrix.*hitMatrix/hitMatrix(1,1));
% 
% rawCorrectPercentage = nanmean(nanmean(prevalenceHits));
% 
% chance = 1/k;
%  
% confidence = (rawCorrectPercentage-chance)/(1-chance);

