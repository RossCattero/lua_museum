local ITEM = Clockwork.item:New();
ITEM.name = "Кострюля";
ITEM.model = "models/props_interiors/pot02a.mdl";
ITEM.weight = 1.6;
ITEM.uniqueID = "little_potty";
ITEM.category = "Прочее";

function ITEM:OnDrop(player, position) end;

function ITEM:CanPickup(player, quickUse, entity)
    return false;
end;

ITEM:Register();