--[[
	© 2014 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).

	Clockwork was created by Conna Wiles (also known as kurozael.)
	http://cloudsixteen.com/license/clockwork.html
--]]

local COMMAND = Clockwork.command:New("Anim");
COMMAND.tip = "Forced animation for character.";
COMMAND.text = "<string Name> <string Anim> [string Delay]";
COMMAND.access = "s";
COMMAND.arguments = 2;
COMMAND.optionalArguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	
	local target = Clockwork.player:FindByID(arguments[1])
	
	if (target) then
		if (target:Alive() and !target:IsRagdolled() and !target:IsNoClipping()) then
			local forcedAnimation = target:GetForcedAnimation();
			local anim = string.lower(arguments[2]);
			local delay = tonumber(arguments[3]) or 5;
			
			if (forcedAnimation) then
				cwEmoteAnims:MakePlayerExitStance(player);
			else
				target:SetForcedAnimation(anim, delay);
			end;
		else
			Clockwork.player:Notify(player, "Игрок не можете сделать это сейчас!");
		end;
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid character!");
	end;
end;

COMMAND:Register();