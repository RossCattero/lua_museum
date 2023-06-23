local ITEM = Clockwork.item:New();
ITEM.name = "Коробка с шурупами";
ITEM.model = "models/fallout/components/box.mdl";
ITEM.weight = 0.3;
ITEM.uniqueID = "materials_pails";
ITEM.category = "Прочее";

function ITEM:OnDrop(player, position) end;

ITEM:Register();