local littleButtonBackgronud = Material( "materials/textures/char_fraction_money_little.png" )
local littleButtonTextBack = Material( "materials/textures/char_fraction_money.png" )

local flameModify = { -- Жарка
	['$pp_colour_brightness'] = 0.59,
	['$pp_colour_contrast'] = 0.3,
	["$pp_colour_colour"] = 1,
	["$pp_colour_addr"] = 1,
	["$pp_colour_addg"] = 0.5,
	["$pp_colour_addb"] = 0
}
local psyModify = { -- Пси-поле
	['$pp_colour_brightness'] = 0.59,
	['$pp_colour_contrast'] = 0.3,
	["$pp_colour_colour"] = 1,
	["$pp_colour_addr"] = 0.3,
	["$pp_colour_addg"] = 0.3,
	["$pp_colour_addb"] = 0
}
local toxinsModify = { -- Токсины
	['$pp_colour_brightness'] = 0.59,
	['$pp_colour_contrast'] = 0.3,
	["$pp_colour_colour"] = 1,
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0.5,
	["$pp_colour_addb"] = 0.2
	
}

function Schema:RenderScreenspaceEffects()
	local plyArea = (LocalPlayer():GetLocalVar('isInArea', {}));

	if LocalPlayer():GetCharacter() then
		self.ColorModify = {}
		self.ColorModify["$pp_colour_brightness"] = 0;
		self.ColorModify["$pp_colour_contrast"] = 1;
		self.ColorModify["$pp_colour_colour"] = math.Clamp(LocalPlayer():Health()/100, 0.1, 0.8);
		self.ColorModify["$pp_colour_addr"] = 0;
		self.ColorModify["$pp_colour_addg"] = 0;
		self.ColorModify["$pp_colour_addb"] = 0;
		self.ColorModify["$pp_colour_mulr"] = 0;
		self.ColorModify["$pp_colour_mulg"] = 0;
		self.ColorModify["$pp_colour_mulb"] = 0;

		if plyArea.type == 'Жарка' then
			self.ColorModify["$pp_colour_addr"] = flameModify["$pp_colour_addr"]
			self.ColorModify["$pp_colour_addg"] = flameModify["$pp_colour_addg"]
			self.ColorModify["$pp_colour_addb"] = flameModify["$pp_colour_addb"]
		elseif plyArea.type == 'Пси-поле' then
			self.ColorModify["$pp_colour_addr"] = psyModify["$pp_colour_addr"]
			self.ColorModify["$pp_colour_addg"] = psyModify["$pp_colour_addg"]
			self.ColorModify["$pp_colour_addb"] = psyModify["$pp_colour_addb"]
			if !LocalPlayer().psySound or CurTime() >= LocalPlayer().psySound then
				LocalPlayer().psySound = CurTime() + 14;
				surface.PlaySound("psy/psy_voices_1_l.wav")
			end;
		elseif plyArea.type == 'Токсины' then
			self.ColorModify["$pp_colour_addr"] = toxinsModify["$pp_colour_addr"]
			self.ColorModify["$pp_colour_addg"] = toxinsModify["$pp_colour_addg"]
			self.ColorModify["$pp_colour_addb"] = toxinsModify["$pp_colour_addb"]
		end;

		if plyArea.type == {} then
			self.ColorModify["$pp_colour_addr"] = 0
			self.ColorModify["$pp_colour_addg"] = 0
			self.ColorModify["$pp_colour_addb"] = 0
		end;

		DrawColorModify(self.ColorModify);
	end;
end;

local tab = {
	["pp_colormod"]	= 1,
	["pp_colormod_addb"] = 0,
	["pp_colormod_addg"] = 0,
	["pp_colormod_addr"] =	0,
	["pp_colormod_brightness"] = -2,
	["pp_colormod_color"] = 0.000000,
	["pp_colormod_contrast"] =	1,
	["pp_colormod_mulb"] = 0,
	["pp_colormod_mulg"] = 0,
	["pp_colormod_mulr"] = 0
}

local cachedMaterials = {
	["outfit_respirator"] = {
		Material("materials/hud/helm_tactic1.png"),
		Material("materials/hud/helm_tactic2.png"),
		Material("materials/hud/helm_tactic3.png"),
		Material("materials/hud/helm_tactic4.png")
	},
	["outfit_respirator_2"] = {
		Material("materials/hud/helm_tactic1.png"),
		Material("materials/hud/helm_tactic2.png"),
		Material("materials/hud/helm_tactic3.png"),
		Material("materials/hud/helm_tactic4.png")
	},
	["outfit_exo_mono"] = {
		Material("materials/hud/helm_exo1.png"),
		Material("materials/hud/helm_exo2.png"),
		Material("materials/hud/helm_exo3.png"),
		Material("materials/hud/helm_exo4.png")
	},
	["outfit_respirator_merc_helm"] = {
		Material("materials/hud/hud_merc1.png"),
		Material("materials/hud/hud_merc2.png"),
		Material("materials/hud/hud_merc3.png"),
		Material("materials/hud/hud_merc4.png")
	},
	["outfit_respirator_merc"] = {
		Material("materials/hud/hud_merc1.png"),
		Material("materials/hud/hud_merc2.png"),
		Material("materials/hud/hud_merc3.png"),
		Material("materials/hud/hud_merc4.png")
	},
	["outfit_respirator_skat"] = {
		Material("materials/hud/hud_mil1.png"),
		Material("materials/hud/hud_mil2.png"),
		Material("materials/hud/hud_mil3.png"),
		Material("materials/hud/hud_mil4.png")
	},
	["outfit_science"] = {
		Material("materials/hud/helm_scientific1.png"),
		Material("materials/hud/helm_scientific2.png"),
		Material("materials/hud/helm_scientific3.png"),
		Material("materials/hud/helm_scientific4.png")
	},
	["outfit_science_2"] = {
		Material("materials/hud/helm_scientific1.png"),
		Material("materials/hud/helm_scientific2.png"),
		Material("materials/hud/helm_scientific3.png"),
		Material("materials/hud/helm_scientific4.png")
	},
	["outfit_seva_dolg"] = {
		Material("materials/hud/hud_sci1.png"),
		Material("materials/hud/hud_sci2.png"),
		Material("materials/hud/hud_sci3.png"),
		Material("materials/hud/hud_sci4.png")
	},
	["outfit_seva_freedom"] = {
		Material("materials/hud/hud_sci1.png"),
		Material("materials/hud/hud_sci2.png"),
		Material("materials/hud/hud_sci3.png"),
		Material("materials/hud/hud_sci4.png")
	},
	["outfit_seva_killer"] = {
		Material("materials/hud/hud_sci1.png"),
		Material("materials/hud/hud_sci2.png"),
		Material("materials/hud/hud_sci3.png"),
		Material("materials/hud/hud_sci4.png")
	},
	["outfit_seva_mono"] = {
		Material("materials/hud/hud_sci1.png"),
		Material("materials/hud/hud_sci2.png"),
		Material("materials/hud/hud_sci3.png"),
		Material("materials/hud/hud_sci4.png")
	},
	["outfit_seva_sci"] = {
		Material("materials/hud/hud_sci1.png"),
		Material("materials/hud/hud_sci2.png"),
		Material("materials/hud/hud_sci3.png"),
		Material("materials/hud/hud_sci4.png")
	},
	["outfit_seva_seva"] = {
		Material("materials/hud/hud_sci1.png"),
		Material("materials/hud/hud_sci2.png"),
		Material("materials/hud/hud_sci3.png"),
		Material("materials/hud/hud_sci4.png")
	}
}

local SCREEN_DAMAGE_OVERLAY = Material("materials/textures/bloody_screen.png")

function Schema:HUDPaint()
	local sw, sh = ScrW(), ScrH();
	local ply = LocalPlayer()
	local overlay = ply:GetLocalVar("Mask_overlay", "")

	if ply:Alive() && ply:GetCharacter() then
		local inv = ply:GetCharacter():GetInventory();
		local damageFraction = 1 - ((1 / ply:GetMaxHealth()) * ply:Health())
		if !ix.option.Get("thirdpersonEnabled", false) && overlay != nil && overlay != "" && cachedMaterials[overlay][ math.Clamp(math.Round( 5 - inv:HasItem(overlay):CountQualityPercent()/25 ), 1, 4) ] then
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial(cachedMaterials[overlay][ math.Clamp(math.Round( 5 - inv:HasItem(overlay):CountQualityPercent()/25 ), 1, 4) ])
			surface.DrawTexturedRect( sw * 0, sh * 0, sw, sh )	
		end;
		if ply:Health() <= 70 then
			surface.SetDrawColor(255, 255, 255, math.Clamp(255 * damageFraction, 0, 255));
			DrawColorModify(tab)
			surface.SetMaterial(SCREEN_DAMAGE_OVERLAY);
			surface.DrawTexturedRect(0, 0, sw, sh);
		end;
	end;

end;

function Schema:CreateCharacterInfo( panel )
	local char = LocalPlayer():GetCharacter()
	local health = LocalPlayer():Health()
	local medicalatt = char:GetAttribute("medicine") or 0;
	local healthstr = ""

	local protectionInfo = LocalPlayer():GetLocalVar('ProtectionTable')

	if health >= 90 then
		healthstr = 'В порядке.'
		if medicalatt >= 9 then
			healthstr = health
		elseif medicalatt >= 6 then
			healthstr = healthstr..'(85-100)'
		end;
	elseif health >= 70 then
		healthstr = 'Царапина на теле.'
		if medicalatt >= 9 then
			healthstr = health
		elseif medicalatt >= 6 then
			healthstr = healthstr..'(68-85)'
		end;
	elseif health >= 50 then
		healthstr = 'Неглубокое ранение.'
		if medicalatt >= 9 then
			healthstr = health
		elseif medicalatt >= 6 then
			healthstr = healthstr..'(50-72)'
		end;
	elseif health >= 30 then
		healthstr = 'Среднее ранение.'
		if medicalatt >= 9 then
			healthstr = health
		elseif medicalatt >= 6 then
			healthstr = healthstr..'(33-49)'
		end;
	elseif health >= 10 then
		healthstr = 'Серьезное ранение.'
		if medicalatt >= 9 then
			healthstr = health
		elseif medicalatt >= 6 then
			healthstr = healthstr..'(10-29)'
		end;
	elseif health >= 0 then
		healthstr = 'Присмерти.'
		if medicalatt >= 9 then
			healthstr = health
		elseif medicalatt >= 6 then
			healthstr = healthstr..'(1-9)'
		end;
	end;

	local hpanel = panel:Add("ixListRow")
	hpanel:SetList(panel.list)
	hpanel:Dock(TOP)
	hpanel:SizeToContents()
	hpanel:SetLabelText("Здоровье")
	hpanel:SetText(healthstr)
	hpanel.label:SetFont("StalkerGraffitiFont")
	hpanel.text:SetFont("StalkerGraffitiFont")
	hpanel.label.Paint = function(s, w, h)
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( littleButtonBackgronud )
		surface.DrawTexturedRect( 0, 0, w, h )
	end;
	hpanel.text.Paint = function(s, w, h)
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( littleButtonTextBack )
		surface.DrawTexturedRect( 0, 0, w, h )
	end;

	for k, v in pairs(protectionInfo) do

		local protBar = panel:Add("Panel")
		protBar:Dock(TOP)
		protBar:DockMargin(0, 0, 0, 8)
		protBar.Paint = function(_, w, h) 
			surface.SetDrawColor(0, 0, 0, 150)
			surface.DrawRect(0, 0, w, h)
		end
		local barAmount = protBar:Add("Panel")
		barAmount:SetTall(22)
		barAmount:Dock(FILL)
		barAmount.Paint = function(s, w, h)
			local value = math.Clamp(v / 100, 0, 1)
			surface.SetDrawColor(100, 100, 255, 230)
			surface.DrawRect(2, 2, (w - 4) * value, h - 4)		
		end;
		local barName = protBar:Add("DLabel")
		barName:Dock(FILL)
		barName:SetText(k)
		barName:SetFont("StalkerGraffitiFont")
		barName:SetContentAlignment( 5 )
	end;
end;

function Schema:PopulateHelpMenu(tabs)
	tabs["voices"] = function(container)
		local classes = {}

		for k, v in pairs(Schema.voices.classes) do
			if (v.condition(LocalPlayer())) then
				classes[#classes + 1] = k
			end
		end

		if (#classes < 1) then
			local info = container:Add("DLabel")
			info:SetFont("ixSmallFont")
			info:SetText("You do not have access to any voice lines!")
			info:SetContentAlignment(5)
			info:SetTextColor(color_white)
			info:SetExpensiveShadow(1, color_black)
			info:Dock(TOP)
			info:DockMargin(0, 0, 0, 8)
			info:SizeToContents()
			info:SetTall(info:GetTall() + 16)

			info.Paint = function(_, width, height)
				surface.SetDrawColor(ColorAlpha(derma.GetColor("Error", info), 160))
				surface.DrawRect(0, 0, width, height)
			end

			return
		end

		table.sort(classes, function(a, b)
			return a < b
		end)

		for _, class in ipairs(classes) do
			local category = container:Add("Panel")
			category:Dock(TOP)
			category:DockMargin(0, 0, 0, 8)
			category:DockPadding(8, 8, 8, 8)
			category.Paint = function(_, width, height)
				surface.SetDrawColor(Color(0, 0, 0, 66))
				surface.DrawRect(0, 0, width, height)
			end

			local categoryLabel = category:Add("DLabel")
			categoryLabel:SetFont("ixMediumLightFont")
			categoryLabel:SetText(class:upper())
			categoryLabel:Dock(FILL)
			categoryLabel:SetTextColor(color_white)
			categoryLabel:SetExpensiveShadow(1, color_black)
			categoryLabel:SizeToContents()
			category:SizeToChildren(true, true)

			for command, info in SortedPairs(self.voices.stored[class]) do
				local title = container:Add("DLabel")
				title:SetFont("ixMediumLightFont")
				title:SetText(command:upper())
				title:Dock(TOP)
				title:SetTextColor(ix.config.Get("color"))
				title:SetExpensiveShadow(1, color_black)
				title:SizeToContents()

				local description = container:Add("DLabel")
				description:SetFont("ixSmallFont")
				description:SetText(info.text)
				description:Dock(TOP)
				description:SetTextColor(color_white)
				description:SetExpensiveShadow(1, color_black)
				description:SetWrap(true)
				description:SetAutoStretchVertical(true)
				description:SizeToContents()
				description:DockMargin(0, 0, 0, 8)
			end
		end
	end
end