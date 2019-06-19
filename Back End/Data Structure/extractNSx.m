function [neuralData] = extractNSx(filePath, dataName)
% Extracts data from native Blackrock .NSx files


NSxPattern = fullfile(filePath, [dataName, '.ns*']);
NSxMatch = dir(NSxPattern);
NSxName = NSxMatch.name;
NSxDir = fullfile(filePath, NSxName);
neuralData = openNSx(NSxDir);
end