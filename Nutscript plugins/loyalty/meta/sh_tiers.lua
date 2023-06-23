local tier = nut.meta.tier or {}

tier.__index = tier

tier.title = "0"
tier.min = 0;
tier.max = 0;
tier.color = Color(0, 0, 0, 0);
tier.benefit = 0;

function tier:__tostring()
	return "Loyalty tier["..self.title.."]"
end

function tier:__eq( objectOther )
	return self:GetID() == objectOther:GetID()
end

nut.meta.tier = tier