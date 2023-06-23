include("shared.lua");
local glowMaterial = ix.util.GetMaterial("sprites/glow04_noz")

-- Called when the entity should draw.
function ENT:Draw()
	self:DrawModel();

	local player = LocalPlayer(); 
	local Distance = player:GetPos():Distance(self:GetPos())
	local position = self:GetPos() + (self:GetUp() * 9) + (self:GetForward() * 12) + (self:GetRight() * -4);
	local glowColor = Color(255, 255, 255)

	if Distance > 526 then
		return;
	end;

	if self:GetTerminalCard() then
		glowColor = Color(100, 200, 100)
	end;
		
	cam.Start3D(EyePos(), EyeAngles());
		render.SetMaterial(glowMaterial);
		render.DrawSprite(position, 10, 10, glowColor);
	cam.End3D();

end;

function ENT:GetEntityMenu(client)
	local options = {};
	options["Открыть интерфейс"] = "terminal_open";
	if self:GetTerminalCard() then
		options["Достать карточку"] = "terminal_take_card";
	end;
	return options
end;