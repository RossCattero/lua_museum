
local PLUGIN = PLUGIN;

function PLUGIN:GetEntityMenuOptions(entity, options)
	if (entity:GetClass() == "clothes_washer") then
		if entity:GetTurnOn() == false then
			options["Открыть"] = "r_clothes_washer_o"
				
			if entity:GetAmountOfCleaning() > 0 then
				options["Включить"] = "r_clothes_washme"
			end;

		end;
	end;

	if (entity:GetClass() == "human_bath") then
		if !entity:GetWaterFall() && entity:GetWaterLevel() < 60 then
			options["Включить воду"] = "water_enable"
		elseif entity:GetWaterFall() && entity:GetWaterLevel() < 60 then
			options["Выключить воду"] = "water_disable"
		end;
	end;
end;

function PLUGIN:GetProgressBarInfo()
	local action, percentage = Clockwork.player:GetAction(Clockwork.Client, true);

	if (!Clockwork.Client:IsRagdolled()) then
		if (action == "cleanSelf") then
			return {text = "Помыться...", percentage = percentage, flash = percentage < 10};
		end;
	end;

end;