--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).

	Clockwork was created by Conna Wiles (also known as kurozael.)
	http://cloudsixteen.com/license/clockwork.html
--]]

--[[
	You don't have to do this, but I think it's nicer.
	Alternatively, you can simply use the PLUGIN variable.
--]]
PLUGIN:SetGlobalAlias("cwEmoteAnims");

--[[ You don't have to do this either, but I prefer to separate the functions. --]]
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");
Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");

-- Called when the Clockwork shared variables are added.
function cwEmoteAnims:ClockworkAddSharedVars(globalVars, playerVars)
	playerVars:Bool("StanceIdle", true);
	playerVars:Angle("StanceAng");
	playerVars:Vector("StancePos");
end;

-- A function to get whether a player is in a stance.
function cwEmoteAnims:IsPlayerInStance(player)
	return player:GetSharedVar("StancePos") != Vector(0, 0, 0);
end;

-- Called when a player starts to move.
function cwEmoteAnims:Move(player, moveData)
	if (self:IsPlayerInStance(player)) then
		player:SetAngles(player:GetSharedVar("StanceAng"));
		return true;
	end;
end;