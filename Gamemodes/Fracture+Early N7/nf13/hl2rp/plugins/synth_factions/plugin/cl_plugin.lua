local PLUGIN = PLUGIN;

function PLUGIN:PlayerBindPress(player, bind, bPress)
    if (player:GetFaction() == FACTION_CREMATOR or player:GetFaction() == FACTION_GUARDER) and (string.find(bind, "+speed") || string.find(bind, "+jump") || string.find(bind, "+duck")) then
        return true;
    end;
end;