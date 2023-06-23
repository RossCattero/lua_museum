local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("RemDis");
COMMAND.tip = "Удалить болезнь у персонажа.";
COMMAND.text = "<Имя> <Болезнь>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "a";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID( arguments[1] )
	local dis = string.lower(arguments[2]);

		if (target && IsValidDisease(dis) && target:HasLocalDisease(dis)) then
			target:RemLocalDisease( dis )
			if ( player != target )	then
				Clockwork.player:Notify(target, player:Name().." убрал у вас болезнь "..dis..".");
				Clockwork.player:Notify(player, "Вы убрали болезнь  "..dis.." игроку "..target:Name()..".");
			else
				Clockwork.player:Notify(player, "Вы убрали болезнь "..dis.." у себя.");
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." не валидный игрок или "..dis.." не валидная болезнь!");
		end;
end;

COMMAND:Register();