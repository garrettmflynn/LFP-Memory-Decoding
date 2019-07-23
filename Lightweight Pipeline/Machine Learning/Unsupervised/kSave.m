if ~exist(resultsDirk,'dir');
    mkdir(resultsDirk);
end  
    
% Save for K-Means
 if norm(iter) == 1
    if exist('results','var')
save(fullfile(resultsDirk,[parameters.Directories.dataName, 'ResultsNorm',num2str(coeffs_to_retain),'.mat']),'resultsK');
    end
if exist('resultsK','var') 
save(fullfile(resultsDirk,[parameters.Directories.dataName, 'ResultsNormK',num2str(coeffs_to_retain),'.mat']),'resultsK');
end   