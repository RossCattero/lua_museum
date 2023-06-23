local ITEM = Clockwork.item:New();
ITEM.name = "Деревянный поддон";
ITEM.model = "models/props_junk/wood_pallet001a_old.mdl";
ITEM.weight = 1;
ITEM.uniqueID = "materials_wood_pallet";
ITEM.category = "Прочее";

function ITEM:OnDrop(player, position) end;

ITEM:Register();