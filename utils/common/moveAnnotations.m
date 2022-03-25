function offsetPos = moveAnnotations(modelLayer,blocksData,moveLocation,alignDiretion)
% helps to move the all annotatiions of the giben modelLayer to the
% specified position

% dotBlockData -> {dotBlockName X Y Width Height}
% moveLocation -> 'left','right','top','bottom'
% alignDiretion -> 'column','row'
% Note: Simulink orgin is topleft corner

xData = blocksData{2};
yData = blocksData{3};
widthData = blocksData{4};
heightData = blocksData{5};
%--------------------------------------------------------------------------
% Add and subtract the height values with ydata
for heightInd = 1:length(heightData)
    % To get the minimum y from top
    topYData(heightInd) = yData(heightInd) - (heightData(heightInd)/2); %#ok<*AGROW>
    % To get the maximum y from top
    bottomYData(heightInd) = yData(heightInd) + (heightData(heightInd)/2);
end
%--------------------------------------------------------------------------
% Add the width values with xdata
for widthInd = 1:length(widthData)
    rightXData(widthInd) = xData(widthInd) + (widthData(widthInd)/2);
    leftXData(widthInd) = xData(widthInd) - (widthData(widthInd)/2);
end
%--------------------------------------------------------------------------
% Minimum height of the graph from top
minGraphHeight = min(topYData);
% Maximum height of the graph from top
maxGraphHeight = max(bottomYData);
% Maximum width of the graph from left
maxGraphWidth  = max(rightXData);
% Minimum width of the graph from left
 minGraphWidth = min(leftXData);
%--------------------------------------------------------------------------
% Initialize data
antnsGap = 10;
antnAndModelGap = 50;
orginGap = 50;
%--------------------------------------------------------------------------
switch moveLocation
    case 'left'
        movedXPos = minGraphWidth + orginGap;
        movedYPos = minGraphHeight;
    case 'right'
        movedXPos = maxGraphWidth + orginGap;
        movedYPos = minGraphHeight;
    case 'top'
        movedXPos = minGraphWidth;
        movedYPos = minGraphHeight;
    case 'bottom'
        movedXPos = minGraphWidth;
        movedYPos = maxGraphHeight + orginGap;
    otherwise
        return;
end
%--------------------------------------------------------------------------
% Get the annotations handles of the modelLayer
annotationHandles = find_system(modelLayer,'SearchDepth',1,...
    'LookUnderMasks','on','FindAll','on','type','annotation');
% check annotation is empty or not
if ~isempty(annotationHandles)
    % Get annotations position data
    for handleInd = 1:length(annotationHandles)
        antnPosition = get_param(annotationHandles(handleInd),'Position');
        antnWidth(handleInd) = antnPosition(3) - antnPosition(1);
        antnHeight(handleInd) = antnPosition(4) - antnPosition(2);
        % Set new Postion
        switch alignDiretion
            case 'row'
                newAntnPos = [movedXPos movedYPos (movedXPos + antnWidth(handleInd)) ...
                    (movedYPos + antnHeight(handleInd))];
                % Move Y as per annotation height
                movedYPos = movedYPos + antnHeight(handleInd) + antnsGap;
            case 'column'
                newAntnPos = [movedXPos movedYPos (movedXPos + antnWidth(handleInd)) ...
                    (movedYPos + antnHeight(handleInd))];
                % Move X as per annotation width
                movedXPos = movedXPos + antnWidth(handleInd) + antnsGap;
            otherwise
                return;
        end
        % Set the new position
        set_param(annotationHandles(handleInd),'Position',newAntnPos);
    end
    %----------------------------------------------------------------------
    % Get the maximum width and height of annotations
    % maxAntnWidth for 'row' alignDiretion
    maxAntnWidth = max(antnWidth);
    % Maximun Anntn height
    maxAntnHeight = max(antnHeight);
    %----------------------------------------------------------------------
    % Assign the offset position
    switch moveLocation
        case 'left'
            if strcmp(alignDiretion,'row')
                xOffset = movedXPos + maxAntnWidth + antnAndModelGap;
                offsetPos = [xOffset  0];
            elseif strcmp(alignDiretion,'column')
                xOffset = movedXPos + antnAndModelGap;
                offsetPos = [xOffset 0];
            end
        case 'right'
            offsetPos = [0 0];
        case 'top'
            if strcmp(alignDiretion,'row')
                yOffset = movedYPos - minGraphHeight + antnAndModelGap;
                offsetPos = [0 yOffset];
            elseif strcmp(alignDiretion,'column')
                yOffset = maxAntnHeight + antnAndModelGap;
                offsetPos = [0 yOffset];
            end
        case 'bottom'
            offsetPos = [0 0];
        otherwise
            return;
    end
else
    offsetPos = [0 0];
end

end

