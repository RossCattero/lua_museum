local PLUGIN = PLUGIN;

function PLUGIN:RenderScreenspaceEffects()
	local ply = LocalPlayer()
	local char = ply:getChar();
	if char then
		local head, default = ply:GetLimb(1), DefaultLimb(1)
		self.ColorModify = {}
		self.ColorModify["$pp_colour_brightness"] = 0;
		self.ColorModify["$pp_colour_contrast"] = math.Clamp(head/100, 0.3, 1);
		self.ColorModify["$pp_colour_colour"] = math.Clamp(head/100, 0.1, 1);
		self.ColorModify["$pp_colour_addr"] = 0;
		self.ColorModify["$pp_colour_addg"] = 0;
		self.ColorModify["$pp_colour_addb"] = 0;
		self.ColorModify["$pp_colour_mulr"] = 0;
		self.ColorModify["$pp_colour_mulg"] = 0;
		self.ColorModify["$pp_colour_mulb"] = 0;
		DrawMotionBlur( 
		head/100, 
		math.Clamp(default - head, 0, default)/10, 
		0.01 
	)
		DrawColorModify(self.ColorModify);
	end;
end;

function PLUGIN:HUDPaint()
		local ply = LocalPlayer()
		local sw, sh = ScrW(), ScrH()
		if IsValid(ply) && ply:getChar() && ply:getLocalVar("unconscious") then
				local space = input.LookupBinding( "+jump", true )

				if !timer.Exists("unconscious") then
						timer.Create("unconscious", 1, 20, function()
								if !IsValid(ply) || !ply:getLocalVar("unconscious") || !timer.Exists("unconscious") then timer.Remove("unconscious") return end;
						end)
				end

				draw.SimpleText( "You're unconsious...", "Unconsious", sw * 0.43, sh * 0.35, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
				if ply:getLocalVar("unc_giveup") then
						draw.SimpleText( "Press "..space.." to give up", "Unconsious", sw * 0.415, sh * 0.39, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
					else
						draw.SimpleText( "Time left: " .. timer.RepsLeft("unconscious"), "Unconsious", sw * 0.454, sh * 0.39, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
				end;
		end
end;

function PLUGIN:PlayerBindPress(client, bind, pressed)
		bind = bind:lower()
		if bind:find("jump") && client:getLocalVar("unconscious") && client:getLocalVar("unc_giveup") then
			netstream.Start('limbs::keyKill')
		end
end

netstream.Hook('limbs::openHealth', function(data, access)
		if PLUGIN.plyHealth && PLUGIN.plyHealth:IsValid() then
				PLUGIN.plyHealth:Close();
		end
		PLUGIN.plyHealth = vgui.Create("HealthPanel")
		PLUGIN.plyHealth:Populate(true, data, access)
end);