function [A] = correctnessIndex(hitMatrix,labels,nIntervals,k)
% Output = Correctness Beyond Chance


fields = fieldnames(labels);
MCC = NaN;
if hitMatrix > 0 & isvector(hitMatrix)
%% Xiwei Method
for fi = 1:length(fields)
    currentCorrectField = labels.(fields{fi});
    
for ii = 1:max(hitMatrix)
clusterX = hitMatrix == ii


tP = sum(clusterX == 1 & currentCorrectField == 1)
fP = sum(clusterX == 1 & currentCorrectField == 0)
tN = sum(clusterX == 0 & currentCorrectField == 0)
fN = sum(clusterX == 0 & currentCorrectField == 1)
MCC(fi,ii) = ((tP*tN)-(fP*fN))/sqrt((tP+fP)*(tP+fN)*(tN+fP)*(tN+fN));
end
end
A = table(MCC,'RowNames',fields);

end


end




