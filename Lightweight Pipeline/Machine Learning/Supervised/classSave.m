

%% Easy Save for Classifier Results


if ~exist(resultsDir,'dir');
    mkdir(resultsDir);
end

if norm(iter) == 1
    if exist('results','var')
        save(fullfile(resultsDir,[parameters.Directories.dataName, 'cResultsNorm',feature,'[-',num2str(range),' ',num2str(range),'].mat']),'cResults');
    end
else
    if exist('results','var')
        save(fullfile(resultsDir,[parameters.Directories.dataName, 'cResults',feature,'[-',num2str(range),' ',num2str(range),'].mat']),'cResults');
    end
end