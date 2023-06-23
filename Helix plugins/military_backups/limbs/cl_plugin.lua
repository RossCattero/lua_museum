local PLUGIN = PLUGIN

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

		local clearUP = DMG_COOLDOWN - LIMB.ADD_CD/2 < CurTime();

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


function PLUGIN:GetPlayerEntityMenu(client, options)
	if client == LocalPlayer() then return end;
	local char = LocalPlayer():GetCharacter();
	local id = char:GetID();
	local reco = client:GetNetVar("reco", {})

	if reco[id] || client:GetNetVar("restricted") || client:GetNetVar("Wounded") then
		options["Осмотреть"] = true;
	end;
end;

function PLUGIN:SendLimbAction(action, bone, injury)
	netstream.Start("LIMB_ACTION", action, bone, injury);
end;