local PLUGIN = PLUGIN;
local user = FindMetaTable("Player")

function user:ApplyBoneInjury(bone, inj, dmg, NoNnotify)
		if !self:Alive() then return end;
		local character = self:GetCharacter();
		local data = character:GetData("Limbs")
		local bio = character:GetData("Biology")

		local injury = LIMB_INJURIES[inj];

		bio.minhurt = bio.minhurt + LIMB_MIN_HURT;
		local id = #data[bone] + 1;
		data[bone][id] = {
			index = inj, 
			stage = 1, 
			bleeds = injury.causeBleed && math.Round(dmg*(LIMB_CAUSE_BLEED/100)) || nil,
			-- Время, когда произашло.
			occured = CurTime(),
			-- Время, когда пройдет; Если может гнить, то не проходит само, а накладывает гноение.
			expires = CurTime() + (injury.injTime || LIMB_ROT_TIME),
		}

		local i = 1;
		while (i <= #LIMB_STAGES) do
				if LIMB_STAGES[i] && dmg >= LIMB_STAGES[i].min && dmg <= LIMB_STAGES[i].max then
						data[bone][id].stage = i;
						break;
				end
				i = i + 1;
		end;

		self:UpInfo("Limbs", data)
		self:UpInfo("Biology", bio)

		hook.Run("LimbGotDamaged", self, inj, dmg, id, bone)

		// X% от dmg
		self:AddHurt( (dmg * ((injury.percent or 50)/100)) + #data[bone] * LIMB_DAMAGE_MORE );

		if !NoNnotify then
			netstream.Start(self, 'limbs::GotDamage')
		end;
end;

function user:ApplyExplosionDamage(inj, dmg)
		local character = self:GetCharacter();
		local data = character:GetData("Limbs")
		for k, v in pairs(data) do
				if self:Alive() then
					self:ApplyBoneInjury(k, inj, dmg, true)
				end;
		end
end;

function user:SetBlood(amount)
		local character = self:GetCharacter();
		local bio = character:GetData("Biology")

		bio.blood = math.Clamp(bio.blood - amount, 0, LIMB_MIN_BLOOD);
		self:UpInfo("Biology", bio)
		
		netstream.Start(self, 'limbs::GotDamage')
		hook.Run("BloodCheck", self)
end;
function user:BloodDrop(amount)
		local character = self:GetCharacter();
		local bio = character:GetData("Biology")

		if !amount || amount <= 0 then amount = -bio.bleeding; end
		bio.bleeding = math.Clamp(bio.bleeding + amount, 0, 1000);

		self:UpInfo("Biology", bio)
end;

function user:AddHurt(hurt)
		local character = self:GetCharacter()
		local bio = character:GetData("Biology")

		bio.hurt = math.Clamp(bio.hurt + hurt, bio.minhurt, 100);
				
		self:UpInfo("Biology", bio)		
		self:UpHurt()

		hook.Run("PlayerGotHurted", self)
end;

function user:AddShock(shock)
	local character = self:GetCharacter()
	local bio = character:GetData("Biology")

	bio.anaph = math.Clamp(bio.anaph + shock, 0, 100);
			
	self:UpInfo("Biology", bio)		
end;

function user:CreateBiological()
		local character = self:GetCharacter();
		character:SetData("Biology", character:GetData("Biology", {
			["blood"] = LIMB_MIN_BLOOD,
			["minhurt"] = 0,
			["hurt"] = 0,
			["anaph"] = 0,
			["bleeding"] = 0,
		}))
		self:SetLocalVar("Biology", character:GetData("Biology"))
end;

function user:FallOfBlood(takeUP)
		local char = self:GetCharacter();
		local bio = char:GetData("Biology")

		if takeUP then
				self:SetRagdolled(false, 0, 0)
				return;
		end

		if ((bio.blood / LIMB_MIN_BLOOD) * 100) <= 75 && !self:GetLocalVar("ragdoll") then
				self:SetRagdolled(true)
		end
end;

function user:UpInfo(name, value)
		local character = self:GetCharacter();

		character:SetData(name, value)
		self:SetLocalVar(name, value)
end;

function user:UpHurt()
		local char = self:GetCharacter();
		local bio = char:GetData("Biology")
		
		self:SetLocalVar("Hurt", nil)
		local i = 1;
		while (i <= #LIMB_PAIN) do
				local pain = LIMB_PAIN[i]
				if pain && bio.hurt >= pain.min && bio.hurt <= pain.max then
						self:SetLocalVar("Hurt", pain.name)
						return;
				end
				i = i + 1;
		end;
end;

function user:SortInjuries(limb)
	local data = self:GetCharacter():GetData("Limbs")

	local buffer = {}
	for k, v in pairs(data[limb]) do
		buffer[#buffer + 1] = v;
	end

	data[limb] = buffer

	self:SetLocalVar("Limbs", data);
	self:GetCharacter():SetData("Limbs", data);
end