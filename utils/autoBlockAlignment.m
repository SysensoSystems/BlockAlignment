function autoBlockAlignment(modelLayer,alignDepth,approach,varargin)
% Helps to align the simulink model blocks using directed graph algorithms.
%
% Syntax:
%   >> autoBlockAlignment(modelLayer,alignDepth,approach);
%   >> autoBlockAlignment(modelLayer,alignDepth,approach,annotationMoveLocation,annotationAlignDiretion);
%
% modelLayer : Name of the simulink model/subsystem which blocks to be aligned
%
% alignDepth : Depth to which simulink model layer to be aligned
%       * 'current' -  To align the blocks in the current layer only.
%       * 'all' - To align all layers below of the given system.
%
% Approach : Select a directed graph aligning approach. All three
% approaches are equally good. graphviz and mwdot are better than diagraph
% as we can consider port alignments as well.
%   * 'graphviz' - To use the graphviz software(https://www.graphviz.org/)
%   installed in the machine.
%   * 'mwdot' - mwdot.exe is available as part of MATLAB installation.
%   * 'digraph' - digraph is a MATLAB function introduced from R2015b.
%
% Optional Arguments: To handle annotation placements.
% annotationMoveLocation : Location in which annotatios of the given simulink model to be moved.
%                'left','right','top','bottom' are the possible options.
%                Default Value: 'top'.
%
% annotationAlignDiretion : Direction in which annotatios of the given simulink model to be moved.
%                 'column','row' are the possible options
%                 Default Value: 'column'.
%
% Sample:
% >> autoBlockAlignment('sldemo_autotrans/Vehicle','current','graphviz')
% >> autoBlockAlignment('sldemo_autotrans','all','digraph')
% >> autoBlockAlignment('sldemo_autotrans/Vehicle','current','mwdot','left','row')
%
% Developed by: Sysenso Systems, https://sysenso.com/
% Contact: contactus@sysenso.com
%
% Version:
% 1.0 - Initial Version.

%--------------------------------------------------------------------------
% Input validation
%--------------------------------------------------------------------------
% Validate model layer
if ~isempty(modelLayer)
    modelBlocks = find_system(modelLayer,'SearchDepth',1,'LookUnderMasks','on');
else
    warndlg('Invalid model name');
    return;
end
if isempty(varargin)
    annotationMoveLocation = 'top';
    annotationAlignDiretion = 'column';
elseif length(varargin) == 2
    annotationMoveLocation = varargin{1};
    annotationAlignDiretion = varargin{2};
else
    warndlg('Invalid annotation alignment details.');
    return;
end
% Check for empty model
if isempty(modelBlocks) || length(modelBlocks) == 1
    return;
end
%--------------------------------------------------------------------------
% Validate alignDepth
switch alignDepth
    case 'current'
    case 'all'
        % Get all subsystem of the current modelLayer
        subSystems = getSubSystems(modelLayer);
        alignSubSystems(subSystems,approach,annotationMoveLocation,annotationAlignDiretion);
    otherwise
        warndlg('Invalid align depth');
        return;
end
%--------------------------------------------------------------------------
% Validate Approach
% Graphviz and mwdot uses same approach
if strcmp(approach,'graphviz')
    checkApproach = 'dot';
elseif strcmp(approach,'mwdot')
    checkApproach = 'dot';
elseif strcmp(approach,'digraph')
    checkApproach = 'digraph';
else
    warndlg('Invalid Approach');
    return;
end
%--------------------------------------------------------------------------
% Validate move location
switch annotationMoveLocation
    case 'left'
    case 'right'
    case 'top'
    case 'bottom'
    otherwise
        warndlg('Invalid annotationMoveLocation');
        return;
end
%--------------------------------------------------------------------------
% Validate align diretion
switch annotationAlignDiretion
    case 'row'
    case 'column'
    otherwise
        warndlg('Invalid annotationAlignDiretion');
        return;
end
%--------------------------------------------------------------------------
switch checkApproach
    case 'dot'
        % Create actual and unified block name list
        blockNamesList = convertBlockNamesList(modelBlocks);
        % Create the dot file for the given model
        dotFileName = createDotFile(modelLayer,approach);
        %------------------------------------------------------------------
        % Process the block using dot or mwdot
        if exist([dotFileName '.dot'], 'file') == 2
            if strcmp(approach,'graphviz')
                [status,dotOutput] = system(['dot -Tplain ' dotFileName '.dot']);
                % Check if graphviz installed or not
                if status ~= 0
                    errordlg('Graphviz not installed ','Installation Error');
                    return;
                end
                % Delete dotfile after usage
                delete('autoBlockAlignment.dot');
            else
                [status,dotOutput] = system(['mwdot -Tplain ' dotFileName '.dot']);
                if status ~=0
                    errordlg('Mwdot Error');
                    return;
                end
                % Delete dotfile after usage
                delete('autoBlockAlignment.dot');
            end
        else
            errdlg('Dot file not exists','Dot File Error');
            return;
        end
        %------------------------------------------------------------------
        % Process the dot Ouput and get block info
        blocksData = getDotBlocksData(dotOutput);
        % Get the actual block names from dot block names
        actualBlockNameList = getActualBlockNameList(blocksData,blockNamesList);
        % Set the actual block names in the blocks data
        blocksData{1} = actualBlockNameList;
        %------------------------------------------------------------------
    case 'digraph'
        % Create the digraph
        diGraph = createDigraph(modelLayer);
        % Avoid figure popup for plot
        currentVisible = get(0,'DefaultFigureVisible');
        set(0,'DefaultFigureVisible','off');
        % Plot the diagraph
        plotData = plot(diGraph,'Layout', 'layered', 'Direction','right');
        % Reset the DefaultFigureVisible
        set(0,'DefaultFigureVisible',currentVisible);
        % Process plotdata and get block info
        blocksData = getDigraphBlocksData(plotData);
end
%--------------------------------------------------------------------------
% Move Annotations as specified
offsetPos = moveAnnotations(modelLayer,blocksData,annotationMoveLocation,annotationAlignDiretion);
% Reposition the blocks
rePositionBlocks(modelLayer,blocksData,offsetPos);
% Rewire the lines to avoid the line overlaps.
reDrawLines(modelLayer);

end
