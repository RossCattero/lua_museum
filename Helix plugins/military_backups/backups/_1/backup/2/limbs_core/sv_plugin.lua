local PLUGIN = PLUGIN

function PLUGIN:PlayerLoadedCharacter(client, character, prev)
    timer.Simple(.25, function()
		local bio = character:GetData("Bio", table.Copy(LIMBS.BIO))

		character:SetData("Bio", bio)
		client:SetLocalVar("Bio", bio)

		if prev && LIMBS.BLEEDS[prev:GetID()] then 
			LIMBS.BLEEDS[prev:GetID()] = nil 
		end

		if client:GetBleed() > 0 then 
			LIMBS.BLEEDS[character:GetID()] = character 
		end
    end)
end

function PLUGIN:CharacterDeleted(client, id)
	if LIMBS.BLEEDS && LIMBS.BLEEDS[id] then
		LIMBS.BLEEDS[id] = nil;
	end
end;

function PLUGIN:CharacterPreSave(character)
    local client = character:GetPlayer()

    if IsValid(client) then
		character:SetData( "Bio", client:GetBIO() )
    end
end

function PLUGIN:EntityTakeDamage(target, damage)
	local attacker, dmg, dmgType = damage:GetAttacker(), damage:GetDamage(), damage:GetDamageType()

	target = target:GetNetVar("player") || target;
	
	if dmg == 0 || !target:CanAccessInjuries() then return end;

	local trace = attacker:Tracer();

	if !trace then

		if damage:IsExplosionDamage() then

			for k, v in pairs( target:GetLimbs() ) do
				target:Injury(k, damage) 
			end

			target:SetDSP( 35, false )
			target:ViewPunch( Angle( -150, 0, 0 ) )
			target:EmitPainSound()
			target:SetVelocity( Vector(100, 100, 250) )

			target:Blood( dmg * (80/100) );
		end

		damage:SetDamage( 0 )
		return 
	end;

	local bone = LIMBS:HitBone( target, trace.PhysicsBone );
	if !bone then bone = "chest" end;

	target:ViewPunch( Angle( -13 * (dmg * 0.1), 0, 0 ) )
	target:EmitPainSound()

	local inj = INJURIES.Get( damage:GetDamageType() )

	math.randomseed( os.time() );

	if inj && math.random(100) <= inj.appearChance then 
		target:Injury(bone, damage) 
	end

	damage:SetDamage( 0 )
end;

function PLUGIN:DoPlayerDeath( client )
	client:Blood( 0, -client:GetBleed() )
end;

function PLUGIN:ShouldSpawnClientRagdoll(client)
	if client:GetLocalVar("ragdoll") then return false end
end;

function PLUGIN:GetFallDamage(client, speed)
	local dmg = DamageInfo();
	dmg:SetDamage( (speed - 580) * 0.1 )
	dmg:SetDamageType( DMG_FALL )

	client:Injury("right_leg", dmg) 
	client:Injury("left_leg", dmg) 
	client:Injury("right_foot", dmg) 
	client:Injury("left_foot", dmg) 

	client:EmitPainSound()
	client:EmitSound("player/pl_fallpain1.wav")

	if dmg:GetDamage() >= 2 then
		client:SetRagdolled(true, math.random(2, 5))
	end

	return 0
end

function PLUGIN:PlayerSay(client, text)
	local chatType, message, anonymous = ix.chat.Parse(client, text, true)

	if chatType == "ic" && client:IsFallen() then
		client:Notify("Вы не можете говорить сейчас.")
		return ""
	end
end

function PLUGIN:PlayerSpawn( client )
	local character = client:GetCharacter()
	if !character then return end;
	local biology = client:GetBIO()
	if !biology then return end;

	biology.painMin = 0;
	biology.pain = 0;
	biology.blood = LIMBS.MIN_BLOOD;
	client:FormLimbsData()
	client:ResetInjuries(true, true, character:GetID())

	character:SetData("Bio", biology)
	client:SetLocalVar("Bio", biology)
end;