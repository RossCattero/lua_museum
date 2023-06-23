local ITEM = Clockwork.item:New();
ITEM.name = "Кусок ткани";
ITEM.model = "models/fallout/components/roll.mdl";
ITEM.weight = 0.1;
ITEM.uniqueID = "material_cloth";
ITEM.category = "Прочее";

function ITEM:OnDrop(player, position) end;

ITEM:Register();