local math = math;
local clamp = math.Clamp
local PLUGIN = PLUGIN;
local user = FindMetaTable("Player");

function user:CreateLimbs()
		local char = self:getChar();
		local DEF = table.Copy(PLUGIN.DEFAULT_LIMBS);

		char:setData("limbs", char:getData("limbs", DEF))
		self:setLocalVar("limbs", char:getData("limbs"))
end;

function user:ResetLimbs()
		local char = self:getChar();
		local DEF = table.Copy(PLUGIN.DEFAULT_LIMBS);

		char:setData("limbs", DEF)
		self:setLocalVar("limbs", char:getData("limbs"))
end

function user:SetLimb(limb, value)
		local limbs = self:GetLimbs();
		local limbCopy = limb;

		if !limbs[limbCopy] then
				limb = nil;
				for k, v in pairs(limbs) do
						if limbCopy == v.name then
								limb = k;
								break;
						end
				end
				limbCopy = limb;
				if !limbCopy then
						return false;
				end
		end

		if limbs[limb] then 
			// client, limb, old value, new value
			hook.Run("LimbChanged", self, limb, limbs[limb].amount, value)
			limbs[limb].amount = value 
		end;
		
		self:setLocalVar("limbs", self:getChar():getData("limbs"))
end;

function user:PlayHurtSound()
		local mdl = self:GetModel();
		local gender = mdl:match("male") && "male" || mdl:match("female") && "female" || "male";
		if !gender then return end;

		self:EmitSound("vo/npc/"..gender.."01/pain0"..math.random(1, 8)..".wav")
end;

function user:CreateBleeding(damageType)
	if BLOOD_LOSE[damageType] && math.random(100) > 65 then
			local uniqueID = "bleeding - " .. self:SteamID()
			local bloodLose = BLOOD_LOSE[damageType] or 0.3;
			local char = self:getChar()

			if char && !char:getData("bleeding") then
						self:notify("*** Ouch! I'm bleeding!")
						char:setData("bleeding", damageType)
						timer.Create(uniqueID, 1, 32, function()
								if !timer.Exists(uniqueID) || !self:IsValid() || !self:Alive() || !char:getData("bleeding") then 
									timer.Remove(uniqueID) 
									return; 
								end;
								
								self:PlayHurtSound()
								self:SetLimb("blood", clamp( self:GetLimb("blood") - bloodLose, 0, DefaultLimb("blood") ) )
								if timer.RepsLeft(uniqueID) < 1 then
										char:setData("bleeding", false)
								end
						end);
				else
						self:notify("*** Ouch! I'm damaged while bleeding!")
						self:SetLimb("blood", clamp( self:GetLimb("blood") - bloodLose * 2, 0, DefaultLimb("blood") ) )
						timer.Adjust(uniqueID, 1, 32, nil);
				end;
		end
end;

function user:StopBleeding()
		local char = self:getChar()
		if char && char:getData("bleeding") then			
				self:notify("*** My wound have been healed - I'm no longer bleeding.")
				self:setLocalVar("bleeding", false)
				self:getChar():setData("bleeding", self:getLocalVar("bleeding"))
				if timer.Exists("bleeding - " .. self:SteamID()) then
						timer.Remove("bleeding - " .. self:SteamID())
				end
		end;
end;

function user:setUnconsious(state)
	if (state) then
		if (IsValid(self.nutRagdoll)) then
			self.nutRagdoll:Remove()
		end

		local entity = self:createRagdoll()
		entity:setNetVar("player", self)

		for k, v in pairs(self:GetBodyGroups()) do
			if entity:IsValid() then
				entity:SetBodygroup(k, self:GetBodygroup(k))
			end;
		end

		entity:CallOnRemove("fixer", function()
			if (IsValid(self)) then
				self:setLocalVar("blur", nil)
				self:setLocalVar("ragdoll", nil)
				self:setLocalVar("unconscious", nil)

				if self:getChar() then
						self:getChar():setData("unconscious", false)
				end

				self:SetNoDraw(false)
				self:SetNotSolid(false)
				self:Freeze(false)
				self:SetMoveType(MOVETYPE_WALK)
				self:SetLocalVelocity(
					IsValid(entity)
					and entity.nutLastVelocity
					or vector_origin
				)
			end

			if (IsValid(self) and !entity.nutIgnoreDelete) then
				if (entity.nutWeapons) then
					for k, v in ipairs(entity.nutWeapons) do
						self:Give(v)
						if (entity.nutAmmo) then
							for k2, v2 in ipairs(entity.nutAmmo) do
								if v == v2[1] then
									self:SetAmmo(v2[2], tostring(k2))
								end
							end
						end
					end
					for k, v in ipairs(self:GetWeapons()) do
						v:SetClip1(0)
					end
				end

				if (self:isStuck()) then
					entity:DropToFloor()
					self:SetPos(entity:GetPos() + Vector(0, 0, 16))

					local positions = nut.util.findEmptySpace(
						self,
						{entity, self}
					)
					for k, v in ipairs(positions) do
						self:SetPos(v)

						if (!self:isStuck()) then
							return
						end
					end
				end
			end
		end)

		self:setLocalVar("blur", 25)
		self.nutRagdoll = entity

		entity.nutWeapons = {}
		entity.nutAmmo = {}
		entity.nutPlayer = self

		if (getUpGrace) then
			entity.nutGrace = CurTime() + getUpGrace
		end

		for k, v in ipairs(self:GetWeapons()) do
			entity.nutWeapons[#entity.nutWeapons + 1] = v:GetClass()
			local clip = v:Clip1()
			local reserve = self:GetAmmoCount(v:GetPrimaryAmmoType())
			local ammo = clip + reserve
			entity.nutAmmo[v:GetPrimaryAmmoType()] = {v:GetClass(), ammo}
		end

		self:GodDisable()
		self:StripWeapons()
		self:Freeze(true)
		self:SetNoDraw(true)
		self:SetNotSolid(true)
		self:SetMoveType(MOVETYPE_NONE)

		self:setLocalVar("ragdoll", entity:EntIndex())
		self:setLocalVar("unconscious", entity:EntIndex())
		self:getChar():setData("unconscious", entity:EntIndex())
		hook.Run("OnCharFallover", self, entity, true)
	elseif (IsValid(self.nutRagdoll)) then
		self.nutRagdoll:Remove()

		hook.Run("OnCharFallover", self, entity, false)
	end
end

function user:SetUnc()
		local unaffected = nut.faction.get(self:getChar():getFaction()).limbUnaffected;
		if unaffected then return end;

		self:setLocalVar("unc_giveup", false)
		self:getChar():setData("bleeding", false)
		self:SetHealth(50);
		self:SetNoTarget(true)
		self:setUnconsious(true)
		self:GodEnable()

		self.damageImmunity = CurTime() + 2;

		local uniqueID = "Die: " .. self:SteamID()
		timer.Create(uniqueID, 20, 1, function()
				if !timer.Exists(uniqueID) || !self:IsValid() || !self:getLocalVar("unconscious") then timer.Remove(uniqueID) return; end;
				self:setLocalVar("unc_giveup", true)
		end);
end;