local COMMAND = Clockwork.command:New("Roll");
COMMAND.tip = "Вторым аргументом вводите небоевой навык, либо оставляйте аргумент пустым и тогда ролл будет рандомным.\nПервый аргумент предназначен для описания действия.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;
COMMAND.optionalArguments = 1;

function COMMAND:OnRun(player, arguments)
	local description = arguments[1];
	local skill = arguments[2];
	local randomPlace = math.random(20);

	if skill != "" then
		local skillValue = GetSkillValue(player, skill);
		Clockwork.chatBox:AddInRadius(player, "roll", "кинул кубики на действие: "..description.." для навыка "..skill.." и получил "..skillValue.."/20", player:GetPos(), Clockwork.config:Get("talk_radius"):Get());
	elseif skill == "" then
		Clockwork.chatBox:AddInRadius(player, "roll", "кинул кубики на действие: "..description.." на рандом и получил "..randomPlace.."/20", player:GetPos(), Clockwork.config:Get("talk_radius"):Get());
	end;
end;
COMMAND:Register();