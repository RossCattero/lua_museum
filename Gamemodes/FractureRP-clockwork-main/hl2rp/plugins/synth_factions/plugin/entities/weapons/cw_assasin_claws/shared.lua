if (SERVER) then
	AddCSLuaFile("shared.lua");
end;
if (CLIENT) then
	SWEP.Slot = 1;
	SWEP.SlotPos = 1;
	SWEP.DrawAmmo = false;
	SWEP.PrintName = "Когти";	
end;

SWEP.Instructions = "ЛКМ: Атаковать. ПКМ: Бросить нож";
SWEP.Purpose = "Позволяют атаковать других или защищаться.";

SWEP.Spawnable = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.ViewModel = "";
SWEP.WorldModel = "";

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.DrawAmmo = false
SWEP.HitDistance = 48
SWEP.NeverRaised = true

function SWEP:PrimaryAttack()
	if (!SERVER) then
		return;
	end;

	local player = self.Owner; local currentAnim = player:GetForcedAnimation()
	if player:GetVelocity() == Vector(0, 0, 0) then
		if (currentAnim and currentAnim.animation != "stab") then player:SetForcedAnimation(false); end;
		player:SetForcedAnimation('stab', 1)
	end;
	player:EmitSound('weapons/slam/throw.wav')
	local trace = player:GetEyeTraceNoCursor()
	local victim = trace.Entity;
	local Distance = player:GetPos():Distance(trace.HitPos)
	if victim && Distance < 128 then
		player:EmitSound('weapons/crossbow/hitbod2.wav')
		victim:TakeDamageInfo(Clockwork.kernel:FakeDamageInfo(math.random(25, 35), self, self.Owner, trace.HitPos, DMG_SLASH, 2));
	end;
	self:SetNextPrimaryFire( CurTime() + 1.5)
end;

function SWEP:SecondaryAttack()
	if (!SERVER) then
		return;
	end;

	local player = self.Owner; local currentAnim = player:GetForcedAnimation()
	if player:GetVelocity() == Vector(0, 0, 0) then
		if (currentAnim and currentAnim.animation != "knife") then player:SetForcedAnimation(false); end;
		player:SetForcedAnimation('knife', 1)
	end;

	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
	local knife = ents.Create("ent_bfg_throwknife")
	knife:SetAngles(self.Owner:EyeAngles())
	local pos = self.Owner:GetShootPos()
	pos = pos + self.Owner:GetForward() * 0
	pos = pos + self.Owner:GetRight() * -10
	pos = pos + self.Owner:GetUp() * -5
	knife:SetPos(pos)
	knife:SetOwner(self.Owner)
	knife:SetPhysicsAttacker(self.Owner)
	knife:Spawn()
	knife:Activate()
	local phys = knife:GetPhysicsObject()
	phys:SetVelocity(self.Owner:GetAimVector() * 1776)
	phys:AddAngleVelocity(Vector(0, 500, 0))

	self:SetNextPrimaryFire( CurTime() + 1.5) self:SetNextSecondaryFire( CurTime() + 60 )
end;
