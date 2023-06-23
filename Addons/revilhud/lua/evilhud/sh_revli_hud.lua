local blockedElements = {
	CHudSecondaryAmmo = true,
	CHudVoiceStatus = true,
	CHudSuitPower = true,
	CHudCrosshair = true,
	CHudBattery = true,
	CHudHealth = true,
	CHudAmmo = true,
	CHudChat = true

};
hook.Add( "HUDShouldDraw", "RevilHudHideALL", function(name)
	if (blockedElements[name]) then
		return false;
	end;
end)

local mat = Material('materials/umbrella.png')
local function custom_compass_GetMetricValue( units )
	local meters = math.Round( units * 0.01905 )
	local kilometers = math.Round( meters / 1000, 2 )
	return ( kilometers > 1 ) && kilometers.."km" || meters.."m"
end
local function custom_compass_DrawLineFunc( mask1, mask2, line, color )
	render.ClearStencil() -- This is being ran alot
	render.SetStencilEnable( true )
		render.SetStencilFailOperation( STENCILOPERATION_KEEP )
		render.SetStencilZFailOperation( STENCILOPERATION_KEEP )
		render.SetStencilPassOperation( STENCILOPERATION_REPLACE)
		render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )
		render.SetStencilWriteMask( 1 )
		render.SetStencilReferenceValue( 1 )
		surface.SetDrawColor( Color( 0, 0, 0, 1 ) )
		surface.DrawRect( mask1[1], mask1[2], mask1[3], mask1[4] ) -- left
		surface.DrawRect( mask2[1], mask2[2], mask2[3], mask2[4] ) -- right
		render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
		render.SetStencilTestMask( 1 )
		surface.SetDrawColor( color )
		surface.DrawLine( line[1], line[2], line[3], line[4] )
	render.SetStencilEnable( false )
end

local sw, sh = ScrW(), ScrH()
local h = 0; local a = 0; 
local adv_compass_tbl = {
	[0] = "N",
	[45] = "NE",
	[90] = "E",
	[135] = "SE",
	[180] = "S",
	[225] = "SW",
	[270] = "W",
	[315] = "NW",
	[360] = "N"
}
local triangle = {{x = sw * 0.2604, y = sh}, {x = sw * 0.2604, y = sh * 0.86}, {x = sw * 0.33, y = sh}}
local triangle2 = {{x = sw * 0.73, y = sh}, {x = sw * 0.8074, y = sh * 0.86}, {x = sw * 0.8072, y = sh}}
hook.Add( "HUDPaint", "RevilHud", function()
	local ply =  LocalPlayer(); local health = ply:Health(); local maxhealth = ply:GetMaxHealth();
	local armor = ply:Armor(); local maxarmor = 100;
	local ang = ply:GetAngles();

	if ply:Alive() then

	local compassX, compassY = sw * 0.53, sh * 0.95
	local width, height = sw * 0.40, sh * 0.03
	local color = Color(255, 255, 255)
	local minMarkerSize, maxMarkerSize = sh * ( 100 / 45 ), sh * ( 100 / 45 )
	local spacing = ( width * 1 ) / 360
	local numOfLines = width / spacing
	local fadeDistance = (width / 2) / 1
	local text = math.Round( 360 - ( ang.y % 360 ) )
	local font = 'DermaDefault';
	local weapon = ply:GetActiveWeapon();

	h = math.Approach( h, (sw * 0.245)*(health/maxhealth), 300 * FrameTime() )
	a = math.Approach( a, (sw * 0.245)*(armor/maxarmor), 300 * FrameTime() )

	surface.SetDrawColor( 0, 0, 0, 150 )
	surface.DrawRect( 0, sh * 0.86, sw * 0.2605, sh * 0.15 )
	surface.SetDrawColor( 0, 0, 0, 150 )
	draw.NoTexture()
	surface.DrawPoly( triangle )

	surface.SetDrawColor( 0, 0, 0, 150 )
	surface.DrawRect( sw * 0.8075, sh * 0.86, sw * 0.2605, sh * 0.15  )

	surface.SetDrawColor( 0, 0, 0, 150 )
	draw.NoTexture()
	surface.DrawPoly( triangle2 )

	if (weapon:IsValid()) then
		if ply:GetAmmoCount(weapon:GetPrimaryAmmoType()) > 0 || weapon:Clip1() > -1 then
			if weapon:Clip1() > -1 then
				draw.SimpleText( tostring(weapon:Clip1()).."/"..tostring(ply:GetAmmoCount(weapon:GetPrimaryAmmoType())), "CloseCaption_Bold", sw * 0.8075, sh * 0.86, color_white )
			else
				draw.SimpleText( tostring(ply:GetAmmoCount(weapon:GetPrimaryAmmoType())), "CloseCaption_Bold", sw * 0.8075, sh * 0.86, color_white )
			end;
		end
	end
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( mat )
	surface.DrawTexturedRect( sw * 0.925, sh * 0.87, sw * 0.07, sh * 0.12 )

	draw.SimpleText( ply:Name(), "DermaDefaultBold", sw * 0.005, sh * 0.87, color_white )
	draw.SimpleText( team.GetName(ply:Team()), "DermaDefaultBold", sw * 0.005, sh * 0.89, color_white )

	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawRect( 0, sh * 0.925, sw * 0.245, 25 )
	surface.SetDrawColor( 255, 0, 0, 255 )
	surface.DrawRect( 0, sh * 0.925, h, 25 )
	draw.SimpleText( health, "CloseCaption_Bold", sw * 0.25, sh * 0.925, Color(255, 100, 100) )

	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawRect( 0, sh * 0.96, sw * 0.245, 25 )
	surface.SetDrawColor( 0, 0, 255, 255 )
	surface.DrawRect( 0, sh * 0.96, a, 25 )
	draw.SimpleText( armor, "CloseCaption_Bold", sw * 0.25, sh * 0.955, Color(100, 100, 255) )
	-- COMPASS ВЗЯТ И АДАПТИРОВАН У https://steamcommunity.com/sharedfiles/filedetails/?id=1452363997 (RAVEN) --
	
	surface.SetFont( font )
	surface.SetTextColor( color )
	surface.SetTextPos( compassX - 9, compassY )
	surface.DrawText( text )
	for i = ( math.Round( ang.y ) - numOfLines/2 ) % 360, ( ( math.Round( ang.y ) - numOfLines/2 ) % 360 ) + numOfLines do
		local x = ( compassX + ( width/2 * 1 ) ) - ( ( ( i - ang.y - 5 ) % 360 ) * spacing )
		local value = math.abs( x - compassX )
		local calc = 1 - ( ( value + ( value - fadeDistance ) ) / ( width/2 ) )
		local calculation = 255 * math.Clamp( calc, 0.001, 1 )
		if i % 15 == 0 && i > 0 then
			local text = adv_compass_tbl[360 - (i % 360)] && adv_compass_tbl[360 - (i % 360)] || 360 - (i % 360)
			local font = type( text ) == "string" && 'DermaDefault' || 'DermaDefault'
			local w, h = 18, 13
			surface.SetDrawColor( Color( color.r, color.g, color.b, calculation ) )
			surface.SetTextColor( Color( color.r, color.g, color.b, calculation ) )
			surface.SetFont( font )
			local mask1 = { compassX - width/2 - fadeDistance, compassY, width/2 + fadeDistance - 18, height * 2 }
			local mask2 = { compassX + 18, compassY, width/2 + fadeDistance - 18, height * 2 }
			local col = Color( color.r, color.g, color.b, calculation )
			local line = { x, compassY, x, compassY + height * 0.5 }
			custom_compass_DrawLineFunc( mask1, mask2, line, col )
			surface.SetTextPos( x - w/2, compassY + height * 0.55 )
			surface.DrawText( text )
			local mask1 = { compassX - width/2 - fadeDistance, compassY, width/2 + fadeDistance - 18, height * 2 }
			local mask2 = { compassX + 18, compassY, width/2 + fadeDistance - 18, height * 2 }
			local col = Color( color.r, color.g, color.b, calculation )
			local line = { x, compassY, x, compassY + height * 0.5 }
			custom_compass_DrawLineFunc( mask1, mask2, line, col )
		end
		if i % 5 == 0 && i % 15 != 0 then
			local mask1 = { compassX - width/2 - fadeDistance, compassY, width/2 + fadeDistance - 18, height }
			local mask2 = { compassX + 18, compassY, width/2 + fadeDistance - 18, height }
			local col = Color( color.r, color.g, color.b, calculation )
			local line = { x, compassY, x, compassY + height * 0.35 }
			custom_compass_DrawLineFunc( mask1, mask2, line, col )
		end
	end
	-- COMPASS ВЗЯТ И АДАПТИРОВАН У https://steamcommunity.com/sharedfiles/filedetails/?id=1452363997 (RAVEN) -- 
	end
end);


hook.Add( "ScoreboardShow", "REVIL_SCOREBOARDSHOW", function()
	return true;
end)
hook.Add( "ScoreboardHide", "REVIL_SCOREBOARDHIDE", function()
	return true;
end)

--[[
	3. Разобраться с азимутом. Он, похоже, немного сломан.
	4. Разобраться с ТАБом.
	5. Сделать ему эту панель инвентаря.
]]