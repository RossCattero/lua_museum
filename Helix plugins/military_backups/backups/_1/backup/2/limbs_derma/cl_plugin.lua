local PLUGIN = PLUGIN

BALPHA = 0;
ALPHA = 0;
DMG_COOLDOWN = 0;

local sw, sh = ScrW(), ScrH();

netstream.Hook('LIMB_DAMAGED', function()
	DMG_COOLDOWN = CurTime() + LIMBS.ADD_CD;
end);

netstream.Hook('CLOSE_LIMBS_UI', function()
	if IsValid(LIMBS.UI) then LIMBS.UI:Close() end
end);

netstream.Hook("OPEN_LIMBS_UI", function(data)
	LIMBS:OpenUI(data)
end)

function PLUGIN:PlayerButtonDown(client, button)
	if button == LIMBS.INT_KEY && !IsValid(LIMBS.UI) then
		timer.Create("CheckIntPress", .1, 1, function()
			if client:Alive() && input.IsKeyDown( LIMBS.INT_KEY ) && !IsValid(LIMBS.UI) then
				LIMBS:OpenUI()
			end
		end);
	end;
end;

function PLUGIN:HUDPaint()
	local ply = LocalPlayer()

	if !ply:GetCharacter() || (DMG_COOLDOWN && DMG_COOLDOWN < CurTime()) then return end;
	local limbs, bio = ply:GetLimbs(), ply:GetBIO()
	local blood, bleed = math.Round(ply:GetBlood(), 2), math.Round(ply:GetBleed(), 2);
	local clear = DMG_COOLDOWN - LIMBS.ADD_CD/2 < CurTime();
	local getPain = INJURIES.FindPain( ply:GetHurt() )

	BALPHA = Lerp(0.07, BALPHA, clear && 0 || 150 )

	draw.BloodDrop( sw * 0.06, sh * 0.055, sw * 0.011, sh * 0.020, BALPHA )
	draw.DrawBloodInfo(blood.." ml"..( bleed > 0 && "(-"..bleed.." ml/sec)" || "" ), BALPHA)
	if getPain && getPain.name then
		draw.PainInfo(getPain.name, BALPHA)
	end;
	draw.BodyLimb(sw * 0, sh * 0.050, nil, nil, BALPHA)

	if clear then return end;

	draw.BodyData( sw * 0, sh * 0.050 )
end;