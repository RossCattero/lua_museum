local ITEM = Clockwork.item:New();
ITEM.name = "Большая пластина";
ITEM.model = "models/gibs/scanner_gib02.mdl";
ITEM.weight = 0.9;
ITEM.uniqueID = "bigplate";
ITEM.category = "Прочее";

function ITEM:OnDrop(player, position) end;

ITEM:Register();