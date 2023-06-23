--[[
	© 2012 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local COMMAND = Clockwork.command:New("EmplacementAdd");
COMMAND.tip = "Добавить пулемёт на позицию Вашего курсора.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local trace = player:GetEyeTraceNoCursor();
	if (!trace.Hit) then return end

	local shouldDissolve = Clockwork.kernel:ToBool(arguments[1]);

	local emplacementGun = ents.Create("cw_emplacementgun");
	local entity = emplacementGun:SpawnFunction(player, trace)
	emplacementGun:Remove()
	
	if (IsValid(entity)) then
		Clockwork.player:Notify(player, "Вы добавили пулемёт.");
	end;
end;

COMMAND:Register();