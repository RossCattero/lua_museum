local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("RemDis");
COMMAND.tip = "";
COMMAND.text = "<string Name> <Disease>";
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
				Clockwork.player:Notify(player, "Вы добавили себе болезнь "..dis..".");
			end;
		else
			Clockwork.player:Notify(player, target.." не валидный игрок или болезнь!");
		end;
end;

COMMAND:Register();