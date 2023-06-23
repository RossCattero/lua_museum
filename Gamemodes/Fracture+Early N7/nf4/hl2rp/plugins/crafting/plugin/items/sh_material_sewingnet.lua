local ITEM = Clockwork.item:New();
ITEM.name = "Нитки";
ITEM.model = "models/fallout/components/spool_2.mdl";
ITEM.weight = 0.1;
ITEM.uniqueID = "materials_sewing_net";
ITEM.category = "Прочее";

function ITEM:OnDrop(player, position) end;

ITEM:Register();