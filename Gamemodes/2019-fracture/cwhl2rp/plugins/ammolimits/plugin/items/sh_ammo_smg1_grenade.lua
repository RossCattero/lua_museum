
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("ammo_base");
	ITEM.name = "Подствольная граната";
	ITEM.model = "models/items/ar2_grenade.mdl";
	ITEM.weight = 1;
	ITEM.category = "Боеприпасы";	
	ITEM.uniqueID = "ammo_smg1_grenade";
        ITEM.useSound = "items/ammo_pickup.wav";
	ITEM.ammoClass = "smg1_grenade";
	ITEM.ammoAmount = 1;
	ITEM.description = "Патроновидный подствольный патрон.";
ITEM:Register();