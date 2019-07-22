function [MCC] = ML_MCC(confMat)
% Determine MCCs from ML Confusion Matrix Outputs

topLeft = confMat(1,1);
bottomLeft = confMat(2,1);
topRight = confMat(1,2);
bottomRight = confMat(2,2);

true1 = topLeft;
true2 = bottomRight;
false1 = bottomLeft;
false2 = topRight;

denominator = sqrt((true1+false1)*(true1+false2)*(true2+false1)*(true2+false2));

if denominator ~= 0
MCC = ((true1*true2)-(false1*false2))/denominator;
else
MCC = 0;
end

end