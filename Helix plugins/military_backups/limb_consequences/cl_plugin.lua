local PLUGIN = PLUGIN

UNCONS = 1;

function PLUGIN:RenderScreenspaceEffects()
	local ply = LocalPlayer()
	local char = ply:GetCharacter();
	local limbs = ply:GetLocalVar("Limbs")
	local bio = ply:GetLocalVar("Biology")
	if char && limbs && bio then
		if bio.hurt > 10 || bio.blood < 3000 then
			DrawMotionBlur( 1 - bio.hurt/100, 2, 0.01 )
		end;

		self.ColorModify = {}
		if ply:GetLocalVar("UnCons") then
			UNCONS = math.Approach(UNCONS, 0, FrameTime() * 1)
			self.ColorModify["$pp_colour_contrast"] = UNCONS
		else
			self.ColorModify["$pp_colour_contrast"] = math.Clamp(1 - #limbs["head"] * 0.7, 0.2, 1);
			self.ColorModify["$pp_colour_colour"] = math.Clamp(0.7 - ((bio.blood * 0.0001) - LIMB.MIN_BLOOD_G), 0, 1);
		end;

		DrawColorModify(self.ColorModify);
	end;
end;