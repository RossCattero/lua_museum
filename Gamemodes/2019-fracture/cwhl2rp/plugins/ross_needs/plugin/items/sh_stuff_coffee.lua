local ITEM = Clockwork.item:New();
ITEM.name = "Банка кофе";
ITEM.model = "models/bioshockinfinite/xoffee_mug_closed.mdl";
ITEM.weight = 0.5;
ITEM.uniqueID = "coffee";
ITEM.category = "Прочее";

function ITEM:OnDrop(player, position) end;

ITEM:Register();