-- ITEM META START --
local ITEM = ix.meta.item or {}

function ITEM:GetWeight()
	return self:GetData("weight", nil) or self.weight or 0.1
end

ix.meta.item = ITEM
-- ITEM META END --

-- CHARACTER META START --
local CHAR = ix.meta.character or {}

function CHAR:Overweight()
	return self:GetData("carry", 0) > ix.config.Get("maxWeight", 30) + self:GetData('additionalWeight')
end

function CHAR:CanCarry(item)
	return ix.weight.CanCarry(item:GetWeight() or 0.1, self:GetData("carry", 0))
end

function CHAR:AddWeight(number)
	return self:SetData('additionalWeight', math.Clamp(self:GetData('additionalWeight') + number, 0, 1000))
end;

function CHAR:CanRemWeight(number)
	return self:GetData("carry", 0) < (ix.config.Get("maxWeight", 30) + number) - number
end;

function CHAR:RemWeight(number)
	return self:SetData('additionalWeight', math.Clamp(self:GetData('additionalWeight') - number, 0, 1000))
end;

function CHAR:AddCarry(item)
	self:SetData("carry", math.Clamp(self:GetData("carry") + item:GetWeight(), 0, 10000))
end

function CHAR:RemoveCarry(item)
	if !IsValid(item.entity) then
		self:SetData("carry",  math.Clamp(self:GetData("carry") - item:GetWeight(), 0, 10000))
	end;
end

function CHAR:DropWeight(weight)
	self:SetData("carry", math.max(self:GetData("carry", 0) - weight, 0))
end

ix.meta.char = CHAR
-- CHARACTER META END --
