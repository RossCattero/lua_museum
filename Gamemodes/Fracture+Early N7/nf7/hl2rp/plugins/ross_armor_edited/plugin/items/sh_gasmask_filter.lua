local ITEM = Clockwork.item:New();
ITEM.name = "Фильтр";
ITEM.weight = 0.5;
ITEM.uniqueID = "item_respirator_filter";
ITEM.model = "models/teebeutel/metro/objects/gasmask_filter.mdl"

ITEM:AddData('FilterQuality', 1000, true);

ITEM:Register();