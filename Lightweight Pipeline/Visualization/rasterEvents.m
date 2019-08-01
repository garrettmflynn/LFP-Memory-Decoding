function rasterEvents(Events)

if isempty(Events)
    % Rat Data Does Not Contain Events
else
behaviors = fieldnames(Events);
initB = length(behaviors);
eventPool = zeros(1,initB);
for bIter = 1:initB
match = cell2mat(regexpi(behaviors{bIter},{'FOCUS_ON','SAMPLE_ON','SAMPLE_RESPONSE','MATCH_ON','MATCH_RESPONSE'}));
     if ~isempty(match)
 eventPool(bIter) =  match;
     end
end

chosenBehaviors = find(eventPool);
numB = length(chosenBehaviors);
colors = parula(numB);

for behavior = 1:numB
    Y = Events.(behaviors{chosenBehaviors(behavior)});
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

end