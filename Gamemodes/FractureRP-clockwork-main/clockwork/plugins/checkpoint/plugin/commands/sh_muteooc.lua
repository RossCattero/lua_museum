local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("MuteOOC");
COMMAND.tip = "Заблокировать ООС чат для игрока.";
COMMAND.text = "<имя_персонажа>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "a";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);
	echo = Clockwork.config:Get("admin_echoes"):Get()
	if target then
		if (target.goocmuted) then
			target.goocmuted = false;
			if echo then
				Clockwork.player:NotifyAll("ООС игрока "..target:Name().." был разбанен администратором "..player:Name()..".");
			end
			if target.oocmuted then
				target.oocmuted = false;
				target.loocmuted = true;
			end
		else
			target.goocmuted = true;
			if echo then
				Clockwork.player:NotifyAll("ООС игрока "..target:Name().." был заблокирован администратором "..player:Name()..".");
			end
		end;
	else
		Clockwork.player:Notify(player, arguments[1].." - несуществующий игрок!");
	end;
end;

COMMAND:Register();