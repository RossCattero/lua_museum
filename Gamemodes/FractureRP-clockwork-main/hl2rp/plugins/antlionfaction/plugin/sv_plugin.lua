local PLUGIN = PLUGIN

-- A function to check if a player is an Antlion.
function PLUGIN:PlayerIsAntlion(player)
	if (IsValid(player) and player:GetCharacter()) then
		local faction = player:GetFaction();
		
		if (PLUGIN:IsAntlionFaction(faction)) then
			return true;
		else
			return false;
		end;
	end;
end;