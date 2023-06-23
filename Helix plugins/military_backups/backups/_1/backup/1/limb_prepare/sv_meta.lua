local PLUGIN = PLUGIN;
local user = FindMetaTable("Player")
local left = "[lL]+_"
local right = "[rR]+_"

function user:FormBonesData()
		local bones = {};
		local boneData = table.Copy(PLUGIN.bones);

		local i = self:GetBoneCount() - 1;
		while (i >= 0) do
			local bone = self:GetBoneName( i ):lower();
			local j = #boneData;
			while (j > 0) do
				local b = boneData[j]
				if b && bone:find( b.bone ) then
						if bone:match(left) then
								bones[ i ] = "left_"..b.parent;
						elseif bone:match(right) then
								bones[ i ] = "right_"..b.parent;
						else
								bones[ i ] = b.parent;
						end
				end
				j = j - 1;
			end;
			i = i - 1;
		end;

		self:SetLocalVar("Bones", bones)
end;

function user:FormLimbsData()
		local character = self:GetCharacter();
		local limbs = table.Copy(PLUGIN.limbs)
		local buffer = {}

		local i = #limbs;
		while (i > 0) do
			local limb = limbs[i];
			if limb then
					buffer[ limb.index ] = {};
			end
			i = i - 1;
		end;

		character:SetData("Limbs", buffer)
		character:SetData("LimbsCopy", table.Copy(buffer))
		self:SetLocalVar("Limbs", buffer)
end;