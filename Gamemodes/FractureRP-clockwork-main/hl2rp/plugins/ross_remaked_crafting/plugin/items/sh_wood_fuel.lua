local ITEM = Clockwork.item:New();
ITEM.name = "Кусок доски";
ITEM.model = "models/props_debris/wood_chunk06a.mdl";
ITEM.weight = 0.6;
ITEM.uniqueID = "fuel_wood";
ITEM.category = "Прочее";

function ITEM:OnDrop(player, position) end;

function ITEM:CanPickup(player, quickUse, entity)
    return false;
end;

ITEM:Register();