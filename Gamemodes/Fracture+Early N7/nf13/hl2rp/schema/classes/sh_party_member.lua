--[[
	� CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local CLASS = Clockwork.class:New("Член партии");
	CLASS.color = Color(255, 200, 100, 255);
	CLASS.factions = {FACTION_PARTYMEMBER};
	CLASS.isDefault = true;
CLASS_PARTYMEMBER = CLASS:Register();