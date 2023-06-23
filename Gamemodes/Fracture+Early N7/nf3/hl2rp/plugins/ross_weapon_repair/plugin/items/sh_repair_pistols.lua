local ITEM = Clockwork.item:New("repair_base");
ITEM.name = "Набор для починки пистолетов";
ITEM.model = "models/box_toolkit_3.mdl";
ITEM.uniqueID = "repair_pistol";
ITEM.weight = 0.6;
ITEM.toolsQuality = 100;
ITEM.repairPlus = 10;
ITEM.weaponAllowed = {
	assault = false,
	shotgun = false,
	pistols = true,
	melee = false
};
ITEM.minimumToRepair = 55;

ITEM:Register();