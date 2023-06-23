local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("charSetHunger");
COMMAND.tip = "Set a player's Hunger Level.";
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
			target:SetOneNeed( "hunger", amount )
			if ( player != target )	then
				Clockwork.player:Notify(target, player:Name().." изменил ваш голод на "..amount..".");
				Clockwork.player:Notify(player, "Вы изменили голод игрока "..target:Name().." на "..amount..".");
			else
				Clockwork.player:Notify(player, "Вы изменили свой голод на "..amount..".");
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." не валидный игрок!");
		end;
end;

COMMAND:Register();