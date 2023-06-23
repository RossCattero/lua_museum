include("shared.lua");

-- Called when the entity should draw.
function ENT:Draw()
	self:DrawModel();
	local	pos = self:GetPos();
	local 	ang = self:GetAngles();

	ang:RotateAroundAxis( ang:Up(), 90 )
	ang:RotateAroundAxis( ang:Forward(), 90 )
	ang:RotateAroundAxis( ang:Right(), 180 )

	cam.Start3D2D( pos + ang:Up() * 0 + ang:Forward() * -20.5 + ang:Right() * -55, ang + Angle(0, 0, -28), 0.11 )
		local prefix = "CMD:> "
		local monWidth, monHeight = 324, 115;

		surface.SetDrawColor(0, 0, 0, 255)
    	surface.DrawRect(0, 0, monWidth, monHeight)
	
		draw.SimpleText( prefix, "DebugFixedSmall", 2, monHeight-10, color_white )
	cam.End3D2D()
end;