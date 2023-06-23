local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("charSetClean");
COMMAND.tip = "Set a player's Clean Level.";
COMMAND.text = "<string Name> <number Amount>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "o";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID( arguments[1] )
	local amount = tonumber(arguments[2]);
	
	if (!amount) then
		amount = 100;
	end;
	
		if (target) then
			target:SetNeed( "clean", amount )
			if ( player != target )	then
				Clockwork.player:Notify(target, player:Name().." изменил вашу жажду на "..amount..".");
				Clockwork.player:Notify(player, "Вы изменили жажду игрока "..target:Name().." на "..amount..".");
			else
				Clockwork.player:Notify(player, "Вы изменили свою жажду на "..amount..".");
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." не игрок!");
		end;
end;

COMMAND:Register();