local ITEM = Clockwork.item:New();
ITEM.name = "Деревянная щепка";
ITEM.model = "models/props_debris/wood_splinters01e.mdl";
ITEM.weight = 0.2;
ITEM.uniqueID = "materials_wood_spl";
ITEM.category = "Прочее";

function ITEM:OnDrop(player, position) end;

ITEM:Register();