function [status,returnCode] = create_digraph(model_layer)
% This function creates the dot file for the given model_layer
% Open new file with model name
system_name = get_param(model_layer,'Name');
fid = fopen([system_name '.dot'],'wt');
fprintf(fid, '%s\n','digraph engine {');
fprintf(fid, '%s\n','rankdir="LR"');
fprintf(fid, '%s\n','node [shape=box, color=blue]');
% Start writing to the file about the model structure
blocks = find_system(model_layer,'SearchDepth',1);
for ii = 2:length(blocks)
    ph = get_param(blocks{ii},'PortHandles');
    %get_param(ph.Outport,'PortNumber');
    for jj = 1:length(ph.Outport)
        lineH = get_param(ph.Outport(jj),'Line');
        %get_param(lineH,'Connected')
        dstBlockH = get_param(lineH,'DstBlockHandle');
        for kk = 1:length(dstBlockH)
            dstBlockName = get_param(dstBlockH(kk),'Name');
            %destPortH=get_param(lineH,'DstPortHandle');
            srcBlockName = get_param(blocks{ii},'Name');
            disp([srcBlockName ' -> ' dstBlockName]);
            fprintf(fid, '%s\n', [srcBlockName ' -> ' dstBlockName]);
        end
    end
end
fprintf(fid, '%s\n','}');
fclose(fid);
%--------------------------------------------------------------------------
% Mwdot Approach
%--------------------------------------------------------------------------
%[status,returnCode] = system(['mwdot -Tplain ' system_name '.dot']);
%==========================================================================
% Grapviz Approach
%[status,returnCode] = system(['dot -Tplain ' system_name '.dot']);


