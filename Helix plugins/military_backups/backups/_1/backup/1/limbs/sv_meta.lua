local PLUGIN = PLUGIN;

local user = FindMetaTable("Player")

local painSounds = {
	Sound("vo/npc/male01/pain01.wav"),
	Sound("vo/npc/male01/pain02.wav"),
	Sound("vo/npc/male01/pain03.wav"),
	Sound("vo/npc/male01/pain04.wav"),
	Sound("vo/npc/male01/pain05.wav"),
	Sound("vo/npc/male01/pain06.wav")
}

function user:ApplyBoneInjury(bone, inj, stage)
		local character = self:GetCharacter();
		local data = character:GetData("Limbs")
		local limbs = character:GetData("LimbsCopy")

		local id = limbs[bone][inj] || #data[bone] + 1;
		data[bone][id] = {index = inj, stage = stage}
		limbs[bone][inj] = #data[bone];

		self:SetLocalVar("Limbs", data)

		hook.Run("LimbGotDamaged", self, data[bone][id].index)
end;

function user:ApplyExplosionDamage(inj)
		local character = self:GetCharacter();
		local data = character:GetData("Limbs")
		for k, v in pairs(data) do
				self:ApplyBoneInjury(k, inj, (self:HasInjury(k, inj) or 0) + 1 )
		end
end;

function user:SetBlood(amount)
		local character = self:GetCharacter();
		local blood = character:GetData("Blood")

		blood = math.Clamp(blood - amount, 0, 4000);

		character:SetData("Blood", blood)
		self:SetLocalVar("Blood", blood)

		hook.Run("BloodCheck", self)
end;
function user:BloodDrop(amount)
		local character = self:GetCharacter();
		local bloodDrop = character:GetData("BloodDrop")
		if !amount then
				amount = -bloodDrop;
		end

		bloodDrop = math.Clamp(bloodDrop + amount, 0, 1000);

		character:SetData("BloodDrop", bloodDrop)
		self:SetLocalVar("BloodDrop", bloodDrop)
end;

function user:HasInjury(bone, inj)
		local character = self:GetCharacter();
		local data = character:GetData("LimbsCopy")

		return data[bone] && data[bone][inj] 
end;

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