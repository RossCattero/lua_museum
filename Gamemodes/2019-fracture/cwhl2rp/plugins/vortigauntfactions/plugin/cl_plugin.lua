local PLUGIN = PLUGIN;

Clockwork.directory:AddCategory("Вортигонт", "Команды");

-- A function to get whether a player is Vortigaunt.
function PLUGIN:PlayerIsVortigaunt(player)
	if (!IsValid(player)) then
		return;
	end;

	local faction = player:GetFaction();
	
	if (PLUGIN:IsVortigauntFaction(faction)) then
		if (faction == FACTION_VORT) then
			return true;
		else
			return false;
		end;
	end;
end;