

%% Easy Save for K-Means Results

if ~exist(kResultsDir,'dir');
    mkdir(kResultsDir);
end  
    
% Save for K-Means
 if norm(iter) == 1
    if exist('kResults','var')
save(fullfile(resultsDirk,[parameters.Directories.dataName, 'kResultsNorm',feature,'_',num2str(coeffs_to_retain),'.mat']),'kResults');
    end
 else
if exist('kResults','var') 
save(fullfile(resultsDirk,[parameters.Directories.dataName, 'kResults',feature,'_',num2str(coeffs_to_retain),'.mat']),'kResults');
end   
 end