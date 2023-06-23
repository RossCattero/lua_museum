--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("weapon_base");

ITEM.name = "Фонарик";
ITEM.model = "models/lagmite/lagmite.mdl";
ITEM.weight = 0.8;
ITEM.category = "Прочее";
ITEM.uniqueID = "cw_flashlight";
ITEM.isFakeWeapon = true;
ITEM.isMeleeWeapon = true;
ITEM.description = "Черный фонарик с маленькой кнопкой наверху.";

ITEM:Register();