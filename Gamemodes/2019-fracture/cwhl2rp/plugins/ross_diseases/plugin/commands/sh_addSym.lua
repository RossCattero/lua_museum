local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("AddSym");
COMMAND.tip = "";
COMMAND.text = "<string Name> <Symtom>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "a";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID( arguments[1] )
	local sym = string.lower(arguments[2]);

		if (target && IsValidSympthom(sym) && !target:HasSym(sym)) then
			target:AddSympthom( sym )
			if ( player != target )	then
				Clockwork.player:Notify(target, player:Name().." добавил вам симптом "..sym..".");
				Clockwork.player:Notify(player, "Вы добавили симптом  "..sym.." игроку "..target:Name()..".");
			else
				Clockwork.player:Notify(player, "Вы добавили себе симптом "..sym..".");
			end;
		else
			Clockwork.player:Notify(player, target.." не валидный игрок или симптом!");
		end;
end;

COMMAND:Register();