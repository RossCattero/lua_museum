local ITEM = Clockwork.item:New();
ITEM.name = "Большая кострюля";
ITEM.model = "models/props_c17/metalPot001a.mdl";
ITEM.weight = 1.6;
ITEM.uniqueID = "big_potty";
ITEM.category = "Прочее";

function ITEM:OnDrop(player, position) end;

function ITEM:CanPickup(player, quickUse, entity)
    return false;
end;

ITEM:Register();