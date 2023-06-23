local ITEM = Clockwork.item:New("repair_base");
ITEM.name = "Набор для починки штурмовых винтовок";
ITEM.model = "models/box_toolkit_1.mdl";
ITEM.uniqueID = "repair_assault";
ITEM.weight = 0.6;
ITEM.toolsQuality = 100;
ITEM.repairPlus = 15;
ITEM.weaponAllowed = {
	assault = true,
	shotgun = false,
	pistols = false,
	melee = false
};
ITEM.minimumToRepair = 60;

ITEM:Register();