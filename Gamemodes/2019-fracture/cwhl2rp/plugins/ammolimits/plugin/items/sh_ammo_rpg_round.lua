
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("ammo_base");
	ITEM.name = "Ракета";
	ITEM.model = "models/weapons/w_missile_launch.mdl";
	ITEM.weight = 2;
	ITEM.uniqueID = "ammo_rpg_round";
	ITEM.category = "Боеприпасы";	
        ITEM.useSound = "items/ammo_pickup.wav";
	ITEM.ammoClass = "bp_rocket_ammo";
	ITEM.ammoAmount = 1;
	ITEM.description = "Оранжевая ракета с серой полосой и лазерным наведением.";
ITEM:Register();