function [rasterPolygons] = polyEvents(Events,start,stop,vBound,fs)

if isempty(Events)
    % Rat Data Does Not Contain Events
else
    
    
 % Create Blocks
   trialStarts = Events.FOCUS_ON(start:stop)*fs;
   trialStops = Events.MATCH_RESPONSE(start:stop)*fs;

   templateY = ones(1,length(trialStarts));
   bottomY = -vBound*templateY';
   topY = (-vBound + (vBound*.2))*templateY';
   
   firstInds = [trialStarts,bottomY];
   secInds = [trialStarts,topY];
  thirdInds = [trialStops,topY];
   fourthInds = [trialStops,bottomY];
   
   rasterPolygons.Blocks.polyV = [firstInds;secInds;thirdInds;fourthInds];
   faces = [1,length(firstInds)+1,2*length(firstInds)+1,3*length(firstInds)+1];
   rasterPolygons.Blocks.polyF = faces;
   
   for ii = 1:10-1
   rasterPolygons.Blocks.polyF = [rasterPolygons.Blocks.polyF; ii+faces];
   end
    
   

   % Find Relevant Behaviors
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

for behavior = 1:numB
    currentBehavior = behaviors{chosenBehaviors(behavior)};
    Y = Events.(currentBehavior);
%% Raster plot
    switch currentBehavior
        case 'FOCUS_ON'
             rasterPolygons.Events.FO = Y(start:stop)*fs;
        case 'SAMPLE_ON'
             rasterPolygons.Events.SO = Y(start:stop)*fs;
        case 'SAMPLE_RESPONSE'
             rasterPolygons.Events.SR = Y(start:stop)*fs;
        case 'MATCH_ON'
             rasterPolygons.Events.MO = Y(start:stop)*fs;
        case 'MATCH_RESPONSE'
             rasterPolygons.Events.MR = Y(start:stop)*fs;
    end       
end

rasterPolygons.Bounds.topY = topY;
rasterPolygons.Bounds.bottomY = bottomY;
end
end