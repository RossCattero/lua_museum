local ITEM = Clockwork.item:New();
ITEM.name = "Изолента";
ITEM.model = "models/props_lab/solderingspool01b.mdl";
ITEM.weight = 0.2;
ITEM.uniqueID = "materials_tape";
ITEM.category = "Прочее";

function ITEM:OnDrop(player, position) end;

ITEM:Register();