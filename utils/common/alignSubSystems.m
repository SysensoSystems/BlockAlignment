function alignSubSystems(subSystems,approach,moveLocation,alignDiretion)
% Helps to align all the model layers specified in the "subSystems"

% Align subsystems one by one 
for systemInd = 1:length(subSystems)
    autoBlockAlignment(subSystems{systemInd},'current',approach,moveLocation,alignDiretion);
end

end
