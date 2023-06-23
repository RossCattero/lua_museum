local h = 0;
hook.Add( "HUDPaint", "[ROSS]..HUDPaint", function()
    local sw, sh = ScrW(), ScrH()
    local health, maxhealth = LocalPlayer():Health(), LocalPlayer():GetMaxHealth();

    h = math.Approach( h, (sw * (470/sw))*(health/maxhealth), 300 * FrameTime() )

    surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawRect( sw * (10/sw), sh * (10/sh), sw * (470/sw), 25 )
	surface.SetDrawColor( 209, 182, 22, 255 )
	surface.DrawRect( sw * (10/sw), sh * (10/sh), h, 25 )
	draw.SimpleText( health, "CloseCaption_Bold", sw * (30 / sw), sh * (10 / sh), Color(255, 100, 100) )
end)