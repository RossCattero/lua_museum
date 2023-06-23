
local PLUGIN = PLUGIN;

function PLUGIN:GetProgressBarInfo()
	local action, percentage = Clockwork.player:GetAction(Clockwork.Client, true);

	if (!Clockwork.Client:IsRagdolled()) then
		if (action == "Unload") then
			return {text = "Разрядка магазина...", percentage = percentage, flash = percentage < 10};
		end;
	end;

end;

function PLUGIN:PlayerBindPress(player, bind, bPress)
	local weapon = player:GetActiveWeapon():GetClass();
	
    if HoldingTFAweapon(player) && string.find(bind, "+attack2") && IsWeaponMelee(weapon) then
        return true;
    end;
end;