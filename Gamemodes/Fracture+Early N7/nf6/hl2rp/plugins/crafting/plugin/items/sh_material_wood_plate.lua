local ITEM = Clockwork.item:New();
ITEM.name = "Доска";
ITEM.model = "models/props_debris/wood_board06a.mdl";
ITEM.weight = 0.5;
ITEM.uniqueID = "materials_wood";
ITEM.category = "Прочее";

function ITEM:OnDrop(player, position) end;

ITEM:Register();