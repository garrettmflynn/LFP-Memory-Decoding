
function [consistentGroups] = prevalenceDetection2(prevalenceStruct);
% PREVALENCEDETECTION takes in a square NxN matrix, where N corresponds to
% the # of intervals processed, that logs the # of times that two intervals
% have been clustered together--whether this is over K Values, PCA
% Components, K-Means Iterations, or Channels. The output of this functoin
% is a 1xN vector where columns correspond to the
% interval-under-investigation, and cells correspond to the other intervals
% clustered with such an interval (if such clustering occurs MORE THAN the
% specified threshold.

k = 1:size(prevalenceStruct.SCA,2);
c = 1:size(prevalenceStruct.SCA,1);
sIters = prevalenceStruct.SCA{c(1),k(end)}(1,1);
sizeTrials = size(prevalenceStruct.SCA{1,k(end)},1);

cutoff = sIters * 1/2; % Of All Iterations

%% Raw & PCA SCA Prevalence
SCA = prevalenceStruct.SCA;
SCA_PCA = prevalenceStruct.PCA.SCA;

generalized = cell(1,size(SCA,2));
for kk = k
    generalized{1,kk} = ones(sizeTrials,sizeTrials);
   for cc = c
       if isempty(SCA{cc,kk})
           generalized{kk} = [];
           SCA_Raw{cc,kk} = [];
       else
   SCA_Raw{cc,kk} = double((SCA{cc,kk} >=cutoff) .* (SCA_PCA{cc,kk} >=cutoff));
   generalized{1,kk} = generalized{1,kk} .* double((SCA{cc,kk}>0) .* (SCA_PCA{cc,kk}>0))
       end
   end
end


%% Raw Concatenated Channels Prevalence
MCA = prevalenceStruct.MCA;
CCA1 = prevalenceStruct.CCA1;
CCA3 = prevalenceStruct.CCA3;

for kk = k
    channelConcatenated_Raw{kk} = double((MCA{kk}>=cutoff) .* ( CCA1{kk} >=cutoff) .* (CCA3{kk}>=cutoff));
    generalized{1,kk} = generalized{1,kk} .* double((MCA{kk} >0) .* (CCA1{kk}>0) .* ( CCA3{kk}>0));
end

%% PCA Concatenated Channels Prevalence
MCA_p = prevalenceStruct.PCA.MCA;
CCA1_p = prevalenceStruct.PCA.CCA1;
CCA3_p = prevalenceStruct.PCA.CCA3;

for kk = k
      channelConcatenated_PCA{kk} = double((MCA_p{kk}>=cutoff) .* ( CCA1_p{kk} >=cutoff) .* (CCA3_p{kk}>=cutoff));
    generalized{1,kk} = generalized{1,kk} .*double((MCA_p{kk} >0) .* (CCA1_p{kk}>0) .* ( CCA3_p{kk}>0));
    allChannelCon{kk} = channelConcatenated_PCA{kk} .* channelConcatenated_Raw{kk};

end

for kk = k
if ~isempty(generalized{kk})
    for q = 1:sizeTrials
    temp{1,q} = find(generalized{1,kk}(q,:) == 1);
    end
consistentGroups.consistentGroupsG{1,kk} = temp;
for cc = c
for q = 1:sizeTrials
temp{1,q} = find(SCA_Raw{cc,kk}(q,:) == 1);
end
consistentGroups.consistentGroupsSCA{cc,kk} = temp;
end
for q = 1:sizeTrials
    temp1{1,q} = find(channelConcatenated_Raw{kk}(q,:) == 1);
    temp2{1,q} = find(channelConcatenated_PCA{kk}(q,:) == 1);
    temp3{1,q} = find(allChannelCon{kk}(q,:)== 1);
end
consistentGroups.consistentGroupsCon{1,kk} = temp1;
consistentGroups.consistentGroupsCon_p{1,kk} = temp2;
consistentGroups.consistentGroupsCon_All{1,kk} = temp3;
end
end


for kk = k
if ~isempty(generalized{1,kk})
[~ ,consistentGroups.MCC_g(kk)] = correctnessIndex(generalized{1,kk},sizeTrials,kk);
[~ ,consistentGroups.MCC_ccr(kk)] = correctnessIndex(channelConcatenated_Raw{1,kk},sizeTrials,kk);
[~ ,consistentGroups.MCC_sca(kk)] = correctnessIndex(SCA_Raw{1,kk},sizeTrials,kk);
[~ ,consistentGroups.MCC_pca(kk)] = correctnessIndex(channelConcatenated_PCA{1,kk},sizeTrials,kk);
[~ ,consistentGroups.MCC_conAll(kk)] = correctnessIndex(allChannelCon{1,kk},sizeTrials,kk);
end
end






end