ITEM.name = "Outfit"
ITEM.description = "A Outfit Base."
ITEM.category = "Outfit"
ITEM.model = "models/Gibs/HGIBS.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.outfitCategory = "model"
ITEM.pacData = {}

ITEM.newFootStep = "npc/combine_soldier/gear1.wav"

ITEM.damageTypes = { -- Damage reduce should be more, than 0 and less, than 100;
	['Melee'] = 0,
	-- DMG_CRUSH; DMG_SLASH; DMG_CLUB; 8197; 4202501; DMG_GENERIC
	['Burn'] = 0, 
	-- DMG_BURN; DMG_SLOWBURN
	['Explosion'] = 0,
	-- DMG_BLAST; 134217792
	['Bullets'] = 0,
	--  DMG_BULLET; 4098; 536875010; DMG_BUCKSHOT; DMG_SNIPER; DMG_PLASMA
	['Acid'] = 0
	-- DMG_ACID; DMG_PARALYZE; DMG_POISON; 134348800; 
}

ITEM.protects = {
	"head", "body", "legs", "arms"
}

if (CLIENT) then
	function ITEM:PaintOver(item, w, h)
		if (item:GetData("equip")) then
			surface.SetDrawColor(110, 255, 110, 100)
			surface.DrawRect(w - 14, h - 14, 8, 8)
		end
	end
end

function ITEM:RemoveOutfit(client)
	local character = client:GetCharacter()

	self:SetData("equip", false)

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
	if (item:GetData("equip")) then
		item:RemoveOutfit(item:GetOwner())
	end
end)

ITEM.functions.EquipUn = { -- sorry, for name order.
	name = "Unequip",
	tip = "equipTip",
	icon = "icon16/cross.png",
	OnRun = function(item)
		item:RemoveOutfit(item.player)
		return false
	end,
	OnCanRun = function(item)
		local client = item.player

		return !IsValid(item.entity) and IsValid(client) and item:GetData("equip") == true and
			hook.Run("CanPlayerUnequipItem", client, item) != false and item.invID == client:GetCharacter():GetInventory():GetID()
	end
}

ITEM.functions.Equip = {
	name = "Equip",
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

		if (isfunction(item.OnGetReplacement)) then
			char:SetData("oldModel" .. item.outfitCategory, char:GetData("oldModel" .. item.outfitCategory, item.player:GetModel()))
			char:SetModel(item:OnGetReplacement())
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

		local groups = char:GetData("groups", {})

		if (!table.IsEmpty(groups)) then
			char:SetData("oldGroups" .. item.outfitCategory, groups)
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
	local client = self:GetOwner()

	local text = string.lower(self.outfitCategory)

	if self.newFootStep && self.newFootStep != "" && isstring(self.newFootStep) then
		client:ChangeFootsteps( self.newFootStep )
	end;

	if text && client:GetLocalVar('clothesItems')[text] then
		client:ChangeClothes(text, self)
	end;
end

function ITEM:OnUnequipped()
	local client = self:GetOwner()
	local text = string.lower(self.outfitCategory)

	if self.newFootStep && self.newFootStep != "" && isstring(self.newFootStep) then
		client:ChangeFootsteps( "" )
	end;

	if text && client:GetLocalVar('clothesItems')[text] then
		client:ChangeClothes(text, {})
	end;	
end

function ITEM:CanEquipOutfit()
	return true
end

function ITEM:OnInstanced()
	if !self:GetData('Protections') then
		self:SetData('Protections', self.damageTypes)
	end;
end;