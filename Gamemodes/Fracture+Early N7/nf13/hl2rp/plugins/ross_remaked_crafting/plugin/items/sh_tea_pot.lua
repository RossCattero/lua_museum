local ITEM = Clockwork.item:New();
ITEM.name = "Чайник";
ITEM.model = "models/props_interiors/pot01a.mdl";
ITEM.weight = 1.5;
ITEM.uniqueID = "tea_pot";
ITEM.category = "Прочее";

function ITEM:OnDrop(player, position) end;

function ITEM:CanPickup(player, quickUse, entity)
    return false;
end;

ITEM:Register();