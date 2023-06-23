--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).

	Clockwork was created by Conna Wiles (also known as kurozael.)
	http://cloudsixteen.com/license/clockwork.html
--]]

local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("PlyReport");

COMMAND.tip = "Пожаловаться на игрока в Cloud Sixteen.";
COMMAND.text = "<имя_персонажа>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);
	
	if (target) then
		cwPlayerReport:Report(target);
		
		Clockwork.player:Notify(player, {"PlayerReported"});
	else
		Clockwork.player:Notify(player, {"NotValidPlayer", arguments[1]});
	end;
end;

COMMAND:Register();