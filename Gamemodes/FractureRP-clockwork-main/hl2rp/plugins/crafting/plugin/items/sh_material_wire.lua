local ITEM = Clockwork.item:New();
ITEM.name = "Моток проводов";
ITEM.model = "models/fallout/components/spool_1.mdl";
ITEM.weight = 0.2;
ITEM.uniqueID = "material_wires";
ITEM.category = "Прочее";

function ITEM:OnDrop(player, position) end;

ITEM:Register();