local COMMAND = Clockwork.command:New("ToggleTP");

COMMAND.tip = "Включить вид от третьего лица.";
COMMAND.text = "<1/2>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if (player:Alive() and arguments[1] == "1") then
    player:SetThirdPerson(true);
elseif (player:Alive() and arguments[1] == "2") then
	player:SetThirdPerson(false);
else 
    Clockwork.player:Notify(player, "Вы не указали аргумент! [1/2]")	
    end;
end;

COMMAND:Register();