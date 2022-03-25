function dotBlocksData = getDotBlocksData(dotOutput)
% Get block data from dotOuput
% Returns {dotBlockName X Y Width Height}

% Split the dot output line by line
dotOutput = strsplit(dotOutput,'\n');
for nodeInd = 1:length(dotOutput)
    dotTokens = strsplit(dotOutput{nodeInd},' ');
    if strcmp(dotTokens{1}, 'graph')
        graphScale = str2num(dotTokens{2}); 
        graphWidth = str2num(dotTokens{3});
        graphHeight = str2num(dotTokens{4});     
    elseif strcmp(dotTokens{1}, 'node')
        dotBlockNames{nodeInd - 1} = dotTokens{2};  
        dotXPos(nodeInd - 1) = str2num(dotTokens{3});
        dotYPos(nodeInd - 1) = str2num(dotTokens{4});
        dotWidth(nodeInd - 1) = str2num(dotTokens{5});
        dotHeight(nodeInd - 1) = str2num(dotTokens{6});
    end
end
%--------------------------------------------------------------------------
% Top to bottom conversion using the graph size
% min + max - actual -> top to bottom conversion
% (0 + graphHeight) - y 
dotYPos = graphHeight - dotYPos;
%--------------------------------------------------------------------------
% Return the block data
dotBlocksData = {dotBlockNames dotXPos dotYPos dotWidth dotHeight};

end
