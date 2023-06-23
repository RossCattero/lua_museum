local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("Ant");
COMMAND.tip = "Antlion chat.";
COMMAND.text = "<string Msg>";
COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_DEATHCODE, CMD_FALLENOVER);
COMMAND.arguments = 1;

local soundTable = {
	"idle1",
	"idle2",
	"idle3",
	"idle4",
	"idle5"
};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if(PLUGIN:PlayerIsAntlion(player)) then
		local words = table.concat(arguments, " ");

		for k, v in pairs(_player.GetAll()) do
			if(PLUGIN:PlayerIsAntlion(v)) then
				Clockwork.chatBox:SendColored(v, Color(120, 250, 20, 255), "[Antlion] "..player:Name()..": "..words)
			end;
		end;

		player:EmitSound("npc/antlion/"..soundTable[math.random(1,#soundTable)]..".wav")
	else
		Clockwork.player:Notify("You're not an Antlion!")
	end;
end;

COMMAND:Register();