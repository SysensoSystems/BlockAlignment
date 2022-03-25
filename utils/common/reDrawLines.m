function reDrawLines(modelLayer)
% Redraw the lines in a given layer using autorouting.

% Get the blocks
modelBlocks = find_system(modelLayer,'SearchDepth',1,'LookUnderMasks','on');
% Remove the model layer
modelBlocks = modelBlocks(2:end);

for blockInd = 1:length(modelBlocks)
    % Get all line handles
    lineHandle = get_param(modelBlocks{blockInd},'LineHandles');
    if ~isempty(lineHandle.Inport)
        for portInd = 1:length(lineHandle.Inport)
            % Get source and destination handles
            srcPortNum = get_param(lineHandle.Inport(portInd), 'SrcPortHandle');
            dstPortNum = get_param(lineHandle.Inport(portInd), 'DstPortHandle');
            % delete the line
            delete_line(lineHandle.Inport(portInd))
            % draw new line
            add_line(modelLayer, srcPortNum, dstPortNum, 'autorouting','on');
        end
    end
end

end