local ITEM = Clockwork.item:New();
ITEM.name = "Карман";
ITEM.model = "models/gibs/scanner_gib02.mdl";
ITEM.weight = 0.3;
ITEM.uniqueID = "clothes_pockets";
ITEM.category = "Прочее";

function ITEM:OnDrop(player, position) end;

ITEM:Register();