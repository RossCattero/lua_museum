--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("ammo_base");
	ITEM.name = "Шар темной материи";
	ITEM.model = "models/items/combine_rifle_ammo01.mdl";
	ITEM.weight = 1;
	ITEM.uniqueID = "ammo_ar2altfire";
	ITEM.category = "Боеприпасы";	
	ITEM.ammoClass = "ar2altfire";
	ITEM.ammoAmount = 1;
        ITEM.useSound = "items/ammo_pickup.wav";
	ITEM.description = "Странный предмет с желтым свечением.";
ITEM:Register();