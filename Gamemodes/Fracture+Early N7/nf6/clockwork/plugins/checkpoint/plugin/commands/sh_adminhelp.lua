
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;
local cwOption = Clockwork.option;

local COMMAND = Clockwork.command:New("AdminHelp");
COMMAND.tip = "Попросить администрацию о помощи.";
COMMAND.text = "<текст>";
COMMAND.flag = CMD_DEFAULT;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if (Clockwork.player:IsAdmin(player)) then
		player:CPNotify("Вы один из администраторов, используйте /a.", cwOption:GetKey("cannot_do_icon"));
		return;
	end;
	
	local curTime = CurTime();
	if (player.nextAdminHelp and player.nextAdminHelp > curTime) then
		player:CPNotify("Пожалуйста, подождите ещё "..math.ceil(player.nextAdminHelp - curTime).." секунд, прежде чем использовать команду снова.", cwOption:GetKey("wait_icon"));
		return;
	end;

	player.nextAdminHelp = curTime + Clockwork.config:Get("admin_help_interval"):Get();

	local listeners = PLUGIN:GetAllAdmins();
	if (#listeners == 0) then
		player:CPNotify("Нет администрации онлайн, пожалуйста, подождите пока они водйут.", "award_star_delete");
	end;

	listeners[#listeners + 1] = player;

	Clockwork.chatBox:Add(listeners, player, "cp_adminhelp", table.concat(arguments, " "));
end;

COMMAND:Register();