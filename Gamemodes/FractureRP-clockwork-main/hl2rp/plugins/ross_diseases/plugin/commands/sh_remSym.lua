local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("RemSym");
COMMAND.tip = "Удалить симптом у персонажа";
COMMAND.text = "<Имя> <симптом>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "a";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID( arguments[1] )
	local sym = string.lower(arguments[2]);
	local syms = player:GetCharacterData("Sympthoms");

		if (target && IsValidSympthom(sym) && target:HasSym(sym)) then
			target:RemSym( sym )
			if ( player != target )	then
				Clockwork.player:Notify(target, player:Name().." убрали ваш симптом "..sym..".");
				Clockwork.player:Notify(player, "Вы убрали симптом  "..sym.." игроку "..target:Name()..".");
			else
				Clockwork.player:Notify(player, "Вы убрали себе симптом "..sym..".");
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." не валидный игрок или "..sym.." не валидный симптом!");
		end;
end;

COMMAND:Register();