local PLUGIN = PLUGIN;
local GM = GM;

local math = math;
local clamp = math.Clamp

function PLUGIN:CharacterPreSave(char)
		local client = char:getPlayer()
    if (IsValid(client)) then
				client:CreateLimbs()
		end;
end;

function PLUGIN:PlayerLoadedChar(client, char)
		client:CreateLimbs()
		timer.Simple(0, function()
				if char:getData("bleeding") then
					client:CreateBleeding(char:getData("bleeding"))
				end
				if char:getData("unconscious") then
						client:SetUnc()
				end
		end)
end;

function PLUGIN:PlayerSay(client, message)
		if client:getLocalVar("unconscious") then
				return false
		end;
end;

-- Overrided the default damageTake to prevent double damage from fall;
if GM != nil then // for relibility reasons;
		function GM:EntityTakeDamage(entity, dmgInfo) end;
end;

function PLUGIN:OnCharDisconnect(client, char)
		char:setData("unconscious", false);
end

function PLUGIN:EntityTakeDamage(target, damage)
		local attacker = damage:GetAttacker();
		local dmg = damage:GetDamage()
		
		if target:getNetVar("player") then
			target = target:getNetVar("player")
		end
		
		if !IsValid(target) || !target:IsPlayer() || (target.damageImmunity && CurTime() <= target.damageImmunity) then return end;
		local unId = "KillUser - unc " .. target:SteamID()

		local unaffected = nut.faction.get(target:getChar():getFaction()).limbUnaffected;
		if unaffected then return end;
		
		if !target:getLocalVar("unconscious") then
			if target:Health() > 0 && target:Health() - dmg <= 10 then
				target:SetUnc()
				timer.Create(unId, 60*3, 1, function()
						if !target:IsValid() || !target:Alive() || !target:getLocalVar("unconscious") then
								timer.Remove(unId)
								return;
						end

						if IsValid(target) 
						&& target:getChar() 
						&& target:Alive() 
						&& target:getLocalVar("unconscious") then
								target:Kill()
						end
				end)
			end;
		else
			target:SetHealth( math.Clamp(target:Health() - dmg, 0, target:GetMaxHealth()) )
			if target:Health() - dmg <= 0 && !target.killedHandle then
					target:Kill();

					target.killedHandle = true;

					if timer.Exists(unId) then
							timer.Remove(unId)
					end
			end
			return
		end

		if attacker == Entity(0) then
				if damage:IsFallDamage() then
						target:SetLimb("right leg", clamp( target:GetLimb("right leg") - dmg, 0, DefaultLimb("right leg") ) )
						target:SetLimb("left leg", clamp( target:GetLimb("left leg") - dmg, 0, DefaultLimb("left leg") ) )
				end
		elseif IsValid(attacker) && attacker.GetAimVector then
				local trace = attacker:Tracer();
				local bone = self:HitBone(trace);

				if bone != 0 then
						target:SetLimb(bone, clamp( target:GetLimb(bone) - dmg, 0, DefaultLimb(bone) ) )
				end;
				target:CreateBleeding(damage:GetDamageType())
		end
end;

function PLUGIN:PlayerDeath(client)
		if !client.resetLimbs then
				client.resetLimbs = true;
				client:getChar():setData("bleeding", false)
				client:setUnconsious(false)
				client:setLocalVar("unc_giveup", false)
		end
		if IsValid(client.nutRagdoll) then
				client.nutRagdoll:Remove()
		end
		local OldRagdoll = client:GetRagdollEntity()
		if ( IsValid(OldRagdoll) ) then OldRagdoll:Remove() end
end;

function PLUGIN:DoPlayerDeath( client, attacker, dmg )
		if IsValid(client.nutRagdoll) then
			client.nutRagdoll:Remove()
		end
		local OldRagdoll = client:GetRagdollEntity()
		if ( IsValid(OldRagdoll) ) then OldRagdoll:Remove() end
end;

function PLUGIN:PlayerSpawn(client)
		if client:Alive() && client.resetLimbs then
				local char = client:getChar();
				
				client.resetLimbs = false;
				client.killedHandle = false;
				client:ResetLimbs()
		end
end;

-- Overrided stamina from stamina plugin!
function PLUGIN:PostPlayerLoadout(client)
		client:setLocalVar("stm", 100)

		local uniqueID = "nutStam"..client:SteamID()
		local offset = 0
		local runSpeed = client:GetRunSpeed() - 5

		timer.Adjust(uniqueID, 0.35, 0, function()
			if (!IsValid(client)) then
				timer.Remove(uniqueID)
				return
			end
			local character = client:getChar()
			if (client:GetMoveType() == MOVETYPE_NOCLIP or not character) then
				return
			end

			local bonus = character.getAttrib 
				and character:getAttrib("stm", 0)
				or 0
			runSpeed = nut.config.get("runSpeed") + bonus

			if (client:WaterLevel() > 1) then
				runSpeed = runSpeed * 0.775
			end

			if (client:isRunning()) then
				local bonus = character.getAttrib
					and character:getAttrib("end", 0)
					or 0
				offset = -2 + (bonus / 60) - ((DefaultLimb(2) - client:GetLimb(2)) / 10);
			elseif (offset > 0.5) then
				offset = 1
			else
				offset = 1.75
			end

			if (client:Crouching()) then
				offset = offset + 1
			end

			local current = client:getLocalVar("stm", 0)
			local value = math.Clamp(current + offset, 0, 100)

			if (current ~= value) then
				client:setLocalVar("stm", value)

				if (value == 0 and !client:getNetVar("brth", false)) then
					client:SetRunSpeed(nut.config.get("walkSpeed"))
					client:setNetVar("brth", true)

					hook.Run("PlayerStaminaLost", client)
				elseif (value >= 50 and client:getNetVar("brth", false)) then
					client:SetRunSpeed(runSpeed)
					client:setNetVar("brth", nil)
				end
			end
		end)
end

function PLUGIN:LimbChanged(client, limb, old_value, new_value)
		if limb == 8 && new_value <= 0 then
				client:Kill();
		end
end;

function PLUGIN:PlayerUse(client, entity)
		if entity:GetClass() == "prop_ragdoll" then
			local target = entity:getNetVar("player")

				if target 
				&& target:getLocalVar("unconscious") 
				&& !target:getLocalVar("unc_giveup")
				&& !client:DoingMovAction() then
					client:setActionMoving("Waking up the target", 4, 
					function(user) 
							target:setUnconsious(false)
							target:SetHealth(25);
					end, function(user)
							local trace = user:Tracer(128);							
							return trace.Entity == entity;
					end)
				end
		end
end;

netstream.Hook('limbs::keyKill', function(client)
		if IsValid(client) 
		&& client:getChar() 
		&& client:Alive() 
		&& client:getLocalVar("unconscious") then
				client:Kill()				
				local unId = "KillUser - unc " .. client:SteamID()
				if timer.Exists(unId) then
						timer.Remove(unId)
				end
		end
end);
