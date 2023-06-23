local PLUGIN = PLUGIN;

-- A function to check if a player is Vortigaunt.
function PLUGIN:PlayerIsVortigaunt(player)
	if (IsValid(player) and player:GetCharacter()) then
		local faction = player:GetFaction();
		
		if (PLUGIN:IsVortigauntFaction(faction)) then
			return true;
		else
			return false;
		end;
	end;
end;