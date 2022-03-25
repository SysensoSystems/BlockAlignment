function actualBlockNameList = getActualBlockNameList(dotBlocksData,blockNamesList)
% To get the actual block names list for the given dot block names list

% Get the dot block names list
dotBlockNames = dotBlocksData{1};

for blockInd = 1:length(dotBlockNames)
    % Get the corresponding actual block name
    actualBlockNameList{blockInd} = getActualBlockName(dotBlockNames{blockInd},blockNamesList);
end