local PLUGIN = PLUGIN

function PLUGIN:OnPlayerOptionSelected(target, client, option)
	if option == "Осмотреть" then
		local char = target:GetCharacter();

		local bio = char:GetData("Biology");

		local data = {};
		data.Limbs = char:GetData("Limbs")
		data.blood = bio.blood;
		data.pain = bio.pain;
		data.bleeding = bio.bleeding;
		
		netstream.Start(client, "Limbs::OpenPanel", data, false)
	end
end;

function PLUGIN:PlayerLoadedCharacter(client, character, prev)
    timer.Simple(0.25, function()
		
		client:Confuse(false)
		client:CreateBiological()

		local bio = character:GetData("Biology");
		netstream.Start(client, 'limbs::GotDamage')

		if prev && LIMB.BLEEDS[prev:GetID()] then LIMB.BLEEDS[prev:GetID()] = nil end

		if bio && bio.bleeding > 0 then LIMB.BLEEDS[character:GetID()] = character end

		// Массив для хранения тех, кто может запрашивать просмотр частей тела.
		local reco = character:GetData("reco", {});
		character:SetData("reco", reco)
		client:SetLocalVar("reco", reco)
		client:SetNetVar("reco", reco)
    end)
end

function PLUGIN:CharacterDeleted(client, id, isCurrentChar)
	if LIMB.BLEEDS && LIMB.BLEEDS[id] then
		LIMB.BLEEDS[id] = nil;
	end
end;

function PLUGIN:CharacterPreSave(character)
    local client = character:GetPlayer()
    if (IsValid(client)) then
        character:SetData("Biology", character:GetData("Biology"))
		character:SetData("reco", character:GetData("reco"))
    end
end

function PLUGIN:PlayerSpawn( client )
		local character = client:GetCharacter()
		if !character then return end;
		local biology = character:GetData("Biology");
		if !biology then return end;

		biology.minhurt = 0;
		biology.hurt = 0;
		biology.blood = LIMB.MIN_BLOOD;
		client:FormLimbsData()
		client:Confuse(false)

		character:SetData("Biology", biology)
		client:SetLocalVar("Biology", biology)
end;

function PLUGIN:EntityTakeDamage(target, damage)
		local attacker = damage:GetAttacker();
		local dmg = damage:GetDamage()
		local dmgType = damage:GetDamageType()
		local health = attacker:Health()

		if target:GetNoDraw() then return end;
		
		if dmg == 0 || !target:IsPlayer() && (!target:IsPlayer() && !target:GetNetVar("player")) then 
			return 
		end;

		if target:GetNetVar("player") then target = target:GetNetVar("player") end;

		if LIMB.DAMAGE_MUL > 0 then	dmg = dmg * (1 + (LIMB.DAMAGE_MUL / 100)) end;

		local trace = attacker:Tracer();
		if !trace then 
			if damage:IsExplosionDamage() then
				target:SetDSP( 35, false )
				target:ViewPunch( Angle( -150, 0, 0 ) )
				target:EmitPainSound()
				target:SetVelocity( Vector(100, 100, 250) )
				target:SetBlood(dmg * (80/100)); // Убавить кровь на 80% от дмг

				target:ApplyExplosionDamage(dmgType, dmg)
			end
			damage:SetDamage( 0 )
			return 
		end;

		local bone = HitBone( target, trace.PhysicsBone );
		if !bone then bone = "chest" end;

		target:ViewPunch( Angle( -13 * (dmg * 0.1), 0, 0 ) )
		target:EmitPainSound()

		local inj = LIMB.INJURIES[dmgType];
		math.randomseed( os.time() )
		if inj && math.random(100) <= (inj.chance || 100) then target:ApplyBoneInjury(bone, dmgType, dmg) end

		damage:SetDamage( 0 )
end;

function PLUGIN:DoPlayerDeath(client, attacker, damageinfo)
		client:BloodDrop( nil )
end;

function PLUGIN:GetFallDamage(client, speed)
	local helixDmg = (speed - 580) * 0.22
	client:ApplyBoneInjury("right_leg", DMG_FALL, helixDmg)
	client:ApplyBoneInjury("left_leg", DMG_FALL, helixDmg)
	client:ApplyBoneInjury("right_foot", DMG_FALL, helixDmg)
	client:ApplyBoneInjury("left_foot", DMG_FALL, helixDmg)
	client:EmitPainSound()

	client:EmitSound("player/pl_fallpain1.wav")

	return 0
end

function PLUGIN:LimbGotDamaged(client, inj, dmg, id, bone)
	local character = client:GetCharacter()
	inj = LIMB.INJURIES[inj];

	if client:Alive() && (bone:match("leg") || bone:match("foot")) && dmg > LIMB.DMG_LEG_FALL && !client:GetLocalVar("ragdoll") then
		client:SetRagdolled(true, 5)
	end

	if bone:match("head") then
		client:SetDSP( 35, false )
	end

	if inj && inj.causeBlood then
		client:BloodDrop( math.Round(dmg * (LIMB.CAUSE_BLEED/100)) )
		LIMB.BLEEDS[character:GetID()] = character;
	end
end;

function PLUGIN:BloodCheck(client)
	local char = client:GetCharacter();
	local bio = char:GetData("Biology")

	if client:CheckBlood() then client:Confuse(true, client:CheckBloodDying()) end
	
	if client:Alive() && bio.blood <= 0 then
		client:Kill()
	end
end;

function PLUGIN:PlayerGotHurted(client)
	local character = client:GetCharacter();
	local bio = character:GetData("Biology");

	client.HURTDEC = CurTime() + 5;

	if client:Alive() && bio.hurt >= 95 then
		client:Kill()
	end
end;

function PLUGIN:PlayerAnaphShock(client, shock) end;

function PLUGIN:ShouldSpawnClientRagdoll(client)
	if client:GetLocalVar("ragdoll") then return false end
end;

function PLUGIN:PlayerSay(client, text)
	local chatType, message, anonymous = ix.chat.Parse(client, text, true)

	if chatType == "ic" && client:GetLocalVar("UnCons") then
		client:Notify("Вы не можете говорить сейчас.")
		return ""
	end
end

function PLUGIN:PlayerButtonDown(client, button)
	if client:GetCharacter() && button == LIMB.INT_KEY && !client:UnActive() then
		netstream.Start(client, 'Limbs::OpenPanel', nil, true)
	end
end;

function PLUGIN:CanPlayerInteractItem(client, action, item)
	if (client:UnActive()) then
		return false
	end
end;