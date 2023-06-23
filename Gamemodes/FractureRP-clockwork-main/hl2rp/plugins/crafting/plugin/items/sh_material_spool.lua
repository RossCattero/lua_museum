local ITEM = Clockwork.item:New();
ITEM.name = "Веревка";
ITEM.model = "models/fallout/components/spool_2.mdl";
ITEM.weight = 0.3;
ITEM.uniqueID = "materials_rope";
ITEM.category = "Прочее";

function ITEM:OnDrop(player, position) end;

ITEM:Register();