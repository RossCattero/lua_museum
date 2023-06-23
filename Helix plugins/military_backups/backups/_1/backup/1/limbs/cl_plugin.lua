local PLUGIN = PLUGIN;

function PLUGIN:LoadFonts(font, genericFont)
	surface.CreateFont("limb-text", {
		font = "Consolas",
		size = ScreenScale(5.5),
		scanlines = 1,
		antialias = true,
		extended = true,
	})
end;

DMG_COOLDOWN = 0;

BALPHA = 0;
ALPHA = 0;
ADD_CD = 10;
ADD_SECONDS = 1;
ADD_TIME = 0.07

function PLUGIN:HUDPaint()
		local ply = LocalPlayer();
		local sw, sh = ScrW(), ScrH();
		if !ply:GetCharacter() then return end;

		if (DMG_COOLDOWN && DMG_COOLDOWN < CurTime()) then return end;
		local bData = ply:GetLocalVar("Limbs")
		local blood = math.Round(ply:GetLocalVar("Blood"), 2);
		local bloodDrop = math.Round(ply:GetLocalVar("BloodDrop"), 2);
		if !bData then return end;

		local clearUP = DMG_COOLDOWN - ADD_CD/2 < CurTime();

		if ix.bar.Get("health") then ix.bar.Remove("health") end;
		if ix.bar.Get("armor") then ix.bar.Remove("armor") end; 

		local limbs = LimbBody;

		BALPHA = Lerp(ADD_TIME, BALPHA, clearUP && 0 || 150 )

		surface.SetMaterial( dropMat )
		surface.SetDrawColor(Color(150, 50, 50, BALPHA))
		surface.DrawTexturedRect( sw * 0.06, sh * 0.055, sw * 0.011, sh * 0.020 )

		local drop = bloodDrop > 0 && " -"..bloodDrop.." ml/sec" || ""
		
		draw.SimpleText(blood.." ml "..drop, "limb-text", sw * 0.072, sh * 0.057, Color(200, 50, 50, BALPHA), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

		local body = limbs["body"]
		surface.SetMaterial( body )
		surface.SetDrawColor(Color(255, 255, 255, BALPHA))
		surface.DrawTexturedRect( sw * 0, sh * 0.050, body:Width(), body:Height() )	

		if clearUP then return end;

		local i = #limbs;
		while (i >= 1) do
			local mat = limbs[i];
			if mat then
					local name = mat:GetName():match("materials/limbs/([%w_]+)")
					if bData[name] then
							surface.SetMaterial( mat )
							surface.SetDrawColor(Color(255, 0, 0, math.min(#bData[name] * 65, 200) ))
							surface.DrawTexturedRect( sw * 0, sh * 0.050, mat:Width(), mat:Height() )
					end
			end;
			i = i - 1;
		end;
end;

netstream.Hook('limbs::GotDamage', function()
		DMG_COOLDOWN = CurTime() + ADD_CD;
end);

-- PrintTable(LocalPlayer():GetLocalVar("Limbs"))
-- print("----")