
local PLUGIN = PLUGIN;

PLUGIN:SetGlobalAlias("RossTalkers");

function ConvertSomeText(text)
    if !isstring(text) then
        return;
    end;

    if utf8.len(text) > 91 then
        text = utf8.sub(text, 1, 91)..'\n'..utf8.sub(text, 91, 182)
    elseif utf8.len(text) > 182 then
        text = utf8.sub(text, 1, 91)..'\n'..utf8.sub(text, 91, 182).."..."
    end;

    return text;
end;

function HasQuestByID(vname, q)
    for k, v in pairs(q) do
        if v.vendorName == vname then
            return true;
        end;
    end;
    return false;
end;

Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");