local PLUGIN = PLUGIN;

function PLUGIN:PlayerLoadedCharacter(client, character, prev)
    timer.Simple(0.25, function()
				character:SetData("Blood", character:GetData("Blood", 4000))
				client:SetLocalVar("Blood", character:GetData("Blood", 4000))

				character:SetData("BloodDrop", character:GetData("BloodDrop", 0))
				client:SetLocalVar("BloodDrop", character:GetData("BloodDrop", 0))

				netstream.Start(client, 'limbs::GotDamage')
    end)
end

function PLUGIN:CharacterPreSave(character)
    local client = character:GetPlayer()
    if (IsValid(client)) then
        character:SetData("Blood", character:GetData("Blood"))
        character:SetData("BloodDrop", character:GetData("BloodDrop"))
    end
end

function PLUGIN:PlayerSpawn( client )
		local character = client:GetCharacter()
		character:SetData("Blood", 4000)
		client:SetLocalVar("Blood", character:GetData("Blood", 4000))
end;

function PLUGIN:EntityTakeDamage(target, damage)
		local attacker = damage:GetAttacker();
		local dmg = damage:GetDamage()
		local dmgType = damage:GetDamageType()
		local health = attacker:Health()

		if dmg == 0 || !target:IsPlayer() then 
			return 
		end;
		netstream.Start(target, 'limbs::GotDamage')
		local rDmg = dmg * 0.01;

		local trace = attacker:Tracer();
		if !trace then 
			if damage:IsExplosionDamage() then
					target:SetDSP( 35, false )
					target:ViewPunch( Angle( -150, 0, 0 ) )
					target:EmitPainSound()
					target:SetVelocity( Vector(100, 100, 250) )
					target:SetBlood(rDmg * 5000)
			end
			damage:SetDamage( 0 )
			return 
		end;

		local bone = HitBone( trace );
		if !bone then bone = "chest" end;

		target:ViewPunch( Angle( -13 * rDmg, 0, 0 ) )
		target:EmitPainSound()

		local inj = LIMB_INJURIES[dmgType];
		math.randomseed( os.time() )
		if inj && math.random(100) <= (inj.chance || 100) then
				target:ApplyBoneInjury(bone, dmgType, (target:HasInjury(bone, dmgType) or 0) + 1)
		end

		target:SetBlood(rDmg * 10)

		damage:SetDamage( 0 )
end;

function PLUGIN:GetFallDamage(client, speed)
		client:ApplyBoneInjury("right_leg", DMG_FALL, (client:HasInjury("right_leg", DMG_FALL) or 0) + 1)
		client:ApplyBoneInjury("left_leg", DMG_FALL, (client:HasInjury("left_leg", DMG_FALL) or 0) + 1)
		client:ApplyBoneInjury("right_foot", DMG_FALL, (client:HasInjury("right_foot", DMG_FALL) or 0) + 1)
		client:ApplyBoneInjury("left_foot", DMG_FALL, (client:HasInjury("left_foot", DMG_FALL) or 0) + 1)
		netstream.Start(client, 'limbs::GotDamage')
		client:EmitPainSound()

		client:EmitSound("player/pl_fallpain1.wav")

		return 0
end

function PLUGIN:LimbGotDamaged(client, inj)
		local character = client:GetCharacter()
		inj = LIMB_INJURIES[inj];

		if inj && inj.causeBlood then
				client:BloodDrop( 1 )

				local uniqueID = 'BloodDrop ' .. client:SteamID();	
				if !timer.Exists(uniqueID) then
						timer.Create(uniqueID, 1, 60, function()
							if !timer.Exists(uniqueID) || !client:IsValid() then timer.Remove(uniqueID) return; end;
							client:SetBlood( character:GetData("BloodDrop") )

							netstream.Start(target, 'limbs::GotDamage')
							if timer.RepsLeft(uniqueID) <= 0 then
									client:BloodDrop( nil )
							end
						end);

				else
					
					timer.Adjust(uniqueID, 1, 60, function()
							if !timer.Exists(uniqueID) || !client:IsValid() then timer.Remove(uniqueID) return; end;

							client:SetBlood( character:GetData("BloodDrop") )
							netstream.Start(target, 'limbs::GotDamage')
							if timer.RepsLeft(uniqueID) <= 0 then
									client:BloodDrop( nil )
							end
					end)
				end;
		end
end;

function PLUGIN:BloodCheck(client)
		local char = client:GetCharacter();
		local blood = char:GetData("Blood")

		if blood <= 0 then
				client:Kill()
		end
end;