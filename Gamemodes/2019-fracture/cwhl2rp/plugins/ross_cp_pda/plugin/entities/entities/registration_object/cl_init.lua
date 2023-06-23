include("shared.lua");
local glowMaterial = Material("sprites/glow04_noz");

function ENT:Draw()
	self:DrawModel()
	local position = self:GetPos();
	local forward = self:GetForward() * 5;
	local right = self:GetRight() * 12;
	local up = self:GetUp() * 43;
	local glowColor = Color(0, 255, 0, 255);

	if self:GetAlert() then
		glowColor = Color(255, 100, 100, 255);
	end;
		
	cam.Start3D(EyePos(), EyeAngles());
		render.SetMaterial(glowMaterial);
		render.DrawSprite(position + forward + right + up, 20, 20, glowColor);
	cam.End3D();

end;