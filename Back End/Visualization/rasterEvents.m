function rasterEvents(Y)
%% Raster plot
t = find(Y(:));
nEvents = numel(t);
for ii = 1:nEvents
    %             line([t(ii), t(ii)], [i*ones(size(t(ii)))+0.1, i*ones(size(t(ii)))+0.8],'Color', 'black', 'LineWidth', 1.5); hold on;
    line([Y(ii), Y(ii)], [ones(size(Y(ii))), ones(size(Y(ii)))+0.5],'Color', 'black', 'LineWidth', 1.5); hold on;
end

