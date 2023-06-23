local PLUGIN = PLUGIN;

function PLUGIN:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)
	if (!lightSpawn) then
		if (player:GetFaction() == FACTION_INCOG ) then
    		if (player:IsAdmin() && player:IsSuperAdmin()) then
        		player:SetCharacterData("PhysDesc", "[Administrator] This is not a RolePlay character.");
        		player:GodEnable();
      		else
        		player:SetCharacterData("PhysDesc", "[User] This is not a RolePlay character.");
    		end;
		else
			player:GodDisable();
		end;
	end;
end;