local COMMAND = Clockwork.command:New("CleanUPFast");
COMMAND.tip = "Умыться из источника воды или раковины";
COMMAND.flags = CMD_DEFAULT;

function COMMAND:OnRun(player, arguments)
	local trace = player:GetEyeTraceNoCursor();
	local tE = trace.Entity

	if tE == "prop_physics" && te:GetModel() == "models/props_c17/FurnitureSink001a.mdl" && player:GetShootPos():Distance(trace.HitPos) <= 102 then
		
		Clockwork.player:SetAction(player, "cleanSelf", 10);
		Clockwork.player:EntityConditionTimer(player, tE, tE, 10, 102, function()
			return player:Alive() && player:GetSharedVar("IsTied") == 0;
		end, function(success)
			if (success) then
				player:SetNeed("clean", math.Clamp(player:GetNeed("clean") - math.random(1, 2.5), 0, 100));
			end;

			Clockwork.player:SetAction(player, "cleanSelf", false);
		end);		
	end;
end;

COMMAND:Register();