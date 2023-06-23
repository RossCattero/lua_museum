if (SERVER) then
	AddCSLuaFile("shared.lua");
end;

local sndAttackLoop = Sound("ambient/fire/fire_big_loop1.wav");
local sndSprayLoop = Sound('ambient/gas/steam_loop1.wav')

if CLIENT then
	SWEP.PrintName			= "Огнемет"	
	SWEP.Slot			= 1
	SWEP.SlotPos			= 1
	function SWEP:DrawWorldModel() end
end;

SWEP.BounceWeaponIcon		= false
SWEP.Author						= "Ross"
SWEP.Spawnable					= true
SWEP.AdminSpawnable				= true
SWEP.ViewModel			= "models/weapons/v_cremato2.mdl"
SWEP.WorldModel			= "models/weapons/w_immolator.mdl"
SWEP.ViewModelFOV      			= 65
SWEP.HoldType					= "normal"
SWEP.FiresUnderwater            = false
SWEP.Primary.Automatic			= true
SWEP.Primary.ClipSize			= -1
SWEP.Primary.DefaultClip		= -1
SWEP.Primary.Ammo				= "none"
SWEP.Secondary.ClipSize			= -1
SWEP.Secondary.DefaultClip		= -1
SWEP.Secondary.Automatic		= true
SWEP.Secondary.Ammo				= "none"
SWEP.ReloadDelay 				= 0
SWEP.NeverRaised = true

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
	self.EmittingSound = false
end

function SWEP:TransformEntity(ent)
	local randomCorpse = math.random(1, 3)
	if ent:GetClass() == "prop_ragdoll" then
		if !ent.goingToBeBlack then
			ent.goingToBeBlack = 1
		end;
		ent.goingToBeBlack = math.Clamp(ent.goingToBeBlack * 2, 0, 2000)

		if ent.goingToBeBlack == 2000 then
			if ent:IsValid() then
				if ent.imragdollflame then
					return;
				end;
				local rag = ents.Create("prop_ragdoll");
				rag:SetAngles(ent:GetAngles() - Angle(90, 0, 0));
				rag:SetModel('models/Humans/Charple0'..randomCorpse..'.mdl');
				rag:SetPos(ent:GetPos() + Vector(0, 0, 3));
				ent:Remove();
				rag:Spawn();
				rag.imragdollflame = true
				rag:Ignite(math.random(16, 32), 100) 
			end;
		end;
	end;
end;

function SWEP:PrimaryAttack()

	if !self.EmittingSound then
		self.Weapon:EmitSound( sndAttackLoop, 46, 100 )
		self.EmittingSound = true
	end
	if SERVER then
		local trace = self.Owner:GetEyeTrace() local Distance = self.Owner:GetPos():Distance(trace.HitPos)
		local vec, ang = self.Owner:GetBonePosition( 61 )
		self.Owner:MuzzleFlash()
		self.Weapon:SetNextPrimaryFire( CurTime() + 0. )
		local flames = EffectData()
		flames:SetOrigin(trace.HitPos)
		flames:SetStart(vec)
		flames:SetAttachment(1)
		flames:SetEntity(self.Weapon)
		util.Effect("weapon_752_m2_flame", flames, true, true)
		if Distance < 520 then
			local Ignite = function()
				local flame = ents.Create("point_hurt")
				flame:SetPos(trace.HitPos)
				flame:SetOwner(self.Owner)
				flame:SetKeyValue("DamageRadius", 128)
				flame:SetKeyValue("Damage", 18)
				flame:SetKeyValue("DamageDelay", 0.2)
				flame:SetKeyValue("DamageType", 8)
				flame:Spawn()
				flame:Fire("TurnOn", "", 0) 
				flame:Fire("kill", "", 0.72)
				if trace.HitWorld then
					for _, stuff in pairs(ents.FindInSphere(trace.HitPos, 100)) do
						if stuff != self.Owner && stuff:GetPhysicsObject():IsValid() then
							if stuff:IsNPC() then
								stuff:Ignite(math.random(12, 16), 100)
							end;
							if stuff:IsPlayer() then
								stuff:Ignite(1, 100) 
							end
							if !stuff:IsNPC() && !stuff:IsPlayer() && !stuff:IsOnFire() then
								stuff:Ignite(math.random(16, 32), 100) 
							end 
							if stuff:GetClass() == 'prop_ragdoll' then
								self:TransformEntity(stuff)
							end;
						end;
					end;
				end;
				if trace.Entity:IsValid() then
					if trace.Entity:IsPlayer() then
						trace.Entity:Ignite(math.random(1, 2), 100)
					elseif trace.Entity:IsNPC() then
						trace.Entity:Ignite(math.random(12, 16), 100)
					elseif !trace.Entity:IsNPC() or !trace.Entity:IsPlayer() then
						if !trace.Entity:IsOnFire() then 
							trace.Entity:Ignite(math.random(16, 32), 100) 
						end
					end;
					if trace.Entity:GetClass() == 'prop_ragdoll' then
						self:TransformEntity(trace.Entity)
					end;
				end;
			end;
			timer.Simple(Distance/1520, Ignite)
		end;
	end;
end;
function SWEP:SecondaryAttack()

	if !self.EmittingSound then
		self.Weapon:EmitSound(sndSprayLoop)
		self.EmittingSound = true
	end
	local vec, ang = self.Owner:GetBonePosition( 61 )
	local PlayerVel, PlayerPos, PlayerAng = self.Owner:GetVelocity(), self.Owner:GetShootPos(), self.Owner:GetAimVector()
	local trace = {}
	trace.start = PlayerPos
	trace.endpos = PlayerPos + (PlayerAng*4096)
	trace.filter = self.Owner
	local traceRes = util.TraceLine(trace)	
	local hitpos, normal = traceRes.HitPos, traceRes.HitNormal
	if SERVER then
		local function canplaceFlames(t)
			for _, stuff in pairs(ents.FindInSphere(t.HitPos, 6.5)) do
				if stuff:GetClass() == 'sent_firecontroller' or stuff:GetClass() == 'env_fire' then
					return true;
				end;
			end;
	
			return false
		end;
		if traceRes.HitWorld && Vector(0, 0, 1):Dot(normal) > 0.25 && !canplaceFlames(traceRes) then
			local fire = ents.Create("sent_firecontroller")
			fire:SetPos(hitpos + normal*16)
			fire:SetOwner(self.Owner)
			fire:Spawn()
		end;
	end;
	local effectdata = EffectData()
	effectdata:SetEntity( self.Weapon )
	effectdata:SetStart( vec )
	effectdata:SetNormal( PlayerAng )
	effectdata:SetScale( 568 )
	effectdata:SetAttachment( 1 )
	util.Effect( "bp_gaspuffs", effectdata )
	util.Decal("BeerSplash", hitpos + normal, hitpos - normal )
end;

function SWEP:StopSounds()
	if self.EmittingSound then
		self.Weapon:StopSound(sndAttackLoop)
		self.Weapon:StopSound(sndSprayLoop)
		self.EmittingSound = false
	end	
end

function SWEP:Think()

	if self.Owner:KeyReleased(IN_ATTACK) then
		self:StopSounds()
	end;
	if self.Owner:KeyReleased(IN_ATTACK2) then
		self:StopSounds()
	end;
end

function SWEP:Holster()
	self:StopSounds()
	return true
end

function SWEP:OnRemove()
	self:StopSounds()
	return true
end