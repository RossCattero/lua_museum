local ITEM = Clockwork.item:New();
ITEM.name = "Деревянные части";
ITEM.model = "models/fallout/components/wood.mdl";
ITEM.weight = 0.3;
ITEM.uniqueID = "materials_wood_p";
ITEM.category = "Прочее";

function ITEM:OnDrop(player, position) end;

ITEM:Register();