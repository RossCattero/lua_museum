local ITEM = Clockwork.item:New("repair_base");
ITEM.name = "Точильный камень";
ITEM.model = "models/props_debris/concrete_chunk05g.mdl";
ITEM.uniqueID = "repair_rock";
ITEM.weight = 0.4;
ITEM.toolsQuality = 100;
ITEM.repairPlus = 14;
ITEM.weaponAllowed = {
	assault = false,
	shotgun = false,
	pistols = false,
	melee = true
};
ITEM.minimumToRepair = 65;

ITEM:Register();