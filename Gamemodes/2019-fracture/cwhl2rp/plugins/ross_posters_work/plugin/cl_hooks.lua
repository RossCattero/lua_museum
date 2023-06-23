
local PLUGIN = PLUGIN;

function PLUGIN:GetEntityMenuOptions(entity, options)
	local ec = entity:GetClass();

	if (entity:GetClass() == "ross_create_poster") then
		options["Отклеить постер"] = "r_poster_pinup"
	end;

end;

function PLUGIN:GetProgressBarInfo()
	local player = Clockwork.Client;
	local action, percentage = Clockwork.player:GetAction(player, true);
	local hasflag = Clockwork.player:HasFlags(player, "9");

	if (!Clockwork.Client:IsRagdolled()) then
		if (action == "StickTo") then
			return {text = "Приклеиваю...", percentage = percentage, flash = percentage < 10};
		end;
		if (hasflag && action == "TakeDownTheShit") then
			return {text = "Снимаю...", percentage = percentage, flash = percentage < 10};
		end;
	end;

end;

Clockwork.flag:Add("9", "Постеры", "Доступ к снятию флага.");