local COMMAND = Clockwork.command:New("Roll");
COMMAND.tip = "Не используйте данный ролл для боевых ситуаций и/или ситуаций, где нужно использовать навыки.";
COMMAND.flags = CMD_DEFAULT;

function COMMAND:OnRun(player, arguments)
	local random = math.random(100);

	Clockwork.chatBox:AddInRadius(player, "roll", "кинул кубики и получил "..random.."/100", player:GetPos(), Clockwork.config:Get("talk_radius"):Get());
end;
COMMAND:Register();