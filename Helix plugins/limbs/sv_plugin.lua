local PLUGIN = PLUGIN;

function PLUGIN:PlayerLoadedCharacter(client, character, prev)
    timer.Simple(0.25, function()
		client:CreateBiological()
		client:FallOfBlood()
		netstream.Start(client, 'limbs::GotDamage')

		if prev && LIMBS_BLEED_LIST[prev:GetID()] then
			LIMBS_BLEED_LIST[prev:GetID()] = nil;
		end

		local bio = character:GetData("Biology");
		if bio.bleeding > 0 then
				LIMBS_BLEED_LIST[character:GetID()] = character;
		end
    end)
end


function PLUGIN:CharacterDeleted(client, id, isCurrentChar)
		if LIMBS_BLEED_LIST && LIMBS_BLEED_LIST[id] then
				LIMBS_BLEED_LIST[id] = nil;
		end
end;

function PLUGIN:CharacterPreSave(character)
    local client = character:GetPlayer()
    if (IsValid(client)) then
        character:SetData("Biology", character:GetData("Biology"))
    end
end

function PLUGIN:PlayerSpawn( client )
		local character = client:GetCharacter()
		if !character then return end;
		local biology = character:GetData("Biology");
		if !biology then return end;

		biology.minhurt = 0;
		biology.hurt = 0;
		biology.blood = LIMB_MIN_BLOOD;
		client:FormLimbsData()

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

		if LIMB_DAMAGE_MUL > 0 then	dmg = dmg * (1 + (LIMB_DAMAGE_MUL / 100)) end;

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

		local inj = LIMB_INJURIES[dmgType];
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
		inj = LIMB_INJURIES[inj];

		if (bone:match("leg") || bone:match("foot")) && dmg > LIMB_DMG_LEG_FALL && !client:GetLocalVar("ragdoll") then
				client:SetRagdolled(true, 5)
		end

		if bone:match("head") then
				client:SetDSP( 35, false )
		end

		if inj && inj.causeBlood then
				client:BloodDrop( math.Round(dmg * (LIMB_CAUSE_BLEED/100)) )
				LIMBS_BLEED_LIST[character:GetID()] = character;
		end
end;

function PLUGIN:BloodCheck(client)
		local char = client:GetCharacter();
		local bio = char:GetData("Biology")

		client:FallOfBlood()
		
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

function PLUGIN:ShouldSpawnClientRagdoll(client)
		if client:GetLocalVar("ragdoll") then
				return false;
		end
end;

netstream.Hook("Limbs::InjAction", function(target, action, bone, inj)
	if INJ_ACTIONS && INJ_ACTIONS[action] then
		INJ_ACTIONS[action](target, bone, inj)
	end
end)

netstream.Hook("Limbs::healthAction", function(client, bone, id)
	local char = client:GetCharacter()
	local inv = char:GetInventory()
	local ITEM = inv:GetItemByID(id);

	if !ITEM then return end;

	ITEM:OnUse(client, bone)
end)

// При использовании чего бы то ни было должна появляться временная шкала. Нельзя делать что-либо кроме передвижения во время нее
// Уменьшать скорость тем, кто двигается во время использования