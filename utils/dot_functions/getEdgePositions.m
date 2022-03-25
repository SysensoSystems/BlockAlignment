function [edgeBlocksInfo,edgeData] = getEdgePositions(dotOutput)

dotOutput = strsplit(dotOutput,'\n');
% Initialize count
count = 0;
for edgeInd = 1:length(dotOutput)
    dotTokens = strsplit(dotOutput{edgeInd},' ');
    if strcmp(dotTokens{1}, 'graph')
         graphHeight = str2num(dotTokens{4});     
    elseif strcmp(dotTokens{1},'edge')
        srcBlock = dotTokens{2};  
        dstBlock = dotTokens{3};
        % Get the number of edge positions
        numEdges = str2num(dotTokens{4});
        for posInd = 1:numEdges
            % Get edge information and convert y to from top 
            edgeInfo{posInd} =  [str2num(dotTokens{4+posInd}), graphHeight - str2num(dotTokens{5+posInd})]; 
        end
        count = count+1; 
        % Store edge data
        edgeBlocksInfo{count} = {srcBlock, dstBlock}; 
        edgeData{count} = edgeInfo;
    end
end

end