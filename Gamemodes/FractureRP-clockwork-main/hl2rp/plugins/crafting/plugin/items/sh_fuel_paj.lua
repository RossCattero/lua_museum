local ITEM = Clockwork.item:New();
ITEM.name = "Топливо для паяльника";
ITEM.uniqueID = "ross_pajalnek_fuel";
ITEM.model = "models/props_junk/battery.mdl";
ITEM.value = 0.5;
ITEM.category = "Материалы";

function ITEM:OnDrop(player, position) end;

ITEM:Register();