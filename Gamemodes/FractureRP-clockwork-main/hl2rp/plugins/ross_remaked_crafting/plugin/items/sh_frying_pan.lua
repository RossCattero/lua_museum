local ITEM = Clockwork.item:New();
ITEM.name = "Сковорода";
ITEM.model = "models/props_c17/metalPot002a.mdl";
ITEM.weight = 1.2;
ITEM.uniqueID = "frying_pan";
ITEM.category = "Прочее";

function ITEM:OnDrop(player, position) end;

function ITEM:CanPickup(player, quickUse, entity)
    return false;
end;

ITEM:Register();