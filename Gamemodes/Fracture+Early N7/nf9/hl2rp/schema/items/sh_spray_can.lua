--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();

ITEM.name = "Балончик с краской";
ITEM.uniqueID = "spray_can";
ITEM.model = "models/sprayca2.mdl";
ITEM.weight = 0.5;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();