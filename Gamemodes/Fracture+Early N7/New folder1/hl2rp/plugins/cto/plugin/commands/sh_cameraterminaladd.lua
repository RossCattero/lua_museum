local COMMAND = Clockwork.command:New("CameraTerminalAdd");
COMMAND.tip = "Add a camera terminal at your target position.";
COMMAND.alias = {"Camter"};
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "a";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local trace = player:GetEyeTraceNoCursor();
	local entity = ents.Create("cw_ctocameraterminal");
	
	entity:SetPos(trace.HitPos);
	entity:Spawn();
	
	if ( IsValid(entity) ) then
		entity:SetAngles(Angle(0, player:EyeAngles().yaw + 180, 0));
		
		Clockwork.player:Notify(player, "Вы добавили терминал.");
	end;
end;

COMMAND:Register();