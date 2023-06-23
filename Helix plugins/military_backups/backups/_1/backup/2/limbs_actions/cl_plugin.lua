local PLUGIN = PLUGIN

UNCONS = 1;

function PLUGIN:RenderScreenspaceEffects()
	local ply = LocalPlayer()
	local char = ply:GetCharacter();

	if !(ply && ply.GetCharacter && char) then
		return;
	end
	local limbs, hurt, blood = ply:GetLimbs(), ply:GetHurt(), ply:GetBlood()
	
	if hurt > 10 || blood < LIMBS.BLOOD_PERCENT then
		DrawMotionBlur( 1 - hurt/100, 2, 0.01 )
	end;

	self.ColorModify = {}
	if ply:GetLocalVar("Wounded__hard") then
		UNCONS = math.Approach(UNCONS, 0, FrameTime() * 1)
		self.ColorModify["$pp_colour_contrast"] = UNCONS
	else
		self.ColorModify["$pp_colour_contrast"] = math.Clamp(1 - #limbs["head"] * 0.25, 0.2, 1);
		self.ColorModify["$pp_colour_colour"] = math.Clamp(0.7 - ((blood * 0.0001) - LIMBS.MIN_BLOOD_G), 0, 1);
	end;

	DrawColorModify(self.ColorModify);
end;