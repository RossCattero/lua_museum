local ITEM = Clockwork.item:New("repair_base");
ITEM.name = "Набор для починки дробовиков";
ITEM.model = "models/box_toolkit_2.mdl";
ITEM.uniqueID = "repair_shotgun";
ITEM.weight = 0.5;
ITEM.toolsQuality = 100;
ITEM.repairPlus = 15;
ITEM.weaponAllowed = {
	assault = false,
	shotgun = true,
	pistols = false,
	melee = false
};
ITEM.minimumToRepair = 60;

ITEM:Register();