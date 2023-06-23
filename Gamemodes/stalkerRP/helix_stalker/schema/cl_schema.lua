function draw.RoundedBoxOutlined( bordersize, x, y, w, h, color, bordercol )
	x, y, w, h = math.Round( x ), math.Round( y ), math.Round( w ), math.Round( h )
	draw.RoundedBox( bordersize, x, y, w, h, color )
	surface.SetDrawColor( bordercol )
	surface.DrawTexturedRectRotated( x + bordersize/2, y + bordersize/2, bordersize, bordersize, 0 ) 
	surface.DrawTexturedRectRotated( x + w - bordersize/2, y + bordersize/2, bordersize, bordersize, 270 ) 
	surface.DrawTexturedRectRotated( x + w - bordersize/2, y + h - bordersize/2, bordersize, bordersize, 180 ) 
	surface.DrawTexturedRectRotated( x + bordersize/2, y + h - bordersize/2, bordersize, bordersize, 90 ) 
	surface.DrawLine( x + bordersize, y, x + w - bordersize, y )
	surface.DrawLine( x + bordersize, y + h - 1, x + w - bordersize, y + h - 1 )
	surface.DrawLine( x, y + bordersize, x, y + h - bordersize )
	surface.DrawLine( x + w - 1, y + bordersize, x + w - 1, y + h - bordersize )
end;

function Schema:PlayerBindPress(player, bind, bPress)
    if string.find(bind, "+zoom") then
        return true;
    end;
end;