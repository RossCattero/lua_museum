local PLUGIN = PLUGIN;

function PLUGIN:PlayerGiveWeapons(player)
	for k, v in pairs(vortiTable) do
		if (player:GetFaction() == FACTION_VORT) then
			Clockwork.player:GiveSpawnWeapon(player, "cw_vortibeam");
		end;
	end;
end;