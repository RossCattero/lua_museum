include("shared.lua");
local glowMaterial = ix.util.GetMaterial("sprites/glow04_noz")
local glowColor = Color(255, 100, 100)

local glowColor2 = Color(100, 100, 255)

-- Called when the entity should draw.
function ENT:Draw()
	self:DrawModel();
	local player = LocalPlayer(); 
	local Distance = player:GetPos():Distance(self:GetPos())
	local pos = self:GetPos()
	if Distance > 526 then return; end;
	local posUp = self:GetUp()
	local posForward = self:GetForward()
	local posRight = self:GetRight();

	local level = self:GetLevel();
	local turned = self:GetTurned()

	if turned then
		glowColor = Color(100, 255, 100)
	else
		glowColor = Color(255, 100, 100)
	end;
	if level == 1 then
		glowColor2 = Color(29, 38, 216)		
	elseif level == 2 then
		glowColor2 = Color(181, 17, 46)
	elseif level == 3 then
		glowColor2 = Color(222, 249, 34)
	end;

	cam.Start3D(EyePos(), EyeAngles());
		render.SetMaterial(glowMaterial);
		render.DrawSprite((pos + posForward*5 + posRight*-10 + posUp*13.5), 10, 10, glowColor);

		render.DrawSprite((pos + posForward*5 + posRight*-10 + posUp*9), 10, 10, glowColor2);
	cam.End3D();
end;

function ENT:GetEntityMenu(client)
	local options = {};
	local char = client:GetCharacter();
	local inv = char:GetInventory()
	local turn = self:GetTurned();

	if inv:HasItem('factory_card') then
		if turn then
			options["Отключить раздатчик"] = "dispenser_turn";
		else
			options["Включить раздатчик"] = "dispenser_turn";
		end;
		options["Сменить уровень"] = "dispenser_turn";
	end;
	return options
end;

function ENT:Initialize() end;