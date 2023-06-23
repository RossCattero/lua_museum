local PLUGIN = PLUGIN

function PLUGIN:RenderScreenspaceEffects()
	local ply = LocalPlayer()

	if !ply:GetCharacter() then
		return;
	end

	local health = ply:Health();

	// If below 20 hp, every hp lost increases the blurriness of the screen by 1,5%. 
	if health < 20 then
		ix.util.DrawBlurAt(0, 0, ScrW(), ScrH(), (20 - health) * 0.015)

		// If below 20 hp, every hp lost decreases the saturation of the screen (so towards black/white) by 4%.
		self.ColorModify = {}
			self.ColorModify["$pp_colour_contrast"] = 1
			self.ColorModify["$pp_colour_colour"] = math.Clamp( health * 0.04, 0, 1 )
		DrawColorModify(self.ColorModify);
	end
end;