local ITEM = Clockwork.item:New();
ITEM.name = "Бронежилет";
ITEM.model = "models/gibs/scanner_gib02.mdl";
ITEM.weight = 0.7;
ITEM.uniqueID = "armor_vest_clothes";
ITEM.category = "Прочее";

function ITEM:OnDrop(player, position) end;

ITEM:Register();