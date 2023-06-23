
ITEM.name = "Наборы починки"
ITEM.description = "Наборы починки"
ITEM.category = "Починка"
ITEM.model = "models/Gibs/HGIBS.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.weight = 0.3

ITEM.minrepair = 0
ITEM.repairAmount = 0
ITEM.repairType = "Оружие"
ITEM.weaponType = {
    assault = true,
    shotgun = true,
    pistol = true,
	submachine = true,
	melee = true
}
ITEM.armorType = {
	ekzo = true,
	seva = true,
	hard = true,
	medium = true,
	easy = true
}

ITEM.functions.OpenRepairKit = {
	name = "Использовать",
	OnRun = function(item)
		if item.repairType then
			netstream.Start(item.player, "OpenRepairKit", item.id, item.uniqueID)
		end;
		return false
	end,
	CanRun = function(item)
		return item.repairType && !IsValid(item.entity)
	end
}

function ITEM:OnInstanced()
	if !self:GetData('useamount') then
		self:SetData('useamount', self.usesAmount or 5)
	end;
end;

if CLIENT then
	function ITEM:PopulateTooltip(tooltip)
		if self.repairType then
			local row = tooltip:AddRowAfter("weight", "Info")
			row:SetText("Минимальное качество: "..self.minrepair.."\nЧинит: "..self.repairType)
			row:SetTextColor(color_white)
			row:SetExpensiveShadow(1, color_black)
			row:SizeToContents()
		end;
	end
end;