fprintf('Making Labels\n');
%fields = fieldnames(dataML.Labels);
% fieldLabels = erase(fields,'Label_');
% labels = cell(size(dataML.Labels.(fields{1}),1),1);
% numTrials = size(dataML.Labels.(fields{1}),1);
for jj = 1:length(fields)
    currentField = featureMatrix.Labels.(fields{jj});
    for qq = 1:size(currentField,1)
        if currentField(qq) == 1
            if ~isempty(labels{qq})
                labels{qq} = [labels{qq} '_' fieldLabels{jj}] ;
            else
                labels{qq} = fieldLabels{jj};
            end
        end    
    end
end

for qq = 1:size(currentField,1)
if isempty(labels{qq});
    zero = qq;
    labels{zero} = 'None';
end
end