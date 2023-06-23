local ITEM = Clockwork.item:New();
ITEM.name = "Чайный пакетик";
ITEM.model = "models/foodnhouseholdaaaaa/combirationa.mdl";
ITEM.weight = 0.01;
ITEM.uniqueID = "tea_bag";
ITEM.category = "Прочее";
ITEM.teabag = true;

function ITEM:OnDrop(player, position) end;

ITEM:Register();