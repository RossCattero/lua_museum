local Clockwork = Clockwork;
local cwCTO = cwCTO;

local COMMAND = Clockwork.command:New("CharSetBiosignalStatus");
COMMAND.tip = "Turn a character's biosignal on or off.";
COMMAND.text = "<string Name> <bool Enabled>";
COMMAND.access = "o";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local ply = Clockwork.player:FindByID(arguments[1]);

	if (ply) then
		local bEnable = Clockwork.kernel:ToBool(arguments[2]);
		local result = cwCTO:SetPlayerBiosignal(ply, bEnable);
	
		if (result == cwCTO.ERROR_NOT_COMBINE) then
			Clockwork.player:Notify(player, ply:Name() .. " не юнит ГО или ОТА!");
		elseif (result == cwCTO.ERROR_ALREADY_ENABLED) then
			Clockwork.player:Notify(player, ply:Name() .. " уже включил биосигнал!");
		elseif (result == cwCTO.ERROR_ALREADY_DISABLED) then
			Clockwork.player:Notify(player, ply:Name() .. " уже отключил биосигнал!");
		else
			Clockwork.player:Notify(player, "Вы " .. (bEnable and "enabled" or "disabled") .. " биосигнал " .. ply:Name() .. ".");
		end;
	else
		Clockwork.player:Notify(player, arguments[1].." не валидный персонаж!");
	end;
end;

COMMAND:Register();
