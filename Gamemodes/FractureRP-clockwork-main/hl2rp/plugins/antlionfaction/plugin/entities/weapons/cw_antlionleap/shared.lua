
if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )

	
end

if (CLIENT) then
	SWEP.Slot = 0;
	SWEP.SlotPos = 6;
	SWEP.DrawAmmo = false;
	SWEP.PrintName = "Antlion Leap";
	SWEP.DrawCrosshair = true;
end

SWEP.Author			= "NightAngel"
SWEP.Instructions = "Primary Fire: Leap";
SWEP.Purpose = "To cross distances quickly using your wings.";
SWEP.Contact = ""
SWEP.AdminSpawnable = false;
SWEP.Spawnable = false;
SWEP.ViewModel      = ""
SWEP.WorldModel   = ""
SWEP.HoldType = "melee"

SWEP.Primary.Delay			= 0.2 	--In seconds
SWEP.Primary.Recoil			= 0		--Gun Kick
SWEP.Primary.Damage			= 0	--Damage per Bullet
SWEP.Primary.NumShots		= 1		--Number of shots per one fire
SWEP.Primary.Cone			= 0 	--Bullet Spread
SWEP.Primary.ClipSize		= -1	--Use "-1 if there are no clips"
SWEP.Primary.DefaultClip	= -1	--Number of shots in next clip
SWEP.Primary.Automatic   	= false	--Pistol fire (false) or SMG fire (true)
SWEP.Primary.Ammo         	= "none"	--Ammo Type

SWEP.Secondary.NeverRaised = true;
SWEP.Secondary.DefaultClip = 0;
SWEP.Secondary.Automatic = false;
SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.Delay = 1;
SWEP.Secondary.Ammo	= "";
 
function SWEP:Think() -- Called every frame
	if self.isflying == true then
        if self.Owner:GetVelocity()[3] <= 0 and !self.islanding then
			self.islanding = true
        end
	
        if self.Owner:GetVelocity()[3] >= 0 and self.islanding then
		--[[
			hitpos = self.Owner:GetPos() - Vector(0,0,10)
			tokill = {}
			tokill.Num    = 20
			tokill.Src    = self.Owner:GetPos()
			tokill.Dir    = self.Owner:GetPos() - Vector(0,0,10)
			tokill.Spread = Vector(75, 75, 0)
			tokill.Tracer = 0
			tokill.Force  = 10
			tokill.Damage = 100
			self.Owner:FireBullets(tokill)
			--]]
			self.isflying = false
        end
	
	end

end

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType);
end

function SWEP:SecondaryAttack()
	return
end
 
function SWEP:PrimaryAttack()
	if !self.isflying then
		self.isflying = true
		self.islanding = false
		self.Owner:SetVelocity((self.Owner:GetUp() * 300) + (self.Owner:GetForward() * 1000));
	end;
	--[[
	if self.isflying then
		local tr = util.QuickTrace(self.Owner:GetShootPos(), (self.Owner:GetForward() * -60), self.Owner);
		if (tr.Hit) then
			self.Owner:ViewPunch(Angle(5, 0, 0));
			self.Owner:SetVelocity((self.Owner:GetForward() * 1000) + (self.Owner:GetUp() * 300));
		end;
	end;
	--]]
end;

function SWEP:Deploy()
	return true
end

function SWEP:Holster()
	return true
end