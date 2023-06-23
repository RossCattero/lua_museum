local PLUGIN = PLUGIN;
local user = FindMetaTable("Player")
local left = "[lL]+_"
local right = "[rR]+_"

function user:FormBonesData()
	local bones = {};
	local boneData = table.Copy(LIMB.bones);

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
	local limbs = table.Copy(LIMB.LIST)
	local buffer = {}
	local medBuffer = {}

	local i = #limbs;
	while (i > 0) do
		local limb = limbs[i];
		if limb then
			buffer[ limb.index ] = {};
			medBuffer[ limb.index ] = {}
		end
		i = i - 1;
	end;

	character:SetData("Limbs", buffer)
	self:SetLocalVar("Limbs", buffer)

	character:SetData("Limbs_med", medBuffer)
	self:SetLocalVar("Limbs_med", medBuffer)
end;

local painSounds = {
	Sound("vo/npc/male01/pain01.wav"),
	Sound("vo/npc/male01/pain02.wav"),
	Sound("vo/npc/male01/pain03.wav"),
	Sound("vo/npc/male01/pain04.wav"),
	Sound("vo/npc/male01/pain05.wav"),
	Sound("vo/npc/male01/pain06.wav")
}

function user:EmitPainSound()
		local health = self:Health()
		if ((self.ixNextPain or 0) < CurTime() and health > 0) then
			local painSound = hook.Run("GetPlayerPainSound", self) or painSounds[math.random(1, #painSounds)]

			if (self:IsFemale() and !painSound:find("female")) then
				painSound = painSound:gsub("male", "female")
			end

			self:EmitSound(painSound)
			self.ixNextPain = CurTime() + 0.33
		end
end;