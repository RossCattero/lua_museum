local COMMAND = Clockwork.command:New("EntAdd_1");
COMMAND.tip = "";
COMMAND.flags = CMD_DEFAULT;
-- COMMAND.text = "<имя>";
COMMAND.access = "o";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local trace = player:GetEyeTraceNoCursor();
	local entity = scripted_ents.Get("cw_locker"):SpawnFunction(player, trace)
	
    	if ( IsValid(entity) ) then
		
		Clockwork.player:Notify(player, "Вы добавили X.");
	    end;
end;

COMMAND:Register();