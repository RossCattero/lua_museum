
local PLUGIN = PLUGIN;

function PLUGIN:GetEntityMenuOptions(entity, options)
	local ec = entity:GetClass();

    if (entity:GetClass() == "ross_cp_callmonitor" && Clockwork.Client:GetFaction() == FACTION_MPF || Clockwork.Client:GetFaction() == FACTION_CWU) then
        if entity:GetTurned() == true then
            options["Выключить монитор"] = "r_monitor_off"
        elseif entity:GetTurned() == false then 
            options["Включить монитор"] = "r_monitor_on"
        end;
	end;

end;