include("shared.lua");
local glowMaterial = ix.util.GetMaterial("sprites/glow04_noz")
local clred = false

-- Called when the entity should draw.
function ENT:Draw()
	self:DrawModel();

	local player = LocalPlayer(); 
	local Distance = player:GetPos():Distance(self:GetPos())
	local position = self:GetPos() + (self:GetUp() * 13.5) + (self:GetForward() * 10) + (self:GetRight() * 2);
	-- local glowColor = Color(255, 255, 255)

	if Distance > 526 then
		return;
	end;

	if self:GetTurnedOn() then
		glowColor = Color(202, 206, 0)
	end;

	if self:GetHasACup() && self:GetCoffeeReady() then
		
		if !self.ShowImReady or self.ShowImReady <= CurTime() then
			clred = !clred
			if clred then
				glowColor = Color(3, 6, 172)
				print('asd')
			else
				glowColor = Color(51, 165, 81)
				print('aaa')
			end;

			self.ShowImReady = CurTime() + 1
		end;
	end;

	cam.Start3D(EyePos(), EyeAngles());
		render.SetMaterial(glowMaterial);
		render.DrawSprite(position, 10, 10, glowColor);
	cam.End3D();
end;