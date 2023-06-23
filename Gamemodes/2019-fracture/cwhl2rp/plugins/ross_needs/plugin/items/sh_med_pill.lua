local ITEM = Clockwork.item:New();
ITEM.name = "Очищающая таблетка";
ITEM.model = "models/foodnhouseholdaaaaa/combirationa.mdl";
ITEM.weight = 0.1;
ITEM.uniqueID = "med_pill";
ITEM.category = "Прочее";

function ITEM:OnDrop(player, position) end;

ITEM:Register();