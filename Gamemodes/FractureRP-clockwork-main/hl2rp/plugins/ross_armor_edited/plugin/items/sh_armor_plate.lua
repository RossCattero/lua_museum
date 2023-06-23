local ITEM = Clockwork.item:New();
ITEM.name = "Бронепластина";
ITEM.model = "models/gibs/scanner_gib02.mdl";
ITEM.weight = 0.3;
ITEM.uniqueID = "armor_plate_refiller";
ITEM.category = "Починка";

function ITEM:OnDrop(player, position) end;
ITEM:Register();