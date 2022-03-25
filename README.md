# BlockAlignment - Simulink Block Alignment Tool 
 Helps to align the simulink model blocks using directed graph algorithms. 

Syntax:
>> autoBlockAlignment(modelLayer,alignDepth,approach);
>> autoBlockAlignment(modelLayer,alignDepth,approach,annotationMoveLocation,annotationAlignDiretion);

modelLayer : Name of the simulink model/subsystem which blocks to be aligned

alignDepth : Depth to which simulink model layer to be aligned
* 'current' - To align the blocks in the current layer only.
* 'all' - To align all layers below of the given system.

Approach : Select a directed graph aligning approach. All three
approaches are equally good. graphviz and mwdot are better than diagraph
as we can consider port alignments as well.
* 'graphviz' - To use the graphviz software(https://www.graphviz.org/)
installed in the machine.
* 'mwdot' - mwdot.exe is available as part of MATLAB installation.
* 'digraph' - digraph is a MATLAB function introduced from R2015b.

Optional Arguments: To handle annotation placements.
annotationMoveLocation : Location in which annotatios of the given simulink model to be moved.
'left','right','top','bottom' are the possible options.
Default Value: 'top'.

annotationAlignDiretion : Direction in which annotatios of the given simulink model to be moved.
'column','row' are the possible options
Default Value: 'column'.

Sample:
>> autoBlockAlignment('sldemo_autotrans/Vehicle','current','graphviz')
>> autoBlockAlignment('sldemo_autotrans','all','digraph')
>> autoBlockAlignment('sldemo_autotrans/Vehicle','current','mwdot','left','row') 
