
ITEM.name = "Outfit"
ITEM.description = "A Outfit Base."
ITEM.category = "Outfit"
ITEM.model = "models/Gibs/HGIBS.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.outfitCategory = "model"
ITEM.pacData = {}
ITEM.outfitInformation = {
    ['Радиация'] = 0, -- Защита от радиации
    ['Токсины'] = 0, -- Защита от токсинов
    ['Электричество'] = 0, -- Электроизоляция
    ['Температура'] = 0, -- Термоизоляция
    ['Пси-защита'] = 0, -- Пси защита
    ['Порез'] = 0, -- Защита от пореза
    ['Гашение урона'] = 0, -- Гашение урона(от пуль, ударов похоже)
    ['Повышение выносливости'] = 0 -- Выносливость
}
ITEM.additionalWeight = 0;

-- Inventory drawing
if (CLIENT) then
	function ITEM:PaintOver(item, w, h)
		if (item:GetData("equip")) then
			surface.SetDrawColor(110, 255, 110, 100)
			surface.DrawRect(w - 14, h - 14, 8, 8)
		end
	end
	function ITEM:PopulateTooltip(tooltip)
		local outfitData = self:GetData('outfit_info')
		local beforeRow = "weight"
		for k, v in pairs(outfitData or self.outfitInformation) do
			local row = tooltip:AddRowAfter(beforeRow, k)
			row:SetText("")
			
			local Bar = row:Add("Panel")
			Bar:Dock(TOP)
			Bar:DockMargin(6, 5, 5, 6)
			Bar.Paint = function(_, w, h) 
				surface.SetDrawColor(0, 0, 0, 150)
				surface.DrawRect(0, 0, w, h)
			end
			local barAmount = Bar:Add("Panel")
			barAmount:Dock(FILL)
			barAmount.Paint = function(s, w, h)
				local value = v / 100
				surface.SetDrawColor(100, 100, 255, 230)
				surface.DrawRect(2, 2, (w - 4) * value, h - 14)		
			end;

			local barName = Bar:Add("DLabel")
			barName:Dock(FILL)
			barName:SetText(k)
			barName:SetFont("StalkerGraffitiFontLittle")
			barName:SetContentAlignment( 8 )			

			beforeRow = k
		end;
	end;
end

function ITEM:RemoveOutfit(client)
	local character = client:GetCharacter()

	self:SetData("equip", false)
	character:RemWeight(self.additionalWeight)

	if self.maskOverlay then
		client:SetLocalVar("Mask_overlay", "")
	end;

	local p = self.player
	local protTable = p:GetLocalVar('ProtectionTable');
	local outInfo = self:GetData('outfit_info')
	for k, v in pairs(outInfo) do
		protTable[k] = math.Clamp(protTable[k] - outInfo[k], 0, 200)
	end;

	p:SetLocalVar('ProtectionTable', protTable)

	if (character:GetData("oldModel" .. self.outfitCategory)) then
		character:SetModel(character:GetData("oldModel" .. self.outfitCategory))
		character:SetData("oldModel" .. self.outfitCategory, nil)
	end

	if (self.newSkin) then
		if (character:GetData("oldSkin" .. self.outfitCategory)) then
			client:SetSkin(character:GetData("oldSkin" .. self.outfitCategory))
			character:SetData("oldSkin" .. self.outfitCategory, nil)
		else
			client:SetSkin(0)
		end
	end

	for k, _ in pairs(self.bodyGroups or {}) do
		local index = client:FindBodygroupByName(k)

		if (index > -1) then
			client:SetBodygroup(index, 0)

			local groups = character:GetData("groups", {})

			if (groups[index]) then
				groups[index] = nil
				character:SetData("groups", groups)
			end
		end
	end

	-- restore the original bodygroups
	if (character:GetData("oldGroups" .. self.outfitCategory)) then
		for k, v in pairs(character:GetData("oldGroups" .. self.outfitCategory, {})) do
			client:SetBodygroup(k, v)
		end

		character:SetData("groups", character:GetData("oldGroups" .. self.outfitCategory, {}))
		character:GetData("oldGroups" .. self.outfitCategory, nil)
	end

	if (self.attribBoosts) then
		for k, _ in pairs(self.attribBoosts) do
			character:RemoveBoost(self.uniqueID, k)
		end
	end

	for k, _ in pairs(self:GetData("outfitAttachments", {})) do
		self:RemoveAttachment(k, client)
	end

	self:OnUnequipped()
end

function ITEM:CountQualityPercent()
	local counted = 0;
	local hundredPercent = 0;
	local outInfo, buffer = self:GetData('outfit_info'), self:GetData("outfit_buffer")
	for k, v in pairs(outInfo) do
		counted = counted + v;
	end;
	for k, v in pairs(buffer) do
		hundredPercent = hundredPercent + v;
	end;
	
	return math.Round((counted * 100)/hundredPercent);
end;

-- makes another outfit depend on this outfit in terms of requiring this item to be equipped in order to equip the attachment
-- also unequips the attachment if this item is dropped
function ITEM:AddAttachment(id)
	local attachments = self:GetData("outfitAttachments", {})
	attachments[id] = true

	self:SetData("outfitAttachments", attachments)
end

function ITEM:RemoveAttachment(id, client)
	local item = ix.item.instances[id]
	local attachments = self:GetData("outfitAttachments", {})

	if (item and attachments[id]) then
		item:OnDetached(client)
	end

	attachments[id] = nil
	self:SetData("outfitAttachments", attachments)
end

ITEM:Hook("drop", function(item)
	if (item:GetData("equip") && item.player:GetCharacter():CanRemWeight(item.additionalWeight)) then
		item:RemoveOutfit(item:GetOwner())
	end
end)

ITEM.functions.EquipUn = { -- sorry, for name order.
	name = "Снять",
	tip = "equipTip",
	icon = "icon16/cross.png",
	OnRun = function(item)
		item:RemoveOutfit(item.player)
		return false
	end,
	OnCanRun = function(item)
		local client = item.player

		return !IsValid(item.entity) and IsValid(client) and item:GetData("equip") == true and
			hook.Run("CanPlayerUnequipItem", client, item) != false and item.invID == client:GetCharacter():GetInventory():GetID() &&
			item.player:GetCharacter():CanRemWeight(item.additionalWeight)
	end
}

ITEM.functions.Equip = {
	name = "Надеть",
	tip = "equipTip",
	icon = "icon16/tick.png",
	OnRun = function(item)
		local client = item.player
		local char = client:GetCharacter()
		local items = char:GetInventory():GetItems()

		for _, v in pairs(items) do
			if (v.id != item.id) then
				local itemTable = ix.item.instances[v.id]

				if (itemTable.pacData and v.outfitCategory == item.outfitCategory and itemTable:GetData("equip")) then
					client:NotifyLocalized(item.equippedNotify or "outfitAlreadyEquipped")
					return false
				end
			end
		end

		item:SetData("equip", true)
		char:AddWeight(item.additionalWeight)

		if (isfunction(item.OnGetReplacement)) then
			char:SetData("oldModel" .. item.outfitCategory, char:GetData("oldModel" .. item.outfitCategory, item.player:GetModel()))
			char:SetModel(item:OnGetReplacement(client))
		elseif (item.replacement or item.replacements) then
			char:SetData("oldModel" .. item.outfitCategory, char:GetData("oldModel" .. item.outfitCategory, item.player:GetModel()))

			if (istable(item.replacements)) then
				if (#item.replacements == 2 and isstring(item.replacements[1])) then
					char:SetModel(item.player:GetModel():gsub(item.replacements[1], item.replacements[2]))
				else
					for _, v in ipairs(item.replacements) do
						char:SetModel(item.player:GetModel():gsub(v[1], v[2]))
					end
				end
			else
				char:SetModel(item.replacement or item.replacements)
			end
		end

		if (item.newSkin) then
			char:SetData("oldSkin" .. item.outfitCategory, item.player:GetSkin())
			item.player:SetSkin(item.newSkin)
		end

		if (item.bodyGroups) then
			groups = {}

			for k, value in pairs(item.bodyGroups) do
				local index = item.player:FindBodygroupByName(k)

				if (index > -1) then
					groups[index] = value
				end
			end

			local newGroups = char:GetData("groups", {})

			for index, value in pairs(groups) do
				newGroups[index] = value
				item.player:SetBodygroup(index, value)
			end

			if (!table.IsEmpty(newGroups)) then
				char:SetData("groups", newGroups)
			end

		end

		if (item.attribBoosts) then
			for k, v in pairs(item.attribBoosts) do
				char:AddBoost(item.uniqueID, k, v)
			end
		end

		item:OnEquipped()
		return false
	end,
	OnCanRun = function(item)
		local client = item.player

		return !IsValid(item.entity) and IsValid(client) and item:GetData("equip") != true and item:CanEquipOutfit() and
			hook.Run("CanPlayerEquipItem", client, item) != false and item.invID == client:GetCharacter():GetInventory():GetID()
	end
}

function ITEM:CanTransfer(oldInventory, newInventory)
	if (newInventory and self:GetData("equip")) then
		return false
	end

	return true
end

function ITEM:OnRemoved()
	if (self.invID != 0 and self:GetData("equip")) then
		self.player = self:GetOwner()
			self:RemoveOutfit(self.player)
		self.player = nil
	end
end

function ITEM:OnEquipped()
	local p = self.player
	local protTable = p:GetLocalVar('ProtectionTable');
	local outInfo = self:GetData('outfit_info')
	for k, v in pairs(outInfo) do
		protTable[k] = math.Clamp(protTable[k] + outInfo[k], 0, 200)
	end;
	p:SetLocalVar('ProtectionTable', protTable)
	local mat = Material("materials/hud/helm_exo1.png"); print(mat)

	if self.maskOverlay then
		p:SetLocalVar("Mask_overlay", self.uniqueID )
	end;
end

function ITEM:OnUnequipped()
	local p = self.player
	local protTable = p:GetLocalVar('ProtectionTable');
	local outInfo = self:GetData('outfit_info')
	for k, v in pairs(outInfo) do
		protTable[k] = math.Clamp(protTable[k] - outInfo[k], 0, 200)
	end;
	p:SetLocalVar('ProtectionTable', protTable)

	if self.maskOverlay then
		p:SetLocalVar("Mask_overlay", "")
	end;
end

function ITEM:CanEquipOutfit()
	return true
end

function ITEM:OnInstanced()
	if !self:GetData('outfit_info') then
		self:SetData('outfit_info', self.outfitInformation)	
	end;
	if !self:GetData('outfit_buffer') then
		self:SetData("outfit_buffer", self.outfitInformation)
	end;
	if !self:GetData("modifications") then
		self:SetData("modifications", {})
	end;
end;