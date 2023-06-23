local PLUGIN = PLUGIN;
local user = FindMetaTable("Player")

function user:ArmorEquip(index, value)
		local char = self:GetCharacter();
		local data = char:GetData("Clothes");
		local clothes = data[index];

		if clothes then
				clothes.equiped = value;
				self:SetLocalVar("Clothes", data)
				char:SetData("Clothes", data);

				netstream.Start(client, 'armor::SyncEdits')
				return true;
		end

		return false;
end;

function user:HaveArmorInSlot(index)
		local clothes = self:GetCharacter():GetData("Clothes")
		clothes = clothes[index]

		return clothes && clothes["equiped"].uniqueID && clothes["equiped"]
end;

function user:ArmorTakeDown(index)
		local char = self:GetCharacter();
		local inv = char:GetInventory()
		local data = char:GetData("Clothes");
		local clothes = data[index];
		local id = clothes.equiped.uniqueID

		if clothes then
				local item = ix.item.list[id]
				if item && inv:FindEmptySlot(item.width, item.height) then
						clothes.equiped.protections = nil;
						inv:Add(id, 1, {
							Features = clothes.equiped;
						})
						clothes.equiped = {};
						
						char:SetData("Clothes", data);
						self:SetLocalVar("Clothes", data)

						netstream.Start(self, 'armor::SyncEdits')
						if item.useSound && item.useSound != "" then
							self:EmitSound(item.useSound)
						end;
						if item.changeBGs then
							local bgs = char:GetData("Bodygroups", {})
							for k, v in pairs(item.changeBGs) do
									local bg = self:FindBodygroupByName(k)
									self:SetBodygroup(bg, 0);
									bgs[k] = nil;
							end
							char:SetData("Bodygroups", bgs);
						end
						if item.changeSkin then
							local skin = char:GetData("Skin", 0)
							self:SetSkin(0)
							char:SetData("Skin", 0);
						end
						return true;
				end
		end

		return false;
end;

function user:ModifyArmorData( index, amount )
		local char = self:GetCharacter();
		local clothes = char:GetData("Clothes")
		if !clothes[index] then return end;
		local data = clothes[index]["equiped"];

		if data then
			data.armor = math.Clamp(data.armor - amount, 0, data.maxArmor )
		end;

		char:SetData("Clothes", clothes);
		self:SetLocalVar("Clothes", clothes)
end;

function user:FormBones()
		local body = {}
		
		local bones = PLUGIN.BONES_CONSISTS;
		local i = self:GetBoneCount() - 1;
		while (i >= 0) do
				local bone = self:GetBoneName( i )
				bone = bone:lower();
				local j = #bones;
				while (j > 0) do
					if bone:find(bones[j].bone) then
							body[i] = bones[j].parent;
					end
					j = j - 1;
				end;
				i = i - 1;
		end;

		return body;
end;

function user:FormClothesData()
		local character = self:GetCharacter()

		local copy = table.Copy(BODY_PARTS);
		local buffer = {};
		local i = table.maxn(copy);
		while (i > 0) do
				local data = copy[i];
				if data then
						buffer[ data.index ] = {
							name = data.name,
							equiped = {},
						}
				end
				i = i - 1;
		end;
		character:SetData("Clothes",
			character:GetData("Clothes", buffer)
		)
		self:SetLocalVar("Clothes", 
			character:GetData("Clothes", buffer)
		)
end;