local ITEM = Clockwork.item:New();
ITEM.name = "Инструменты для починки";
ITEM.model = "models/clutter/toolbox.mdl";
ITEM.weight = 0.3;
ITEM.uniqueID = "armor_toolbox";
ITEM.category = "Прочее";

function ITEM:OnDrop(player, position) end;

ITEM:Register();