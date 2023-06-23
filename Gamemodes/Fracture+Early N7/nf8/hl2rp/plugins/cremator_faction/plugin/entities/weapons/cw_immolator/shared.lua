local sndAttackLoop = Sound("fire_large")
local sndSprayLoop = Sound("ambient.steam01")
local sndAttackStop = Sound("ambient/_period.wav")
local sndIgnite = Sound("PropaneTank.Burst")

SWEP.HoldType			= "normal"
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true
SWEP.ViewModel			= "Models/weapons/v_cremato2.mdl"
SWEP.WorldModel			= "models/Weapons/shell.mdl"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.UseHands = false

SWEP.Secondary.Recoil			= 0
SWEP.Secondary.Damage			= 3
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0.02
SWEP.Secondary.Delay			= 0.

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"
SWEP.NeverRaised = true


function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	self.EmittingSound = false
end

function SWEP:SecondaryAttack()

	local curtime = CurTime()

	self.Weapon:SetNextSecondaryFire( curtime + 0. )
	self.Weapon:SetNextPrimaryFire( curtime + 0. )
	
	if self.Owner:WaterLevel() > 1 then 
	self:StopSounds() 
	return end
	
	if not self.EmittingSound then
		self.Weapon:EmitSound(sndSprayLoop)
		self.EmittingSound = true
	end
	
	local PlayerVel = self.Owner:GetVelocity()
	local PlayerPos = self.Owner:GetShootPos()
	local PlayerAng = self.Owner:GetAimVector()
	
	local trace = {}
	trace.start = PlayerPos
	trace.endpos = PlayerPos + (PlayerAng*4096)
	trace.filter = self.Owner
	
	local traceRes = util.TraceLine(trace)
	local hitpos = traceRes.HitPos
	
	local jetlength = (hitpos - PlayerPos):Length()
	
		if jetlength > 568 then 
		jetlength = 568
		elseif self.DoShoot then
	
		local normal = traceRes.HitNormal

			if traceRes.HitNonWorld then
				local hitent = traceRes.Entity
				local enttype = hitent:GetClass()
				if hitent:IsNPC() or hitent:IsPlayer() or enttype == "prop_physics" or enttype == "prop_vehicle" then
					local hitenttable = hitent:GetTable()
					hitenttable.FuelLevel = hitenttable.FuelLevel or 0
					hitenttable.FuelLevel = hitenttable.FuelLevel + 1
					util.Decal("BeerSplash", hitpos + normal, hitpos - normal )
				end
			elseif Vector(0,0,1):Dot(normal) > 0.25 then --Garry's idea XD
				if SERVER then
					local nearbystuff = ents.FindInSphere(traceRes.HitPos, 6.5)
					for _, stuff in pairs(nearbystuff) do
						if stuff:GetClass() == 'sent_firecontroller' or stuff:GetClass() == 'env_fire' then
							return;
						end;
					end;
					local fire = ents.Create("sent_firecontroller") --Make an ignitable fire.
					fire:SetPos(hitpos + normal*16)
					fire:SetOwner(self.Owner)
					fire:Spawn()
				end
				util.Decal("BeerSplash", hitpos + normal, hitpos - normal )
			end
			
		self.DoShoot = false
		else
		self.DoShoot = true
		end

	if jetlength < 6 then jetlength = 6 end

	local effectdata = EffectData()
	effectdata:SetEntity( self.Weapon )
	effectdata:SetStart( PlayerPos )
	effectdata:SetNormal( PlayerAng )
	effectdata:SetScale( jetlength )
	effectdata:SetAttachment( 1 )
	util.Effect( "bp_gaspuffs", effectdata )
end

function SWEP:StopSounds()
	if self.EmittingSound then
		self.Weapon:StopSound(sndAttackLoop)
		self.Weapon:StopSound(sndSprayLoop)
		self.Weapon:EmitSound(sndAttackStop)
		self.EmittingSound = false
	end	
end

function SWEP:Precache()
	util.PrecacheModel("models/player/charple01.mdl")
	util.PrecacheSound("ambient/machines/keyboard2_clicks.wav")
	util.PrecacheSound("ambient/machines/thumper_dust.wav")
	util.PrecacheSound("ambient/fire/mtov_flame2.wav")
	util.PrecacheSound("ambient/fire/ignite.wav")
	util.PrecacheSound("vehicles/tank_readyfire1.wav")
end

function isneededNPC(class) 
	local tbl = {
		"npc_antlionguard", 
		"npc_hunter", 
		"npc_kleiner", 
		"npc_gman", 
		"npc_eli", 
		"npc_alyx", 
		"npc_mossman", 
		"npc_breen", 
		"npc_monk", 
		"npc_vortigaunt", 
		"npc_citizen", 
		"npc_rebel", 
		"npc_barney", 
		"npc_magnusson"
	}

	return table.HasValue(tbl, class)

end;

function MakeRagdollBlack(ragdoll)
	local randomCorpse = math.random(1, 4)
	if ragdoll:GetClass() == "prop_ragdoll" then
		if !ragdoll.goingToBeBlack then
			ragdoll.goingToBeBlack = 1
		end;
		ragdoll.goingToBeBlack = math.Clamp(ragdoll.goingToBeBlack * 3, 0, 255)
		if ragdoll.goingToBeBlack > 1 then
			ragdoll:SetColor( Color(255 - ragdoll.goingToBeBlack, 255 - ragdoll.goingToBeBlack, 255 - ragdoll.goingToBeBlack, 255) )
		end;
		if !timer.Exists(ragdoll:GetClass().." - "..ragdoll:EntIndex()) then
			timer.Create(ragdoll:GetClass().." - "..ragdoll:EntIndex(), 3, 1, function()
				if ragdoll:IsValid() then
					if ragdoll.imragdollflame then
						return;
					end;
					local rag = ents.Create("prop_ragdoll");
					rag:SetAngles(ragdoll:GetAngles() - Angle(90, 0, 0));
					rag:SetModel('models/Humans/Charple0'..randomCorpse..'.mdl');
					rag:SetPos(ragdoll:GetPos() + Vector(0, 0, 3));
					ragdoll:Remove();
					rag:Spawn();
					rag.imragdollflame = true
					rag:Ignite(math.random(16, 32), 100) 
				end;
			end)
		end;
	end;

end;

function SWEP:PrimaryAttack()

	self.Owner:MuzzleFlash()
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.08 )
	if SERVER then
		local trace = self.Owner:GetEyeTrace()
		local Distance = self.Owner:GetPos():Distance(trace.HitPos)

		if !self.EmittingSound then
			self.Weapon:EmitSound(sndAttackLoop)
			self.EmittingSound = true
		end

	if Distance < 520 then
		local Ignite = function()
			if !IsValid(self.Owner) then
				return false;
			end;
			local flame = ents.Create("point_hurt")
			flame:SetPos(trace.HitPos)
			flame:SetOwner(self.Owner)
			flame:SetKeyValue("DamageRadius",128)
			flame:SetKeyValue("Damage", 10)
			flame:SetKeyValue("DamageDelay",0.32)
			flame:SetKeyValue("DamageType",8)
			flame:Spawn()
			flame:Fire("TurnOn","",0) 
			flame:Fire("kill","",0.72)			
		if trace.HitWorld then
			local nearbystuff = ents.FindInSphere(trace.HitPos, 100)
			for _, stuff in pairs(nearbystuff) do
			if stuff != self.Owner then
				if stuff:GetPhysicsObject():IsValid() && !stuff:IsNPC() && !stuff:IsPlayer() && !stuff:IsOnFire() then
					stuff:Ignite(math.random(16, 32), 100) 
				end 
				if stuff:IsPlayer() && stuff:GetPhysicsObject():IsValid() then
					stuff:Ignite(1, 100) 
				end
				if stuff:IsNPC() && stuff:GetPhysicsObject():IsValid() then
					local npc = stuff:GetClass()
					if isneededNPC(npc) then
						stuff:Fire("Ignite","",1)
					end
					stuff:Ignite(math.random(12,16), 100)
				end;

				if stuff:GetClass() == 'prop_ragdoll' then
					MakeRagdollBlack(stuff)
				end;
			end
		end; end;
	if trace.Entity:IsValid() then
		if trace.Entity:IsPlayer() then
			trace.Entity:Ignite(math.random(1, 2), 100)
		elseif trace.Entity:IsNPC() then
			trace.Entity:Ignite(math.random(12, 16), 100)
		elseif !trace.Entity:IsNPC() or !trace.Entity:IsPlayer() then
			if !trace.Entity:IsOnFire() then 
				trace.Entity:Ignite(math.random(16,32), 100) 
			end
		end;

		if trace.Entity:GetClass() == "prop_ragdoll" then
			MakeRagdollBlack(trace.Entity)
		end;
	end;
end;
		local firefx = EffectData()
		firefx:SetOrigin(trace.HitPos)
		util.Effect("swep_flamethrower_explosion",firefx,true,true)
		timer.Simple(Distance/1520, Ignite)
	end;

end;
end;

function SWEP:Think()
	if self.Owner:KeyReleased(IN_ATTACK) && (self.ReloadDelay != 1) then
		self.Owner:EmitSound( "ambient/fire/mtov_flame2.wav", 24, 100 )
	end

	if (self.ReloadDelay == 0) && self.Owner:KeyPressed(IN_ATTACK) then
		self.Owner:EmitSound( "ambient/machines/thumper_dust.wav", 46, 100 )
	end

	if self.Owner:KeyDown(IN_ATTACK) then
		self.Owner:EmitSound( "ambient/fire/mtov_flame2.wav", math.random(27,35), math.random(32,152) )
		local trace = self.Owner:GetEyeTrace()
		local flamefx = EffectData()
		flamefx:SetOrigin(trace.HitPos)
		flamefx:SetStart(self.Owner:GetShootPos())
		flamefx:SetAttachment(1)
		flamefx:SetEntity(self.Weapon)
		util.Effect("swep_flamethrower_flame",flamefx,true,true)
	end

	if self.Owner:KeyReleased(IN_ATTACK) or self.Owner:KeyReleased(IN_ATTACK2) then
		self:StopSounds()
	end
end


function SWEP:Reload()	end

function SWEP:Holster()
	self:StopSounds()
	return true
end

function SWEP:OnRemove()
	self:StopSounds()
	return true
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW);
	self:SetNextPrimaryFire( CurTime() + self:SequenceDuration())
	self:SetNextSecondaryFire( CurTime() + self:SequenceDuration())
	self:Idle()
	return true
end

function SWEP:Holster( weapon )
	if ( CLIENT ) then return end
	self:StopIdle()
	return true
end

function SWEP:DoIdleAnimation()
	self:SendWeaponAnim( ACT_VM_IDLE )
end

function SWEP:DoIdle()
	self:DoIdleAnimation()

	timer.Adjust( "weapon_idle" .. self:EntIndex(), self:SequenceDuration(), 0, function()
		if ( !IsValid( self ) ) then timer.Destroy( "weapon_idle" .. self:EntIndex() ) return end

		self:DoIdleAnimation()
	end )
end

function SWEP:StopIdle()
	timer.Destroy( "weapon_idle" .. self:EntIndex() )
end

function SWEP:Idle()
	if ( CLIENT || !IsValid( self.Owner ) ) then return end
	timer.Create( "weapon_idle" .. self:EntIndex(), self:SequenceDuration() - 0.2, 1, function()
		if ( !IsValid( self ) ) then return end
		self:DoIdle()
	end )
end