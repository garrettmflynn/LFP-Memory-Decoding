        
function [alreadyEdges] = rewriteEdges(toAdd)
amountAdded = 1:length(toAdd);
        alreadyEdges = NaN(1,2);
        for index = amountAdded
            edgesToAdd = toAdd(amountAdded ~= index);
            candidateEdges = toAdd(index) * ones(length(edgesToAdd),2);
            candidateEdges(:,2) = edgesToAdd;
            uniqueCandidatesForward = setdiff(candidateEdges,alreadyEdges,'rows');
            uniqueCandidates = setdiff(uniqueCandidatesForward,fliplr(alreadyEdges),'rows');
            if index == 1
            alreadyEdges = [uniqueCandidates];
            else
                alreadyEdges = [alreadyEdges ;uniqueCandidates];
            end
        end
end