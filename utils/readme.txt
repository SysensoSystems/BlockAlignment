readme - Block Alignment Tool
Introduction:
 	This tool will be helpful to align the blocks of the given simulink model automatically.
	It uses the following three apporaches to align the blocks.

	1. Graphviz software can be downloaded from http://graphviz.org/
	To use 'Grapviz' Appraoch:
		1. Install graphviz.exe.
		2. Put Graphviz directory in path variable. Example: "C:Program Files\GraphvizX.YY\bin"				
		3. Put Graphviz directory in MATLAB path. Example: "C:Program Files\GraphvizX.YY\bin"
		4. Check the installtion by calling graphviz from MATLAB. Example: system('dot') 

	2.  'MATLAB' dot approach(mwdot) which is similar to 'Grapviz'.
		'mwdot' is a '.exe' file packed with MATLAB installation which can be found at "matlabroot\bin\win32" or "matlabroot\bin\win64"

    3. 'diagraph' function from MATLAB.
		'digraph' is a MATLAB function which can be used draw graphs with directed edges. 
        It is available only from R2015b version.

How to use:
	1. Add utils and its subdirectories into MATLAB path.
	2. Enter "help autoBlockAlignment" in MATLAB command prompt
	3. Follow the instructions in the help section to proceed further

TODO: Have to handle line/wire alignments.

% Developed by: Sysenso Systems, www.sysenso.com
% Contact: contactus@sysenso.com

% Version:
1.0 - Initial Version.