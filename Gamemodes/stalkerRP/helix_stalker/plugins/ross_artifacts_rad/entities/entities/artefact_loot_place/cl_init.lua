include("shared.lua");

local glowMaterial = Material("sprites/light_glow02_add");

-- Called when the entity should draw.
function ENT:Draw()
	local lvl = self:GetLevel();
	local player = LocalPlayer(); 
	local Distance = player:GetPos():Distance(self:GetPos())

	if Distance > 526 then
		return;
	end;

	local char = player:GetCharacter();
	local inv = char:GetInventory()
	local callout = inv:HasItem("detector_callout");
	local bear = inv:HasItem("detector_bear");
	local veles = inv:HasItem("detector_veles")
	local svarog = inv:HasItem("detector_svarog")

	local CanSeeLvL = (callout && callout:GetData('toggled') && callout.level) or 
	( bear && bear:GetData('toggled') && bear.level) or 
	(veles && veles:GetData('toggled') && veles.level) or 
	(svarog && svarog:GetData('toggled') && svarog.level) or 0;

	if CanSeeLvL < lvl then
		return;
	end;

	local position = self:GetPos();
	local glowColor = Color(0, 255, 0, 255);

	if lvl == 1 then
		glowColor = Color(100, 255, 100)
	elseif lvl == 2 then
		glowColor = Color(100, 100, 255)
	elseif lvl == 3 then
		glowColor = Color(255, 100, 100)
	elseif lvl == 4 then
		glowColor = Color(255, 125, 0)
	end;
		
	
	cam.Start3D(EyePos(), EyeAngles());
		render.SetMaterial(glowMaterial);
		render.DrawSprite(position, 100, 100, glowColor);
	cam.End3D();
end;