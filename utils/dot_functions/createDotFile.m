function dotFileName = createDotFile(modelLayer,approach)
% Helps to create the '.dot' file for the given simulink model

modelBlocks = find_system(modelLayer,'SearchDepth',1,'LookUnderMasks','on');
% Remove the model layer name
modelBlocks = modelBlocks(2:end);
% Convert the unique file name
dotFileName = 'autoBlockAlignment';
% Open new file with model name
fid = fopen([dotFileName '.dot'],'wt');
fprintf(fid, '%s\n',['digraph ' dotFileName '{']);
fprintf(fid, '%s\n','nodesep = 100;');
fprintf(fid, '%s\n','ranksep = 100;');
fprintf(fid, '%s\n','rankdir = "LR"');
fprintf(fid, '%s\n','node [shape = record,fixedsize = true,fontsize = 1]');
%--------------------------------------------------------------------------
% Block information in dot format (nodes)
for blockInd = 1:length(modelBlocks)
    srcBlockName = get_param(modelBlocks{blockInd},'Name');
    % find_system is used to get unique name
    blockPath = find_system(modelLayer,'SearchDepth',1,'LookUnderMasks','on','Name',srcBlockName);
    blockPath = blockPath{1};
    blockPorts = get_param(blockPath,'Ports');
    % Get the port size label string data
    labelString = setPortSize(blockPorts);
    blockPos = get_param(blockPath,'Position');
    % Convert block names to graphviz standard name
    srcBlockName = convertBlockName(srcBlockName);
    % Set scaling factor
    widthHeightScaling = 1;
    fprintf(fid, '%s\n',[srcBlockName '[label =" '  labelString  '"' ...
        ' width = ' num2str((blockPos(3)-blockPos(1))/widthHeightScaling) ',' ...
        ' height = ' num2str((blockPos(4)-blockPos(2))/widthHeightScaling) '];']);
end
%--------------------------------------------------------------------------
% Connection information in dot format (edges)
for blockInd = 1:length(modelBlocks)
    ph = get_param(modelBlocks{blockInd},'PortHandles');
    for outPortInd = 1:length(ph.Outport)
        srcPortNum = get_param(ph.Outport(outPortInd),'PortNumber');
        lineH = get_param(ph.Outport(outPortInd),'Line');
        dstBlockH = get_param(lineH,'DstBlockHandle');
        dstPortH = get_param(lineH,'DstPortHandle');
        for portInd = 1:length(dstBlockH)
            dstBlockName = get_param(dstBlockH(portInd),'Name');
            dstPortNum = get_param(dstPortH(portInd),'PortNumber');
            srcBlockName = get_param(modelBlocks{blockInd},'Name');
            % Convert block names to graphviz standard names
            srcBlockName = convertBlockName(srcBlockName);
            dstBlockName = convertBlockName(dstBlockName);
            % Check for trigger or enabled subsystem
            % o - Outport, i - Inport, e - East, w - West, n- North,
            % E - Enable port, T - Trigger port, S - State Port
            % LC - LConn Port, RC - RConn Port
            % IF - Ifaction Port, RE - Reset Port
            portType = get_param(dstPortH(portInd),'PortType');
            % if graphviz include port direction
            if strcmp(approach,'graphviz')
                if strcmp(portType,'enable')
                    fprintf(fid, '%s\n',[srcBlockName ':' 'o' num2str(srcPortNum) ':e -> ' dstBlockName ':' 'E' ':n']);
                elseif strcmp(portType,'trigger')
                    fprintf(fid, '%s\n',[srcBlockName ':' 'o' num2str(srcPortNum) ':e -> ' dstBlockName ':' 'T' ':n']);
                elseif strcmp(portType,'state')
                    fprintf(fid, '%s\n',[srcBlockName ':' 'o' num2str(srcPortNum) ':e -> ' dstBlockName ':' 'S' ':n']);
                elseif strcmp(portType,'rc')
                    fprintf(fid, '%s\n',[srcBlockName ':' 'o' num2str(srcPortNum) ':e -> ' dstBlockName ':' 'LC' ':n']);
                elseif strcmp(portType,'trigger')
                    fprintf(fid, '%s\n',[srcBlockName ':' 'o' num2str(srcPortNum) ':e -> ' dstBlockName ':' 'RC' ':n']);
                elseif strcmp(portType,'ifaction')
                    fprintf(fid, '%s\n',[srcBlockName ':' 'o' num2str(srcPortNum) ':e -> ' dstBlockName ':' 'IF' ':n']);
                elseif strcmp(portType,'Reset')
                    fprintf(fid, '%s\n',[srcBlockName ':' 'o' num2str(srcPortNum) ':e -> ' dstBlockName ':' 'RE' ':n']);
                else
                    fprintf(fid, '%s\n',[srcBlockName ':' 'o' num2str(srcPortNum) ':e -> ' dstBlockName ':' 'i' num2str(dstPortNum) ':w']);
                end
                % if graphviz include port direction
            elseif strcmp(approach,'mwdot')
                if strcmp(portType,'enable')
                    fprintf(fid, '%s\n',[srcBlockName ':' 'o' num2str(srcPortNum) ' -> ' dstBlockName ':' 'E']);
                elseif strcmp(portType,'trigger')
                    fprintf(fid, '%s\n',[srcBlockName ':' 'o' num2str(srcPortNum) ' -> ' dstBlockName ':' 'T']);
                elseif strcmp(portType,'state')
                    fprintf(fid, '%s\n',[srcBlockName ':' 'o' num2str(srcPortNum) ' -> ' dstBlockName ':' 'S']);
                elseif strcmp(portType,'rc')
                    fprintf(fid, '%s\n',[srcBlockName ':' 'o' num2str(srcPortNum) ' -> ' dstBlockName ':' 'LC']);
                elseif strcmp(portType,'trigger')
                    fprintf(fid, '%s\n',[srcBlockName ':' 'o' num2str(srcPortNum) ' -> ' dstBlockName ':' 'RC']);
                elseif strcmp(portType,'ifaction')
                    fprintf(fid, '%s\n',[srcBlockName ':' 'o' num2str(srcPortNum) ' -> ' dstBlockName ':' 'IF']);
                elseif strcmp(portType,'Reset')
                    fprintf(fid, '%s\n',[srcBlockName ':' 'o' num2str(srcPortNum) ' -> ' dstBlockName ':' 'RE']);
                else
                    fprintf(fid, '%s\n',[srcBlockName ':' 'o' num2str(srcPortNum) ' -> ' dstBlockName ':' 'i' num2str(dstPortNum)]);
                end
            end            
        end
    end
end
%--------------------------------------------------------------------------
% close the file
fprintf(fid, '%s\n','}');
fclose(fid);

end
