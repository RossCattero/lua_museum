local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("charSetSleep");
COMMAND.tip = "Set a player's Sleep Level.";
COMMAND.text = "<string Name> <number Amount>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "a";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID( arguments[1] )
	local amount = tonumber(arguments[2]);
	
	if (!amount) then
		amount = 100;
	end;
	
		if (target) then
			target:SetOneNeed( "sleep", amount )
			if ( player != target )	then
				Clockwork.player:Notify(target, player:Name().." изменил вашу усталость на "..amount..".");
				Clockwork.player:Notify(player, "Вы изменили усталость игрока "..target:Name().." на "..amount..".");
			else
				Clockwork.player:Notify(player, "Вы изменили свою усталость на "..amount..".");
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." не валидный игрок!");
		end;
end;

COMMAND:Register();