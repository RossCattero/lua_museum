ITEM.name = "Одежда"
ITEM.description = "База одежды v2"
ITEM.category = "Одежда"
ITEM.model = "models/Gibs/HGIBS.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.outfitCategory = "model"
ITEM.civilprotection = false;

ITEM.functions.TakeUpClothes = {
	name = "Надеть",
	OnRun = function(item)
		local client = item.player;
		local char = client:GetCharacter()
		local items = char:GetInventory():GetItems()
		local groups = char:GetData("groups", {})

		for _, v in pairs(items) do
			if (v.id != item.id) then
				local itemTable = ix.item.instances[v.id]

				if (itemTable.pacData and v.outfitCategory == item.outfitCategory and itemTable:GetData("equip")) then
					client:NotifyLocalized(item.equippedNotify or "outfitAlreadyEquipped")
					return false
				end
			end
		end


		if (!table.IsEmpty(groups)) then
			char:SetData("oldGroups" .. item.outfitCategory, groups)
		end

		if (item.bodyGroups or item.femaleBodyGroups) then
			groups = {}

			if item.bodyGroups then
				for k, value in pairs(item.bodyGroups) do
					local index = item.player:FindBodygroupByName(k)

					if (index > -1) then
						groups[index] = value
					end
				end
			end;

			if item.femaleBodyGroups && item.player:IsFemale() then
				for k, value in pairs(item.femaleBodyGroups) do
					local index = item.player:FindBodygroupByName(k)
	
					if (index > -1) then
						groups[index] = value
					end
				end
			end;

			local newGroups = char:GetData("groups", {})

			for index, value in pairs(groups) do
				newGroups[index] = value
				item.player:SetBodygroup(index, value)
			end

			if (!table.IsEmpty(newGroups)) then
				char:SetData("groups", newGroups)
			end
		end

		char:GetData('ClothesUps')[item.outfitCategory] = item.uniqueID;
		char:SetData('ClothesUps', char:GetData('ClothesUps'))
		client:SetLocalVar('ClothesUps', char:GetData('ClothesUps'))
	end,
	OnCanRun = function(item)
		local client = item.player
		local character = item.player:GetCharacter()

		local canEquip = character:GetData('ClothesUps')[item.outfitCategory];
		local modelclass = ix.anim.GetModelClass(client:GetModel());
		local cmb = client:IsCombine();

		local femaleBGs = item.femaleBodyGroups
		local maleBGs = item.bodyGroups
		local isFemenist = item.player:IsFemale()

		-- local femaleCheck = (!maleBGs && femaleBGs && isFemenist) or (maleBGs && !femaleBGs && !isFemenist) or (maleBGs && !femaleBGs && isFemenist) or (maleBGs && femaleBGs && !isFemenist)
		local femaleCheck = (maleBGs && femaleBGs) or (!maleBGs && femaleBGs && isFemenist) or (maleBGs && !femaleBGs && !isFemenist) or (maleBGs && !femaleBGs && isFemenist)

		local canWear = ( item.civilprotection && ((modelclass == 'metrocop' && cmb) or (modelclass == 'citizen_female' && cmb)) ) or
		(!item.civilprotection && modelclass != 'metrocop' && !cmb)
		
		return (canEquip == nil or canEquip == "") && canWear && tobool(femaleCheck);
	end
}