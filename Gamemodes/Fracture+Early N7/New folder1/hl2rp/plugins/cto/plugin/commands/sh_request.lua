local Clockwork = Clockwork;
local cwCTO = cwCTO;

local COMMAND = Clockwork.command:New("Request");
COMMAND.tip = "Request assistance from Civil Protection.";
COMMAND.text = "<string Text>";
COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_DEATHCODE);
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local isCityAdmin = (player:GetFaction() == FACTION_ADMIN);
	local isCombine = Schema:PlayerIsCombine(player);
	local text = table.concat(arguments, " ");

	if (text == "") then
		Clockwork.player:Notify(player, "Вы ввели недостаточное количество текста!");

		return;
	end;

	if (player:HasItemByID("request_device") or isCombine or isCityAdmin) then
		local curTime = CurTime();

		if (not player.nextRequestTime or isCityAdmin or isCombine or curTime >= player.nextRequestTime) then
			Schema:SayRequest(player, text);

			cwCTO:DispatchRequestSignal(player, text);

			if (not isCityAdmin and not isCombine) then
				player.nextRequestTime = curTime + 30;
			end;
		else
			Clockwork.player:Notify(player, "Вам запрещается запрашивать еще "..math.ceil(player.nextRequestTime - curTime).." секунд(ы)!");
		end;
	else
		Clockwork.player:Notify(player, "У вас нету устройства запроса!");
	end;
end;

COMMAND:Register();
