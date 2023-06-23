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

function SWEP:Reload()
	if self.GrenadeReloaded and CurTime() < self.GrenadeReloaded then
		return;
	end;
	if !self.GrenadeReloaded or CurTime() >= self.GrenadeReloaded then
		self.GrenadeReloaded = CurTime() + 30;
	end;

	if SERVER then
		local pos = self.Owner:GetShootPos()
		pos = pos + self.Owner:GetForward() * 0
		pos = pos + self.Owner:GetRight() * -10
		pos = pos + self.Owner:GetUp() * -5

		local grenade = ents.Create("prop_physics")
		grenade:SetModel('models/weapons/w_npcnade.mdl')
		grenade:SetAngles(self.Owner:EyeAngles())
		grenade:SetPos(pos)
		grenade:SetOwner(self.Owner)
		grenade:SetPhysicsAttacker(self.Owner)
		grenade:Spawn()
		grenade:Activate()
		local phys = grenade:GetPhysicsObject()
		phys:SetVelocity(self.Owner:GetAimVector() * 1776)
		phys:AddAngleVelocity(Vector(0, 500, 0))

		timer.Simple(4, function()
			if (IsValid(grenade)) then
				local effectData = EffectData();
				effectData:SetStart(grenade:GetPos());
				effectData:SetOrigin(grenade:GetPos());
				effectData:SetScale(16);
				util.Effect("Explosion", effectData, true, true);
				for i = 1, 12 do
					local fire = ents.Create( "env_fire" )
					fire:SetPos( grenade:GetPos() + Vector( math.random( -70, 70 ), math.random( -70, 70 ), 0 ) )
					fire:SetKeyValue( "health", math.random( 15, 25 ) )
					fire:SetKeyValue( "firesize", "30" )
					fire:SetKeyValue( "fireattack", "8" )
					fire:SetKeyValue( "damagescale", "2.0" )
					fire:SetKeyValue( "StartDisabled", "0" )
					fire:SetKeyValue( "firetype", "0" )
					fire:SetKeyValue( "spawnflags", "132" )
					fire:Spawn()
					fire:Fire( "StartFire", "", 0.2 )
				end
				grenade:EmitSound("physics/body/body_medium_impact_soft"..math.random(1, 7)..".wav");
				grenade:Remove();
			end;
		end);
	end;

end;

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

function SWEP:CanPrimaryAttack()
	print(self.Owner:KeyDown(IN_ATTACK2))
	if self.Owner:KeyDown(IN_ATTACK2) then
		return false;
	end;

	return true;
end;

function SWEP:PrimaryAttack()
	if !self:CanPrimaryAttack() then
		return;
	end;

	if !self.EmittingSound then
		self.Weapon:EmitSound( sndAttackLoop, 100, 100 )
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
				flame:SetKeyValue("DamageRadius", 64)
				flame:SetKeyValue("Damage", 10)
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
							if stuff:IsPlayer() && stuff:GetFaction() != FACTION_CREMATOR then
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

function SWEP:CanSecondaryAttack()
	print(self.Owner:KeyDown(IN_ATTACK))
	if self.Owner:KeyDown(IN_ATTACK) then
		return false;
	end;

	return true;
end;

function SWEP:SecondaryAttack()

	if !self:CanSecondaryAttack() then
		return;
	end;

	local vec, ang = self.Owner:GetBonePosition( 61 )
	local PlayerVel, PlayerPos, PlayerAng = self.Owner:GetVelocity(), self.Owner:GetShootPos(), self.Owner:GetAimVector()
	local trace = {}
	trace.start = PlayerPos
	trace.endpos = PlayerPos + (PlayerAng*4096)
	trace.filter = self.Owner
	local traceRes = util.TraceLine(trace)	
	local hitpos, normal = traceRes.HitPos, traceRes.HitNormal
	local Distance = self.Owner:GetPos():Distance(hitpos)

	if Distance > 526 then
		return;
	end;

	if !self.EmittingSound then
		self.Weapon:EmitSound(sndSprayLoop, 100)
		self.EmittingSound = true
	end

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