function digraphBlockData = getDigraphBlocksData(plotData)
% Get block data from gigraph plotData output
% Returns {dotBlockName X Y Width Height}

% Determine the position values
digraphBlockNames = plotData.NodeLabel;
digraphXPos = plotData.XData;
digraphYPos = plotData.YData;
%--------------------------------------------------------------------------
% Get the current blocks width and height data
for plotInd = 1:length(digraphBlockNames)
    % Get the actual block name
    digraphBlockNames{plotInd} = get_param(plotData.NodeLabel{plotInd},'Name');
    blockPosition{plotInd} = get_param(plotData.NodeLabel{plotInd},'Position');  %#ok<*AGROW>
    blockWidth(plotInd) = blockPosition{plotInd}(3)-blockPosition{plotInd}(1);
    blockHeight(plotInd) = blockPosition{plotInd}(4)-blockPosition{plotInd}(2);
end
%--------------------------------------------------------------------------
% Find the maximum of bolck width and height
% 100 is for optimum scale factor
scaleX = 100 + max(blockWidth);
scaleY = 100 + max(blockHeight);
%--------------------------------------------------------------------------
% Multiply scale factor for x and y position
for blockInd = 1:length(digraphBlockNames)
    digraphXPos(blockInd) = plotData.XData(blockInd) * scaleX;
    digraphYPos(blockInd) = plotData.YData(blockInd) * scaleY;
end
%--------------------------------------------------------------------------
graphHeight = (plotData.Parent.YLim(2)) * scaleY;
% Convert top to bottom
for blockInd = 1:length(digraphBlockNames)
    digraphYPos(blockInd) = graphHeight - digraphYPos(blockInd);
end
%--------------------------------------------------------------------------
% Return the blocks data 
digraphBlockData = [ {digraphBlockNames} digraphXPos digraphYPos blockWidth blockHeight];

end



