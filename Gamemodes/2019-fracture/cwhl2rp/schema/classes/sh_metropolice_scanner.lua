--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local CLASS = Clockwork.class:New("Сканер Гражданской Обороны");
	CLASS.color = Color(50, 100, 150, 255);
	CLASS.factions = {FACTION_MPF};
	CLASS.description = "Сканер, помогающий ГО в вычислении нарушителей.";
	CLASS.defaultPhysDesc = "Making beeping sounds";
CLASS_MPS = CLASS:Register();