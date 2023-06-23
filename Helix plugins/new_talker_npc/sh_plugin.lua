
local PLUGIN = PLUGIN;
PLUGIN.name = "Ross Talkers"
PLUGIN.author = "Ross"
PLUGIN.description = ""
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

function HasQuestTypeByID(q, t)
    for k, v in pairs(q) do
        if v.type == t then
            return true;
        end;
    end;
    return false;
end;

ix.util.Include("sv_plugin.lua")
ix.util.Include("cl_plugin.lua")