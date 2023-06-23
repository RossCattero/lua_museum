
local PLUGIN = PLUGIN;

function PLUGIN:GetEntityMenuOptions(entity, options)
	local ec = entity:GetClass();

    if (entity:GetClass() == "ross_cp_callmonitor") then
        if entity:GetTurn() == true then
            options["Выключить монитор"] = "r_monitor_off"
        elseif entity:GetTurn() == false then 
            options["Включить монитор"] = "r_monitor_on"
        end;
	end;

end;