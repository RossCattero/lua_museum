local COMMAND = Clockwork.command:New("SetGlobalTemp");
COMMAND.tip = "";
COMMAND.flags = CMD_DEFAULT;
-- COMMAND.text = "<имя>";
COMMAND.access = "s";
COMMAND.arguments = 1;

local cwPlayer = Clockwork.player;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local num = tonumber(arguments[1])
	if isnumber(num) then
		Clockwork.kernel:SetSharedVar("Temperature", math.Clamp(num, -10, 25));
		Clockwork.chatBox:SendColored(player, Color(120, 255, 120), "Вы изменили температуру на "..num);
		if num > 19 then
			Clockwork.hint:SendCenterAll("Вы чувствуете, как становится теплее...", 15, Color(255, 120, 120));
		elseif num < 15 then
			Clockwork.hint:SendCenterAll("Вы чувствуете, как холодает на улице...", 15, Color(120, 120, 255));
		end;
	else
		Clockwork.chatBox:SendColored(player, Color(255, 120, 120), "Вы не указали число!");
	end;
end;

COMMAND:Register();