include("shared.lua");
local glowMaterial = Material("sprites/glow04_noz");

-- Called when the entity should draw.
function ENT:Draw()
	self:DrawModel();

	local r, g, b, a = self:GetColor();
	local rationTime = CurTime() + 2
	local flashTime = 5
	local curTime = CurTime();
	local position = self:GetPos();
	local forward = self:GetForward() * -5;
	local right = self:GetRight() * 0;
	local up = self:GetUp() * 9;
	
	if (rationTime > curTime) then
		local glowColor = Color(255, 100, 100, a);
		local timeLeft = rationTime - curTime;
		
		if (!self.nextFlash or curTime >= self.nextFlash or (self.flashUntil and self.flashUntil > curTime)) then
			cam.Start3D(EyePos(), EyeAngles());
				render.SetMaterial(glowMaterial);
				render.DrawSprite(position + forward + right + up, 20, 20, glowColor);
			cam.End3D();
			
			if (!self.flashUntil or curTime >= self.flashUntil) then
				self.nextFlash = curTime + (timeLeft / 4);
				self.flashUntil = curTime + (FrameTime() * 4);
				self:EmitSound("hl1/fvox/boop.wav");
			end;
		end;
	end;
end;