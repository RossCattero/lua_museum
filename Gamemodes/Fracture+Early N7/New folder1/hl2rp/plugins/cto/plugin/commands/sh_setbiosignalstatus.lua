local Clockwork = Clockwork;
local cwCTO = cwCTO;

local COMMAND = Clockwork.command:New("SetBiosignalStatus");
COMMAND.tip = "Включение/Выключение Биосигнала. ВНИМАНИЕ! ОБ ЭТОМ ОПОВЕЩАЮТСЯ ВСЕ ЮНИТЫ!.";
COMMAND.text = "<0 - Выключить; 1 - Включить>";
COMMAND.alias = {"Vbio"};
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local bEnable = Clockwork.kernel:ToBool(arguments[1]);
	local result = cwCTO:SetPlayerBiosignal(player, bEnable);

	if (result == cwCTO.ERROR_NOT_COMBINE) then
		Clockwork.player:Notify(player, "Вы не юнит ГО или ОТА!");
	elseif (result == cwCTO.ERROR_ALREADY_ENABLED) then
		Clockwork.player:Notify(player, "Ваш биосигнал уже включен!");
	elseif (result == cwCTO.ERROR_ALREADY_DISABLED) then
		Clockwork.player:Notify(player, "Ваш биосигнал уже выключен!");
	end;
end;

COMMAND:Register();
