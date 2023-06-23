include("shared.lua");

surface.CreateFont( "BackGround", {
	font = "Default", 
	weight = 700,
} )

local mat1 = Material("Effects/combinedisplay001a")
local mat2 = Material( "Effects/tvscreen_noise002a" )

-- Called when the entity should draw.
function ENT:Draw()
	self:DrawModel()

	if self:GetTurn() == true then
	local fix_angles = self:GetAngles()
	local fix_rotation = Vector(90, 90, 180)

	fix_angles:RotateAroundAxis(fix_angles:Right(), fix_rotation.x)
	fix_angles:RotateAroundAxis(fix_angles:Up(), fix_rotation.y)
	fix_angles:RotateAroundAxis(fix_angles:Forward(), fix_rotation.z)

 	local target_pos = self:GetPos() + (self:GetUp() * 11) + self:GetForward() * 6.3

	cam.Start3D2D(target_pos, fix_angles, 0.2)

		local pos1, pos2 = -145, -125;
		local x, y = 285, 170;

		if self:Health() != 0 then 
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( mat1 )
			surface.DrawTexturedRect( pos1, pos2, x, y )

			draw.SimpleTextOutlined( "Номер: #"..self:GetNumberDone(), "Default", x - 420, y - 290, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ) )

			if self:GetTimeLeft() == 0 then
				draw.SimpleTextOutlined( "<:: Вы можете вызвать юнита ГО! ::>", "Default", x - 390, y - 220, Color(0, 150, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ) )
			elseif self:GetTimeLeft() > 0 then
				draw.SimpleTextOutlined( "<:: Юнита ГО нельзя вызывать еще "..self:GetTimeLeft().." секунд! ::>", "Default", x - 415, y - 220, Color(150, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ) )
			end;

			if self:Health() < 45 then
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.SetMaterial( mat2 )
				surface.DrawTexturedRect( pos1, pos2, x, y )
			end;
		end;
		if self:Health() < 10 then

			surface.SetDrawColor(0, 0, 0)
			surface.DrawRect(pos1, pos2, x, y)

			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( mat2 )
			surface.DrawTexturedRect( pos1, pos2, x, y )

			draw.SimpleTextOutlined( "<:: ОШИБКА ОТОБРАЖЕНИЯ ::>", "Default", x - 370, y - 220, Color(255, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ) )

		end;

	cam.End3D2D()
	end;
	
end;