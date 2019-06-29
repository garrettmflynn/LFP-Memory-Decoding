function [rawCorrectPercentage] = correctnessIndex(hitMatrix,nIntervals,k)
% Output = Correctness Beyond Chance

Animals = [3,4,8];
Plants = [1,6,14];
Buildings = [5,9,12];

correctMatrix = NaN(nIntervals,nIntervals);

correctMatrix(Animals,Animals) = 1;
correctMatrix(Plants,Plants) = 1;
correctMatrix(Buildings,Buildings) = 1;

% Delete Match with Itself
for n = 1:nIntervals
correctMatrix(n,n) = NaN;
end


prevalenceHits = (correctMatrix.*hitMatrix/hitMatrix(1,1));

rawCorrectPercentage = nanmean(nanmean(prevalenceHits));
% chance = 1/k;
% 
% confidence = (cMean-chance)/(1-chance);


end

