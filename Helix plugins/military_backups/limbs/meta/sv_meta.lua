local PLUGIN = PLUGIN;
local user = FindMetaTable("Player")

function user:ApplyBoneInjury(bone, inj, dmg, NoNnotify)
	if !self:Alive() then return end;
	local data = self:GetLimbs()
	local bio = self:GetBio()

	local injury = LIMB.INJURIES[inj];

	local id = #data[bone] + 1;
	// Количество минимального болевого порога. Ниже этого значения боль не опустится.
	bio.minhurt = bio.minhurt + LIMB.MIN_HURT;
	// Количество боли, которое будет передаваться персонажу при попадании
	// ( урон * (процент передаваемого урона в конечность или 50 / 100) ) + количество повреждений в части тела * константа множитель урона;
	local hurt = (dmg * ((injury.percent or 50)/100)) + id * LIMB.DAMAGE_MORE;

	data[bone][id] = {
		index = inj, 
		stage = 1, 
		bleeds = injury.causeBlood && math.Round(dmg*(LIMB.CAUSE_BLEED/100)) || nil,
		-- Время, когда произашло.
		occured = CurTime(),
		-- Время, когда пройдет; Если может гнить, то не проходит само, а накладывает гноение.
		expires = CurTime() + (injury.injTime || LIMB.ROT_TIME),
		/*
		Если игрок перебинтует или вылечит свою конечность, то таймер expires продляется на X;
		В зависимости от эффективности предмета каждые пару секунд прибавляется количество процентов излечения;
		Чем ниже эффективность - тем быстрее пройдет эффект лечения. Например бинты становятся грязными.
		Когда эффект лечения пройдет - таймер expires продлится еще раз;
		*/ 
		heal = "",
		healAmount = 0,
		healTime = 0,
	}

	local i = 1;
	while (i <= #LIMB.STAGES) do
		if LIMB.STAGES[i] && dmg >= LIMB.STAGES[i].min && dmg <= LIMB.STAGES[i].max then
				data[bone][id].stage = i;
				break;
		end
		i = i + 1;
	end;

	self:UpInfo("Limbs", data)
	self:UpInfo("Biology", bio)

	hook.Run("LimbGotDamaged", self, inj, dmg, id, bone)

	// X% от dmg
	self:AddHurt( hurt );

	if !NoNnotify then
		netstream.Start(self, 'limbs::GotDamage')
	end;
end;

function user:SetHeal(bone, inj, uniqueID)
	local limbs = self:GetLimbs();
	local limb = limbs[bone][inj]

	local item = ix.item.list[uniqueID]

	if !limb || !item then return end;

	if limb.healAmount >= 100 then
		self:RemoveInjury(bone, inj)
		return;
	end

	if limb.heal == "" then 
		limbs[bone][inj].heal = item.uniqueID; 
		limbs[bone][inj].healTime = CurTime() + item:GetHealTime(60);
	elseif limb.heal != "" then
		limbs[bone][inj].healAmount = limb.healAmount + item:GetHealEfficiency(0.5);
	end;

	local infection = item:GetParams().inf;

	if infection then
		
	end
	
	self:UpInfo("Limbs", limbs)
end;

function user:RemoveInjury(bone, inj)
	local limbs = self:GetLimbs();
	local injury = limbs[bone][inj];
	local bleed = injury.bleeds or 0;

	self:BloodDrop(-bleed)

	limbs[bone][inj] = nil;
	self:SortInjuries(bone)
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
	local bio = self:GetBio();

	bio.blood = math.Clamp(bio.blood - amount, 0, LIMB.MIN_BLOOD);
	self:UpInfo("Biology", bio)
	
	netstream.Start(self, 'limbs::GotDamage')
	hook.Run("BloodCheck", self)
end;

function user:BloodDrop(amount)
	local bio = self:GetBio();

	if !amount || amount <= 0 then amount = -bio.bleeding; end
	bio.bleeding = math.Clamp(bio.bleeding + amount, 0, 1000);

	self:UpInfo("Biology", bio)
end;

function user:CheckBlood()
	return LIMB.BLOOD_PERCENT >= self:GetBio().blood
end;

function user:CheckBloodDying()
	return LIMB.BLOOD_MIN >= self:GetBio().blood
end;

function user:AddHurt(hurt)
	local bio = self:GetBio();

	bio.hurt = math.Clamp(bio.hurt + hurt, bio.minhurt, 100);
			
	self:UpInfo("Biology", bio)		
	self:UpHurt()

	hook.Run("PlayerGotHurted", self)
end;

function user:SetMinHurt(hurt)
	local bio = self:GetBio();

	bio.minhurt = math.Clamp(bio.minhurt + hurt, 0, 100);
			
	self:UpInfo("Biology", bio)
end;

function user:AddShock(shock)
	local bio = self:GetBio();

	bio.shock = math.Clamp(bio.shock + math.Round(shock, 1), 0, LIMB.MAX_SHOCK_AMOUNT);
			
	self:UpInfo("Biology", bio)	

	hook.Run("PlayershockShock", self, bio.shock)	
end;

function user:CreateBiological()
	local character = self:GetCharacter();
	character:SetData("Biology", character:GetData("Biology", {
		["blood"] = LIMB.MIN_BLOOD,
		["minhurt"] = 0,
		["hurt"] = 0,
		["shock"] = 0,
		["bleeding"] = 0,
	}))
	self:SetLocalVar("Biology", character:GetData("Biology"))
end;

function user:UpHurt()
	local bio = self:GetBio();
		
	self:SetLocalVar("Hurt", nil)
	for i = 1, #LIMB.PAIN do
		local pain = LIMB.PAIN[i]
		if pain && bio.hurt >= pain.min && bio.hurt <= pain.max then
			self:SetLocalVar("Hurt", pain.name)
			return;
		end
	end;
end;

function user:SortInjuries(limb)
	local data = self:GetLimbs()

	local buffer = {}
	for k, v in pairs(data[limb]) do
		buffer[#buffer + 1] = v;
	end

	data[limb] = buffer

	self:UpInfo("Limbs", data)
end

function user:IsWounded()
	return self:GetCharacter():GetData("Wounded")
end;

function user:GetBio()
	return self:GetCharacter():GetData("Biology")
end;

function user:GetShock()

	return self:GetBio().shock
end;

function user:UpInfo(name, value)
	self:GetCharacter():SetData(name, value)
	self:SetLocalVar(name, value)
end;