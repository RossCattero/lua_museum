
local PLUGIN = PLUGIN;

function PLUGIN:AddEntityOutlines(outlines)
    local vic = Clockwork.Client:GetSharedVar('victimEnt');
    if vic != '' then
        outlines:Add(vic, Color(255, 100, 100), 5)
    end;
end;