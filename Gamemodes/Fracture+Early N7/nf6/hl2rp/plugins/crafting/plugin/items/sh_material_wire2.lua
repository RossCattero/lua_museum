local ITEM = Clockwork.item:New();
ITEM.name = "Моток проволоки";
ITEM.model = "models/props_lab/solderingspool01a.mdl";
ITEM.weight = 0.2;
ITEM.uniqueID = "materials_wire2";
ITEM.category = "Прочее";

function ITEM:OnDrop(player, position) end;

ITEM:Register();