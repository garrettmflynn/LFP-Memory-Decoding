if saveMLInputs
if norm(iter) == 1
save(fullfile(parameters.Directories.filePath,[parameters.Directories.dataName, 'dataMLNorm',num2str(coeffs_to_retain),'.mat']),'dataML');
else
save(fullfile(parameters.Directories.filePath,[parameters.Directories.dataName, 'dataML',num2str(coeffs_to_retain),'.mat']),'dataML');
end
end