function [MCC] = ML_MCC(confMat)
% Determine MCCs from ML Confusion Matrix Outputs

tp = confMat(1,1);
fp = confMat(2,1);
fn = confMat(1,2);
tn = confMat(2,2);

MCC = ((tp*tn)-(fp*fn))/sqrt((tp+fp)*(tp+fn)*(tn+fp)*(tn+fn));

end