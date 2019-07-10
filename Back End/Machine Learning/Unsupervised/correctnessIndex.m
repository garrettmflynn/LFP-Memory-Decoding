function [F1,MCC,A] = correctnessIndex(hitMatrix,labels,nIntervals,k)
% Output = Correctness Beyond Chance


fields = fieldnames(labels);
MCC = NaN;
F1 = NaN;
%% Populate Matrices
tpMatrix = NaN(nIntervals,nIntervals);
fpMatrix = NaN(nIntervals,nIntervals);

for classi = 1:size(fields,1)
    for pairi = classi:size(fields,1)
    fpMatrix(find(labels.(fields{classi})==1),find(labels.(fields{pairi})==1)) = 1;
    fpMatrix(find(labels.(fields{pairi})==1),labels.(fields{classi})==1) = 1;
    end
tpMatrix(find(labels.(fields{classi})==1),find(labels.(fields{classi})==1)) = 1;
fpMatrix(find(labels.(fields{classi})==1),find(labels.(fields{classi})==1)) = NaN;
categoryMCCs.(fields{classi}).tP = tpMatrix;
categoryMCCs.(fields{classi}).fP = fpMatrix;
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

 tpTotalCount = nansum(nansum(tp));
 fpTotalCount = nansum(nansum(fp));
 fnTotalCount = nansum(nansum(fn));
 tnTotalCount = nansum(nansum(tn));

%% Output
MCC = ((tpTotalCount*tnTotalCount)-(fpTotalCount*fnTotalCount))/sqrt((tpTotalCount+fpTotalCount)*(tpTotalCount+fnTotalCount)*(tnTotalCount+fpTotalCount)*(tnTotalCount+fnTotalCount));

%% Do MCC Individually for Each Iteration
for fi = 1:length(fields)
 tPMatrix = categoryMCCs.(fields{fi}).tP;
 fPMatrix = categoryMCCs.(fields{fi}).fP;
 
% Delete Match with Itself
totalIters = hitMatrix(1,1);

 for n = 1:nIntervals
 tpMatrix(n,n) = NaN;
 fpMatrix(n,n) = NaN;
 end

tP = hitMatrix.*tPMatrix;
fP= hitMatrix.*fPMatrix;
fN = totalIters-tP;
tN = totalIters-fP;

 tpTotalCount = nansum(nansum(tP));
 fpTotalCount = nansum(nansum(fP));
 fnTotalCount = nansum(nansum(fN));
 tnTotalCount = nansum(nansum(tN));

MCC2(fi,ii) = ((tpTotalCount*tnTotalCount)-(fpTotalCount*fnTotalCount))/sqrt((tpTotalCount+fpTotalCount)*(tpTotalCount+fnTotalCount)*(tnTotalCount+fpTotalCount)*(tnTotalCount+fnTotalCount));
end
A = table(MCC,'RowNames',fields);


end


%% Old Method of Validation
% prevalenceHits = (correctMatrix.*hitMatrix/hitMatrix(1,1));
% 
% rawCorrectPercentage = nanmean(nanmean(prevalenceHits));
% 
% chance = 1/k;
%  
% confidence = (rawCorrectPercentage-chance)/(1-chance);

