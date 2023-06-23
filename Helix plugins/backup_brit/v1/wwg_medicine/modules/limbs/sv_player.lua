local PLAYER = FindMetaTable("Player")

function PLAYER:FormBones()
	local boneCount = self:GetBoneCount();
	if boneCount <= 1 then return; end;

	local boneData, side, bones, limbs = ix.medical.limbs.bones, ix.medical.limbs.sideless, {}, {}
	local result;
	
	for i = 1, boneCount - 1 do
		local bone = self:GetBoneName( i ):lower();
		local pos, name = bone:match("valvebiped.bip01_(r?l?)_?([%a]+)")
		local boneInfo = boneData[name]
		
		if boneInfo then
			result = (pos && !side[boneInfo] && pos .. "_" || "") .. boneInfo;

			bones[i] = result
			limbs[result] = {}
		end
	end;

	self:SetLocalVar("Bones", bones)

	return limbs;
end;