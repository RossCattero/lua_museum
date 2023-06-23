
local PLUGIN = PLUGIN;

function PLUGIN:GetProgressBarInfo()
	local action, percentage = Clockwork.player:GetAction(Clockwork.Client, true);

	if (!Clockwork.Client:IsRagdolled()) then
		if (action == "Unload") then
			return {text = "Разрядка магазина...", percentage = percentage, flash = percentage < 10};
		end;
	end;

end;