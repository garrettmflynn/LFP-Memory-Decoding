     if ~exist(resultsDir,'dir');
    mkdir(resultsDir);
end   

if norm(iter) == 1
          if exist('results','var')
save(fullfile(resultsDir,[parameters.Directories.dataName, 'ResultsNorm[-',num2str(range),' ',num2str(range),'].mat']),'results');
          end
      else
           if exist('results','var')
save(fullfile(resultsDir,[parameters.Directories.dataName, 'Results[-',num2str(range),' ',num2str(range),'].mat']),'results');
           end
      end