include("shared.lua");
local glowMaterial = ix.util.GetMaterial("sprites/glow04_noz")
local clred = false
local glowColor = Color(255, 0, 0)

-- Called when the entity should draw.
function ENT:Draw()
	self:DrawModel();

	local player = LocalPlayer(); 
	local Distance = player:GetPos():Distance(self:GetPos())
	local position = self:GetPos() + (self:GetUp() * 13.5) + (self:GetForward() * 5) + (self:GetRight() * -10);
	local lvl = self:GetLevel();
	local workable = self:GetWorkable();
	
	if Distance > 526 then return; end;

	if workable then
		if lvl == 1 then 
			glowColor = Color(29, 38, 216)
		elseif lvl == 2 then
			glowColor = Color(181, 17, 46)
		elseif lvl == 3 then
			glowColor = Color(222, 249, 34)
		end;
	end;

	cam.Start3D(EyePos(), EyeAngles());
		render.SetMaterial(glowMaterial);
		render.DrawSprite(position, 10, 10, glowColor);
	cam.End3D();
end;

function ENT:Initialize()
	local firstID = self:EntIndex()..' - FirstGlow';
	local workable = self:GetWorkable();

	timer.Create(firstID, 1, 0, function()
		if !IsValid(self) then timer.Remove(firstID) return; end;

		if !workable then
			if !clred then
				glowColor = Color(255, 0, 0)
				clred = true;
				-- surface.PlaySound('npc/turret_floor/deploy.wav')
			elseif clred then
				glowColor = Color(0, 0, 0)
				clred = false;
			end;
		end;
	end);	

end;