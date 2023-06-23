local ITEM = Clockwork.item:New("repair_base");
ITEM.name = "Спрей для очистки";
ITEM.model = "models/props_junk/junk_wd43.mdl";
ITEM.uniqueID = "repair_wd43";
ITEM.weight = 0.3;
ITEM.toolsQuality = 100;
ITEM.repairPlus = 10;
ITEM.weaponAllowed = {
	assault = true,
	shotgun = true,
	pistols = true,
	melee = true
};
ITEM.minimumToRepair = 80;

ITEM:Register();