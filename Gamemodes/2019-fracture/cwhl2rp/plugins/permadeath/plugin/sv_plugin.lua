--[[
	© 2012 Iron-Wall.org do not share, re-distribute or modify
	without permission of its author (ext@iam1337.ru).
--]]

local PLUGIN = PLUGIN;

Clockwork.config:Add("permadeath_lifes", 5, true);
Clockwork.config:Add("permedeath_suicide", true);

function PLUGIN:SetUndeath(player, death)
	player:SetCharacterData("permakilled", death);
	player:SaveCharacter();
	player:SetSharedVar("permakilled", death);
end;

function PLUGIN:PlayerDropAllItems(player, ragdollEntity)
	if (IsValid(ragdollEntity)) then
		if (IsValid(player)) then
			ragdollEntity.cash = player:GetCash();
			ragdollEntity.cwInventory = player.cwCharacter.inventory;
			player.cwCharacter.inventory = {};
		end;
	end;
end;