local PLUGIN = PLUGIN;
local user = FindMetaTable("Player")

function user:createMovableCopy(parent)
	if !IsValid(parent) then return end;

	local entity = ents.Create("prop_dynamic")
	entity:SetPos(self:GetPos())
	entity:SetAngles(self:EyeAngles())
	entity:SetModel(self:GetModel())
	entity:SetSkin(self:GetSkin())
	entity.bgs = {};
	for k, v in pairs(self:GetBodyGroups()) do
			if entity:IsValid() then
				entity:SetBodygroup(k, self:GetBodygroup(k))
				entity.bgs[k] = self:GetBodygroup(k)
			end;
	end
	entity:SetMoveType(MOVETYPE_NONE)
	entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	entity:Spawn()
	entity:Activate()
	entity:setNetVar("player", self)

	if entity.ResetSequence then
			entity:ResetSequence( "LineIdle01" )
	end
	
	local velocity = self:GetVelocity()

	for i = 0, entity:GetPhysicsObjectCount() - 1 do
		local physObj = entity:GetPhysicsObjectNum(i)
		if (IsValid(physObj)) then
			local index = entity:TranslatePhysBoneToBone(i)
			if (index) then
				local position, angles = self:GetBonePosition(index)

				physObj:SetPos(position)
				physObj:SetAngles(angles)
			end
			physObj:EnableMotion(false)
		end
	end

	entity:CallOnRemove("fixer", function()
			if (IsValid(self)) then
				self:setNetVar("grabRag", nil)
				parent:setLocalVar("grabbing", nil)
				self:setLocalVar("grabbing", nil)
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

			end
	end)
	
	entity.nutWeapons = {}
	entity.nutAmmo = {}
	entity.nutPlayer = self

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

	self:setNetVar("grabRag", entity:EntIndex())
	self:setLocalVar("grabbing", parent)
	parent:setLocalVar("grabbing", self)

	parent.grabEntity = entity
	return entity
end

function user:Cuff(state)
		self:setRestricted(state);
		self:getChar():setData("cuffed", state)
		self:setNetVar("cuffed", state)
		self:setLocalVar('restrictNoMsg', !state)
end;

function user:StopGrab()
	if IsValid(self.grabEntity) then
		local ply = self.grabEntity:getNetVar("player")
		ply:SetPos(self.grabEntity:GetPos())
		ply:SetAngles(self.grabEntity:EyeAngles())
		for k, v in pairs(self.grabEntity:GetBodyGroups()) do
			if ply:IsValid() then
					ply:SetBodygroup(k, self.grabEntity:GetBodygroup(k))
			end;
		end
		self.grabEntity:Remove()
	end;
end;