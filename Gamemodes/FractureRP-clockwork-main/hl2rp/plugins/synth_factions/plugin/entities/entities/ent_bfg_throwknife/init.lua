AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')
function ENT:Initialize()
	self.Owner = self.Entity:GetOwner()
	if !IsValid(self.Owner) then
		self:Remove()
		return
	end
	self:SetModel("models/weapons/w_knife_t.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	local phys = self.Entity:GetPhysicsObject()
	self.NextThink = CurTime() + 1
	self.Entity:DrawShadow(false)
	if IsValid(phys) then
		phys:Wake()
		phys:SetMass(10)
	end
	util.PrecacheSound("physics/metal/metal_grenade_impact_hard3.wav")
	util.PrecacheSound("physics/metal/metal_grenade_impact_hard2.wav")
	util.PrecacheSound("physics/metal/metal_grenade_impact_hard1.wav")
	util.PrecacheSound("physics/flesh/flesh_impact_bullet1.wav")
	util.PrecacheSound("physics/flesh/flesh_impact_bullet2.wav")
	util.PrecacheSound("physics/flesh/flesh_impact_bullet3.wav")
	self.Hit = { 
	Sound("physics/metal/metal_grenade_impact_hard1.wav"),
	Sound("physics/metal/metal_grenade_impact_hard2.wav"),
	Sound("physics/metal/metal_grenade_impact_hard3.wav")};
	self.FleshHit = { 
	Sound("physics/flesh/flesh_impact_bullet1.wav"),
	Sound("physics/flesh/flesh_impact_bullet2.wav"),
	Sound("physics/flesh/flesh_impact_bullet3.wav")}
	self:GetPhysicsObject():SetMass(2)	
	self.Entity:SetUseType(SIMPLE_USE)
end

function ENT:PhysicsCollide(data, phys)
	
	local Ent = data.HitEntity
	if !(IsValid(Ent) or Ent:IsWorld()) then return end
	if Ent:IsWorld() then
		util.Decal("ManhackCut", data.HitPos + data.HitNormal, data.HitPos - data.HitNormal)
		if self.Entity:GetVelocity():Length() > 400 then
			self:EmitSound("npc/roller/blade_out.wav", 60)
		else
			self:EmitSound(self.Hit[math.random(1, #self.Hit)])
		end
		self:Disable()
	elseif Ent.Health then
		if !(Ent:IsPlayer() or Ent:IsNPC() or Ent:GetClass() == "prop_ragdoll") then 
			util.Decal("ManhackCut", data.HitPos + data.HitNormal, data.HitPos - data.HitNormal)
			self:EmitSound(self.Hit[math.random(1, #self.Hit)])
			self:Disable()
		end
		Ent:TakeDamage(420, self:GetOwner())
		if (Ent:IsPlayer() or Ent:IsNPC() or Ent:GetClass() == "prop_ragdoll") then 
			local effectdata = EffectData()
			effectdata:SetStart(data.HitPos)
			effectdata:SetOrigin(data.HitPos)
			effectdata:SetScale(1)
			util.Effect("BloodImpact", effectdata)
			self:EmitSound(self.FleshHit[math.random(1,#self.Hit)])
			self:Remove()
		end
	end
	self.Entity:SetOwner(NUL)
end

function ENT:Think()
	self.lifetime = self.lifetime or CurTime() + 10
	if CurTime() > self.lifetime then
		self:Remove()
	end
end
function ENT:Disable()
	self.PhysicsCollide = function() end
	self.lifetime = CurTime() + 10
	self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
end

function ENT:Use(activator, caller)
	self.Entity:Remove()
end
