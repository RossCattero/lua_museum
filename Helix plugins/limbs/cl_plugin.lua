local PLUGIN = PLUGIN;
BALPHA = 0;
ALPHA = 0;
DMG_COOLDOWN = 0;

hook.Add("CreateMenuButtons", "rossArmorPlugin", function(tabs)
		tabs["injuries"] = {
		bHideBackground = false,
		Create = function(info, container)
			container.infoPanel = container:Add("Limbs")

			LIMBS_INT = container.infoPanel
		end
	}
end)

function PLUGIN:LoadFonts(font, genericFont)
	surface.CreateFont("limb-text", {
		font = "Consolas",
		size = ScreenScale(5.5),
		scanlines = 1,
		antialias = true,
		extended = true,
	})
	surface.CreateFont("limb-subtext", {
		font = "Candara",
		size = ScreenScale(8),
		scanlines = 1,
		antialias = true,
		extended = true,
	})
	surface.CreateFont("limb-empty", {
		font = "Consolas",
		size = ScreenScale(5),
		scanlines = 1,
		antialias = true,
		extended = true,
		italic = true,
	})
end;

function PLUGIN:HUDPaint()
		local ply = LocalPlayer();
		local sw, sh = ScrW(), ScrH();
		if !ply:GetCharacter() then return end;

		if (DMG_COOLDOWN && DMG_COOLDOWN < CurTime()) then return end;
		local bData = ply:GetLocalVar("Limbs")
		local bio = ply:GetLocalVar("Biology");
		local pain = ply:GetLocalVar("Hurt");
		local blood = math.Round(bio.blood, 2);
		local bloodDrop = math.Round(bio.bleeding, 2);
		if !bData then return end;

		local clearUP = DMG_COOLDOWN - LIMB_ADD_CD/2 < CurTime();

		if ix.bar.Get("health") then ix.bar.Remove("health") end;
		if ix.bar.Get("armor") then ix.bar.Remove("armor") end; 

		local limbs = LimbBody;

		BALPHA = Lerp(0.07, BALPHA, clearUP && 0 || 150 )

		surface.SetMaterial( dropMat )
		surface.SetDrawColor(Color(150, 50, 50, BALPHA))
		surface.DrawTexturedRect( sw * 0.06, sh * 0.055, sw * 0.011, sh * 0.020 )

		local drop = bloodDrop > 0 && "(-"..bloodDrop.." ml/sec)" || ""
		
		draw.SimpleText(blood.." ml"..drop, "limb-text", sw * 0.072, sh * 0.057, Color(200, 50, 50, BALPHA), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

		if pain then
				draw.SimpleText(pain, "limb-text", sw * 0.072, sh * 0.08, Color(200, 50, 50, BALPHA), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end

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
		DMG_COOLDOWN = CurTime() + LIMB_ADD_CD;
end);

function PLUGIN:RenderScreenspaceEffects()
	local ply = LocalPlayer()
	local char = ply:GetCharacter();
	if char && ply:GetLocalVar("Limbs") then
		local bio = ply:GetLocalVar("Biology")
		local limbs = ply:GetLocalVar("Limbs")
		if bio.hurt > 10 || bio.blood < 3000 then
			DrawMotionBlur( 1 - bio.hurt/100, 2, 0.01 )
		end;

		self.ColorModify = {}
		self.ColorModify["$pp_colour_brightness"] = 0;
		self.ColorModify["$pp_colour_contrast"] = 1 - #limbs["head"] * 0.7;
		self.ColorModify["$pp_colour_colour"] = math.Clamp(0.7 - ((bio.blood * 0.0001) - LIMB_MIN_BLOOD_G), 0, 1);
		self.ColorModify["$pp_colour_addr"] = 0;
		self.ColorModify["$pp_colour_addg"] = 0;
		self.ColorModify["$pp_colour_addb"] = 0;
		self.ColorModify["$pp_colour_mulr"] = 0;
		self.ColorModify["$pp_colour_mulg"] = 0;
		self.ColorModify["$pp_colour_mulb"] = 0;

		DrawColorModify(self.ColorModify);
	end;
end;

function PLUGIN:PlayerBindPress(ply, bind, press)
	if ( bind:find("jump") && ply:GetLocalVar("ragdoll") && ply:GetLocalVar("Biology").bleeding > 0 ) then
			return true
	end
end;