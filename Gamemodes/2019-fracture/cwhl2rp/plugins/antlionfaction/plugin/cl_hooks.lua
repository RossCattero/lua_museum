local PLUGIN = PLUGIN;

-- Called when a player's typing display position is needed.
function PLUGIN:GetPlayerTypingDisplayPosition(player)
	local faction = player:GetFaction();
	
	if (faction == FACTION_ANTLION) then
		local curTime = CurTime();	
		return player:GetPos() + Vector(0, 0, 65);
	end;
end;