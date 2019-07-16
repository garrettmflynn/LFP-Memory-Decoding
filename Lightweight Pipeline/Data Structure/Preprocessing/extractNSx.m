function [neuralData] = extractNSx(filePath, dataName)
% Extracts data from native Blackrock .NSx files

% First Try
NSxPattern = fullfile(filePath, [dataName, '.ns*']);
NSxMatch = dir(NSxPattern);
if ~isempty(NSxMatch)
NSxName = NSxMatch.name;
NSxDir = fullfile(filePath, NSxName);
neuralData = openNSx(NSxDir);
else
fprintf('NEV File Found (only spike waveforms will be loaded.');
NSxPattern = fullfile(filePath, [dataName, '.nev']);
NSxMatch = dir(NSxPattern);
NSxName = NSxMatch.name;
if ~isempty(NSxMatch)
    NSxDir = fullfile(filePath, NSxName);
neuralData = openNEV(NSxDir);
else
    error('No Blackrock Data File Found');
end
end
end