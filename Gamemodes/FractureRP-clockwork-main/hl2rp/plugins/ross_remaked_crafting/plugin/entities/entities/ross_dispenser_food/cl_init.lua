include("shared.lua");
local glowMaterial = Material("sprites/glow04_noz");

function ENT:Draw()
	local position = self:GetPos();
	local forward = self:GetForward() * -6;
	local right = self:GetRight() * -8;
	local up = self:GetUp() * 10;
	local glowColor = Color(0, 0, 255, 255);

	if !self:GetRegimeTurned() then
		glowColor = Color(255, 100, 100, 255);
	end;
		
	cam.Start3D(EyePos(), EyeAngles());
		render.SetMaterial(glowMaterial);
		render.DrawSprite(position + forward + right + up, 20, 20, glowColor);
	cam.End3D();

end;