--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).

	Clockwork was created by Conna Wiles (also known as kurozael.)
	http://cloudsixteen.com/license/clockwork.html
--]]

local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("PlyRespawnStay");

COMMAND.tip = "Возродить персонажа на месте его смерти.";
COMMAND.text = "<имя_персонажа>";
COMMAND.arguments = 1;
COMMAND.access = "a";
COMMAND.alias = {"PlyRStay"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);

	if (target) then
		Clockwork.player:LightSpawn(target, true, true, false);
		Clockwork.player:Notify(player, {"PlayerWasRespawnedToDeath", target:GetName()});
	else
		Clockwork.player:Notify(player, {"NotValidTarget", arguments[1]});
	end;
end;

COMMAND:Register();