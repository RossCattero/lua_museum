local ITEM = Clockwork.item:New();
ITEM.name = "Стальной поддон";
ITEM.model = "models/props_debris/metal_panel02a.mdl";
ITEM.weight = 1.3;
ITEM.uniqueID = "materials_metal_podd";
ITEM.category = "Прочее";

function ITEM:OnDrop(player, position) end;

ITEM:Register();