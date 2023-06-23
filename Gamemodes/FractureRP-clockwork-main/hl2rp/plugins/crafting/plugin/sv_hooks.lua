
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

PLUGIN.nextCraftingStationCheck = 60;

local CurTime = CurTime;
local ipairs = ipairs;

function PLUGIN:ItemEntityTakeDamage(entity, itemTable, damageInfo)
	if (itemTable and itemTable("craftingStation")) then
		damageInfo:ScaleDamage(0);
		return true;
	end;
end;