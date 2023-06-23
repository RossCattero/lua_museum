
local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("CharSetTox");
COMMAND.tip = "Set a player's toxins level.";
COMMAND.text = "<string Name> [number Amount]";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";
COMMAND.arguments = 1;
COMMAND.optionalArguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);
	local amount = arguments[2]
	
	if (!amount) then
		amount = 0;
	else
		amount = math.Clamp(tonumber(amount), 0, 1000);
	end;
	
	if (target) then
		target:SetCharacterData("Toxins", amount);
		target:SetSharedVar("Toxins", amount);
		if (player != target) then
			Clockwork.player:Notify(target, player:Name().." изменил ваше количество РАД на "..amount..".");
			Clockwork.player:Notify(player, "Вы изменили количество РАД "..target:Name().." на "..amount..".");
		else
			Clockwork.player:Notify(player, "Вы изменили количество РАД на "..amount..".");
		end;
	else
		Clockwork.player:Notify(player, arguments[1].." не игрок!");
	end;
end;

COMMAND:Register();