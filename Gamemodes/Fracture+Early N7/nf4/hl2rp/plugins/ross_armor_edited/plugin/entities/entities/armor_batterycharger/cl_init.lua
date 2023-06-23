include("shared.lua");
local glowMaterial = Material("sprites/glow04_noz");

-- Called when the entity should draw.
function ENT:Draw()
	self:DrawModel();

	local position = self:GetPos();
	local forward = self:GetForward() * 8;
	local right = self:GetRight() * 1;
	local up = self:GetUp() * 11;
	local glowColor = Color(0, 0, 0, 255);

	-- if self:GetBattery() then
	-- 	glowColor = Color(100, 100, 255);
	-- elseif !self:GetBattery() then
	-- 	glowColor = Color(100, 255, 100);
	-- end;

	-- if self:GetIsCharging() then
	-- 	glowColor = Color(100, 255, 100);
	-- end;

	if !self:GetBattery() || !self:GetIsCharging()  then
		glowColor = Color(100, 255, 100);
	elseif self:GetBattery() || self:GetIsCharging() then
		glowColor = Color(100, 100, 255);
	end;
		
	cam.Start3D(EyePos(), EyeAngles());
		render.SetMaterial(glowMaterial);
		render.DrawSprite(position + forward + right + up, 20, 20, glowColor);
	cam.End3D();
end;