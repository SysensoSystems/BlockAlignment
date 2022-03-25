function subSystems = getSubSystems(modelLayer)
% Get all the subsystems in a given model layer. Filters the stateflow
% charts.

subSystems = find_system(modelLayer,'LookUnderMasks', 'on','FollowLinks','off','BlockType','SubSystem');
%--------------------------------------------------------------------------
% Remove the stateflow subsystem.
chartInd = [];
for systemInd = 1:length(subSystems)
    blockType = get_param(subSystems{systemInd},'SFBlockType');
    if strcmpi(blockType,'Chart')
        chartInd = [chartInd systemInd]; %#ok<AGROW>
    end
end
subSystems(chartInd) = [];

end