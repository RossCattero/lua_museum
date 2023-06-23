if SERVER then
	AddCSLuaFile( "shared.lua" )
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= true
        SWEP.Base			= "weapon_base"
end

if CLIENT then
	
	SWEP.Category = "HL2 Beta Sweps"
	SWEP.PrintName = "Guard Gun"	
	SWEP.Slot = 5
	SWEP.SlotPos = 4
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
	SWEP.ViewModelFOV = 58
	SWEP.ViewModelFlip = false

	SWEP.DrawWeaponInfoBox	= false
	SWEP.BounceWeaponIcon = false 
	function SWEP:DrawWorldModel() end
end

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_gu4rdgun.mdl"
SWEP.WorldModel			= "models/weapons/w_guardgun.mdl"
SWEP.HoldType					= "normal"
SWEP.NeverRaised = true

SWEP.Cannon = {}
SWEP.Cannon.ShootSound		= Sound("weapons/1cguard/cguard_fire.wav")
SWEP.Cannon.ChargeSound		= Sound("weapons/1cguard/charging.wav")
SWEP.Cannon.BoomSound		= Sound("Weapon_Mortar.Impact")
SWEP.Cannon.Damage			= 500
SWEP.Cannon.Radius			= 350
SWEP.Cannon.Delay			= 2
SWEP.Cannon.Recoil			= 8

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic	= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW);
	self:SetNextPrimaryFire( CurTime() + self:SequenceDuration())
	self:SetNextSecondaryFire( CurTime() + self:SequenceDuration())
	self:NextThink( CurTime() + self:SequenceDuration() )
	self:Idle()
	return true
end

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType) self.Charging = false
end


function SWEP:PrimaryAttack()

	self.Weapon:SetNextSecondaryFire(CurTime() + 1.35 + self.Cannon.Delay)
	self.Weapon:SetNextPrimaryFire(CurTime() + 1.35 + self.Cannon.Delay)

	self.Weapon:EmitSound(self.Cannon.ChargeSound)
		
	local fx = EffectData()
	fx:SetEntity(self.Owner)
	fx:SetAttachment(1)
	util.Effect("bp_guardgun_charge", fx)
	
	self.Charging = true
	
	if CLIENT then return end
	timer.Simple(1.35, function() self:ShootCannon() end)

end

function SWEP:ShootCannon()

	if not self.Charging then return end
	if not self.Weapon or not self.Weapon:IsValid() then return end
	if not self.Owner or not self.Owner:Alive() then return end

	local PlayerPos = self.Owner:GetShootPos() 
	local tr = self.Owner:GetEyeTrace()
	local dist = (tr.HitPos - PlayerPos):Length()
	local delay = dist/8000
	
	self.Weapon:EmitSound(self.Cannon.ShootSound)
	
	local fx = EffectData()
	fx:SetEntity(self.Owner)
	fx:SetAttachment(1)
	util.Effect("bp_guardgun_fire",fx)
	util.Effect("bp_guardgun_mzzlflash",fx)
	
	--play animations
	self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	
	--apply recoil
	self.Owner:ViewPunch( Angle(math.Rand(-0.2,-0.1)*self.Cannon.Recoil,math.Rand(-0.1,0.1)*self.Cannon.Recoil, 0))
	
	timer.Simple(delay, function() self:Disintegrate(tr) end)

end

function SWEP:Disintegrate(tr)

	local fx = EffectData()
	fx:SetOrigin(tr.HitPos)
	fx:SetNormal(tr.HitNormal)
	util.Effect("bp_guardgun_expld",fx)
	
	if CLIENT then return end

	local splodepos = tr.HitPos + 3*tr.HitNormal

	local vaporizer = ents.Create("point_hurt")
	vaporizer:SetKeyValue("Damage",self.Cannon.Damage)
	vaporizer:SetKeyValue("DamageRadius",self.Cannon.Radius)
	vaporizer:SetKeyValue("DamageType",DMG_DISSOLVE)// DMG_BLAST)
	vaporizer:SetPos(splodepos)
	vaporizer:SetOwner(self.Owner)
	vaporizer:Spawn()
	vaporizer:Fire("hurt","",0)
	vaporizer:Fire("kill","",0.1)
	
	vaporizer:EmitSound(self.Cannon.BoomSound)
end

function SWEP:SecondaryAttack()

end


function SWEP:Think()
	self.Owner:SetBodygroup(1, 1)
	if ( self.Owner:KeyReleased( IN_ATTACK ) || ( !self.Owner:KeyDown( IN_ATTACK ) && self.Sound ) ) then		
		self:Idle()
	end
end


local StriderBulletCallback = function(attacker, tr, dmginfo)

	local fx = EffectData()
	fx:SetOrigin(tr.HitPos)
	fx:SetNormal(tr.HitNormal)
	fx:SetScale(20)
	util.Effect("cball_bounce",fx)
	util.Effect("AR2Impact",fx)

	return true

end

function SWEP:ShootStriderBullet(dmg, recoil, numbul, cone)

	--send the bullet
	local bullet 		= {} 
	bullet.Num			= numbul 
	bullet.Src			= self.Owner:GetShootPos() 
	bullet.Dir			= self.Owner:GetAimVector()
	bullet.Spread		= Vector(cone,cone,0) 
	bullet.Tracer		= 1	 
	bullet.TracerName 	= "AirboatGunTracer"
	bullet.Force		= 0.5*dmg
	bullet.Damage 		= dmg 
	bullet.Callback		= StriderBulletCallback
	self.Owner:FireBullets(bullet)

	--play animations
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	
	--apply recoil
	self.Owner:ViewPunch( Angle(math.Rand(-0.2,0.1)*recoil,math.Rand(-0.1,0.1)*recoil, 0))

end

function SWEP:StopCharging()

	self:StopSound(self.Cannon.ChargeSound)
	self.Charging = false

end

function SWEP:Holster(wep) 		self:StopCharging() 	return true end
function SWEP:Equip(NewOwner) 	self:StopCharging() 	return true end
function SWEP:OnRemove() 		self:StopCharging() 	return true end
function SWEP:OnDrop() 			self:StopCharging() 	return true end
function SWEP:OwnerChanged() 	self:StopCharging() 	return true end

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