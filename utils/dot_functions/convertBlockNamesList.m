function blockNamesList = convertBlockNamesList(actualBlockNamesList)
% helps to convert the given block names to graphviz standard block names.

% Remove the layer name
actualBlockNamesList = actualBlockNamesList(2:end);
for blockInd = 1:length(actualBlockNamesList)
    % Get the block name
    blockName = get_param(actualBlockNamesList{blockInd},'Name');
    % Replace space characters
    newBlockName = strrep(blockName,char(32),'_');
    % Replace new line characters
    newBlockName = strrep(newBlockName,newline,'$$');
    % Save te actual and new block name in a cell array
    blockNamesList{blockInd} = {blockName,newBlockName};     %#ok<*AGROW>
end

end