--[[
	� CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local CLASS = Clockwork.class:New("Администратор");
	CLASS.color = Color(255, 200, 100, 255);
	CLASS.factions = {FACTION_ADMIN};
	CLASS.isDefault = true;
CLASS_ADMIN = CLASS:Register();