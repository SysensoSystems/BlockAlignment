function newBlockName = convertBlockName(actualBlockName)
% Helps to convert the given block name to graphviz standard block name.

% Removing space and newline characters 
newBlockName = strrep(actualBlockName,char(32),'_');
newBlockName = strrep(newBlockName,newline,'$$');
% String conversion is used to avoid the naming issue from graphviz
newBlockName = strcat('"',newBlockName,'"');

end