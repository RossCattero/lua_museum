
local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("getSkillValue");
COMMAND.tip = "Получить информацию о скиле";
COMMAND.text = "<Имя>";
COMMAND.flags = CMD_DEFAULT;
-- COMMAND.access = "";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local attribute = arguments[2]
	local attrNum, pr = Clockwork.attributes:Get(player, attribute);
	
	if player:IsAlive() && attrNum then
		Clockwork.chatBox:SendColored(player, Color(255, 100, 100), "Ваш уровень навыка "..attribute..": "..attrNum)
	end;
end;

COMMAND:Register();