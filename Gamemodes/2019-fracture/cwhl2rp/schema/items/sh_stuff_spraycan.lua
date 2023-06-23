--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Баллончик с Краской";
ITEM.cost = 0;
ITEM.model = "models/sprayca2.mdl";
ITEM.weight = 0.3;
ITEM.access = "v";
ITEM.uniquieID = "spray_can";
ITEM.category = "Материалы";
ITEM.business = true;
ITEM.description = "Аэрозольный баллончик с остатками краски.";

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();