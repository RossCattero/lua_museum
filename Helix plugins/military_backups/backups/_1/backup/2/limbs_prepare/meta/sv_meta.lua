local PLAYER = FindMetaTable("Player")

function PLAYER:FormBonesData()
	local bones, boneData = {}, table.Copy(LIMBS.BONES)
	
	for i = 1, self:GetBoneCount() - 1 do
		local bone = self:GetBoneName( i ):lower();
		for j = 1, #boneData do
			local b = boneData[j]
			if b && bone:find( b.bone ) then
				if bone:match("[lL]+_") then
					bones[ i ] = "left_"..b.parent;
				elseif bone:match("[rR]+_") then
					bones[ i ] = "right_"..b.parent;
				else
					bones[ i ] = b.parent;
				end
			end
		end;
	end;

	self:SetLocalVar("Bones", bones)
end;

function PLAYER:FormLimbsData()
	local character = self:GetCharacter();
	local buffer, limbs, data = {}, table.Copy(LIMBS.LIST), character:GetData("Limbs", {})

	for i = 1, #limbs do
		local limb = limbs[i];
		local index = limb.index;
		if limb then
			// TODO: Вернуть data[index] || {}
			buffer[ index ] = {}; 
		end
	end;

	self:SetLocalVar("Limbs", buffer)
	self:GetCharacter():SetData("Limbs", buffer)
end;