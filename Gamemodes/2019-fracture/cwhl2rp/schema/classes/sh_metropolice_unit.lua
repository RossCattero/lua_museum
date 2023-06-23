--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local CLASS = Clockwork.class:New("Гражданская Оборона");
	CLASS.color = Color(50, 100, 150, 255);
	CLASS.wages = 20;
	CLASS.factions = {FACTION_MPF};
	CLASS.isDefault = true;
	CLASS.wagesName = "Денежное Довольствие";
	CLASS.description = "Регулярный юнит ГО.";
	CLASS.defaultPhysDesc = "Wearing a metrocop jacket with a radio";
CLASS_MPU = CLASS:Register();