local ITEM = Clockwork.item:New(nil, true);
ITEM.name = "books_base";
ITEM.uniqueID = "books_base";
ITEM.model = "models/props_lab/binderblue.mdl";
ITEM.weight = 50;
ITEM.useText = "Прочесть";
ITEM.category = "Книги";
ITEM.description = "";
ITEM.useSound = "items/ammopickup.wav";

ITEM.typeOfSkill = "";
ITEM.addToSkill = 0;
ITEM.addToInt = 0;

function ITEM:OnUse(player, itemEntity)
	local random = math.random(0, 50)
	local intellect, pr = Clockwork.attributes:Get(player, ATB_INTELLECT);
	local type_Of_skill, pr = Clockwork.attributes:Get(player, self.typeOfSkill);

	Clockwork.player:SetAction(player, "Read_Book", 10);
	Clockwork.player:ConditionTimer(player, 10, function()
		if (!player:Alive() || player:GetVelocity():Length() > 0) then
			return false;
		end;
		return true;
	end, function()
		if random + intellect > 40 then
			Clockwork.attributes:Update(player, ATB_INTELLECT, math.Clamp(intellect + self.addToInt, 0, 10))
			if type(self.typeOfSkill) == "table" then
				for k, v in pairs(self.typeOfSkill) do
					Clockwork.attributes:Update(player, v, math.Clamp(intellect + self.addToInt, 0, 10))
				end;
			elseif type(self.typeOfSkill) == "string" then
				Clockwork.attributes:Update(player, self.typeOfSkill, math.Clamp(intellect + self.addToInt, 0, 10))
			else 
				return false;
			end;
		else
			Clockwork.attributes:Update(player, self.typeOfSkill, math.Clamp(type_Of_skill + self.addToSkill/2, 0, 10))
		end;
		Clockwork.player:SetAction(player, "Read_Book", false);
	end);

	return false;
end;

function ITEM:OnDrop(player, position) 
end;

Clockwork.item:Register(ITEM);