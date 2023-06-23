--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).

	Clockwork was created by Conna Wiles (also known as kurozael.)
	http://cloudsixteen.com/license/clockwork.html
--]]

local COMMAND = Clockwork.command:New("SalesmanAdd");

COMMAND.tip = "Добавить продавца на позицию Вашего курсора.";
COMMAND.text = "[номер_анимации]";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "1";
COMMAND.optionalArguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	player.cwSalesmanSetup = true;
	player.cwSalesmanAnim = tonumber(arguments[1]);
	player.cwSalesmanHitPos = player:GetEyeTraceNoCursor().HitPos;
	
	if (!player.cwSalesmanAnim and type(arguments[1]) == "string") then
		player.cwSalesmanAnim = tonumber(_G[arguments[1]]);
	end;
	
	Clockwork.datastream:Start(player, "SalesmanAdd", true);
end;

COMMAND:Register();