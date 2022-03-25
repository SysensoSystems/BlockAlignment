function labelString = setPortSize(blockPorts)
% Helps to create the "label string" for Hash table appraoch of graphviz

% Get the port details
inPorts = blockPorts(1);
outPorts = blockPorts(2);
enablePorts = blockPorts(3);
triggerPorts = blockPorts(4);
statePorts = blockPorts(5);
lconnPorts = blockPorts(6);
rconnPorts = blockPorts(7);
ifactionPorts = blockPorts(8);
resetPorts = blockPorts(8);
%--------------------------------------------------------------------------
% Form the inPorts label
if inPorts >= 1
    inTxt = '{';
    for inInd = 1:inPorts
        inTxt = strcat(inTxt,['<i' num2str(inInd) '>|']);
    end
    inTxt(length(inTxt)) = '';
    inTxt = strcat(inTxt,'}');
else
    inTxt = '';
end
% Form the outPorts label
if outPorts >= 1
    outTxt = '{';
    for outInd = 1:outPorts
        outTxt = strcat(outTxt,['<o' num2str(outInd) '>|']);
    end
    outTxt(length(outTxt)) = '';
    outTxt = strcat(outTxt,'}');
else
    outTxt = '';
end
% Check the enable and trigger ports information
if enablePorts && triggerPorts
    labelString = strcat('{',inTxt,'|<E>|<T>|',outTxt,'}');
elseif enablePorts >= 1
    labelString = strcat('{',inTxt,'|<E>|',outTxt,'}');
elseif triggerPorts >= 1
    labelString = strcat('{',inTxt,'|<T>|',outTxt,'}');
elseif statePorts >= 1 
    labelString = strcat('{',inTxt,'|<S>|',outTxt,'}');
elseif lconnPorts >= 1
    labelString = strcat('{',inTxt,'|<LC>|',outTxt,'}');
elseif rconnPorts >= 1
    labelString = strcat('{',inTxt,'|<RC>|',outTxt,'}');
elseif ifactionPorts >= 1 
    labelString = strcat('{',inTxt,'|<IF>|',outTxt,'}');
elseif resetPorts >= 1
    labelString = strcat('{',inTxt,'|<RE>|',outTxt,'}');                   
else
    if strcmp(inTxt,'') && strcmp(outTxt,'')
         labelString = '';
    else
        labelString = strcat('{',inTxt,'|',outTxt,'}');
    end
end

end
