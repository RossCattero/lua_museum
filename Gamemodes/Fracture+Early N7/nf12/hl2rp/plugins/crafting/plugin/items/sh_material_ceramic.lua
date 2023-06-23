local ITEM = Clockwork.item:New();
ITEM.name = "Керамика";
ITEM.model = "models/fallout/components/ceramic.mdl";
ITEM.weight = 0.8;
ITEM.uniqueID = "materials_ceramic";
ITEM.category = "Прочее";

function ITEM:OnDrop(player, position) end;

ITEM:Register();