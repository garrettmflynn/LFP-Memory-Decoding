function rasterEvents(Events)

behaviors = fieldnames(Events);
colors = parula(5);

for behavior = 1:(length(behaviors)-1)
    Y = Events.(behaviors{behavior});
%% Raster plot
t = find(Y(:));
nEvents = numel(t);
for ii = 1:nEvents
    %             line([t(ii), t(ii)], [i*ones(size(t(ii)))+0.1, i*ones(size(t(ii)))+0.8],'Color', 'black', 'LineWidth', 1.5); hold on;
    l(behavior) = line([Y(ii), Y(ii)], [ones(size(Y(ii))), ones(size(Y(ii)))+0.5],'Color', colors(behavior,:), 'LineWidth', 1.5); hold on;
end
end

title('Events Log');
yticks([]);
%xticks([]);
xlabel('Time (seconds)','FontSize',10);

cols = cell2mat(get(l, 'color'));
[~, uidx] = unique(cols, 'rows', 'stable');
legend(l(uidx), {'FO', 'SO','SR','MO','MR'})


end