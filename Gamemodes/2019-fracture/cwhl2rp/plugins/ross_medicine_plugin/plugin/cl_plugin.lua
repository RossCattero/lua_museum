
local PLUGIN = PLUGIN;

-- Called when the local player's motion blurs should be adjusted.
function PLUGIN:PlayerAdjustMotionBlurs(motionBlurs)
	local player = Clockwork.Client;
	local HeadHealth = 100 - Clockwork.limb:GetHealth(HITGROUP_HEAD)

	motionBlurs.blurTable["blur"] = 1 - ( 0.025 * HeadHealth );
end;