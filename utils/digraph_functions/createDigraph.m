function diGraph = createDigraph(modelLayer)
% Helps to create the digraph for the given "modelLayer"

% Initialize digraph
diGraph = digraph([],[]);
% Get the blocks in tne system as nodes
nodes = find_system(modelLayer,'SearchDepth',1,'LookUnderMasks','on','Type', 'block');
% Remove the subsystem name from nodes
nodes(strcmp(nodes, modelLayer), :) = [];
numNodes = length(nodes);
%--------------------------------------------------------------------------
% Add the blocks as nodes
for nodeInd = 1:numNodes
    diGraph = addnode(diGraph,nodes{nodeInd});
end
%--------------------------------------------------------------------------
% Add the wires between blocks as edges
for nodeInd = 1:numNodes
    % Get ports of the current node
    connectData = get_param(nodes(nodeInd),'PortConnectivity');
    % Get all neighbour ports
    neighbourPort = [connectData{1}.DstBlock];
    if ~isempty(neighbourPort)
        for neighbourInd = 1:length(neighbourPort)
            % Draw edge between source and destination
            neighbourName = getfullname(neighbourPort(neighbourInd));
            % addedge(graph,source,destination)
            diGraph = addedge(diGraph,nodes{nodeInd},neighbourName);
        end
    end
end

end
