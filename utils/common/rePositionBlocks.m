function rePositionBlocks(modelLayer,blocksData,offsetPos)
% Helps to reposition the blocks of the given model
% Inputs:
%   modelLayer -> Simulink model name in which blocks to be repositioned
%
%   blocksData -> "{BlockName X Y Width Height}"
%
%   offsetPos -> "[x y]" position value to be offseted
%
%   Optional -> "blockNamesList" for dot approach

% Initialize the scaling
% Change 'widthHeightScaling' based on "createDotFile" function
widthHeightScaling = 1;
% For testing purpose
xyScaling = 1;
%--------------------------------------------------------------------------
% Extract dot block data
blockNames = blocksData{1};
xPos = blocksData{2};
yPos = blocksData{3};
widthData = blocksData{4};
heightData = blocksData{5};
%--------------------------------------------------------------------------
% Change the X and Y pos using offset data
for posInd = 1:length(blockNames)
    xPos(posInd) = xPos(posInd) + offsetPos(1);
    yPos(posInd) = yPos(posInd) + offsetPos(2);
end
%--------------------------------------------------------------------------
for dataInd = 1:length(blockNames)
    % Get the current block name
    currentBlockName = blockNames{dataInd};    
    % Get the current block path
    blockPath = find_system(modelLayer,'SearchDepth',1,'LookUnderMasks','on','Name',currentBlockName);
    % Remove cell type
    blockPath = blockPath{1};
    % Get the block position information
    blockXPos = xPos(dataInd) * xyScaling;  %#ok<*ST2NM>
    blockYPos = yPos(dataInd) * xyScaling;
    blockWidth = widthData(dataInd) * widthHeightScaling;
    blockHeight = heightData(dataInd) * widthHeightScaling;
    % Make the xy position as block centre
    left = blockXPos - (blockWidth/2);
    right = blockXPos + (blockWidth/2);
    top = blockYPos - (blockHeight/2);
    bottom = blockYPos + (blockHeight/2);
    % Set the new position
    set_param(blockPath,'Position', [left top right bottom]);
end

end
