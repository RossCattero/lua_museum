if (SERVER) then
	AddCSLuaFile("shared.lua");
end;
if (CLIENT) then
	SWEP.Slot = 1;
	SWEP.SlotPos = 1;
	SWEP.DrawAmmo = false;
	SWEP.PrintName = "Лазер";	
	-- local Laser = Material( "cable/redlaser" )
	-- function SWEP:Draw()
	-- 	self:DrawModel() 
	-- 	local player = self.Owner;  local trace = player:GetEyeTraceNoCursor()
	-- 	local startpos, hit = player:GetShootPos(), trace.HitPos
	-- 	local victim, Distance = trace.Entity, player:GetPos():Distance(hit)
	-- 	render.SetMaterial( Laser )
	-- 	render.DrawBeam( startpos, hit, 5, 1, 1, Color( 255, 255, 255, 255 ) ) 
	-- end 
end;

SWEP.Instructions = "ЛКМ: Лазер. ПКМ: Удар холодным оружием";
SWEP.Purpose = "";

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
SWEP.NeverRaised = true

function SWEP:PrimaryAttack()
	local player = self.Owner;  local trace = player:GetEyeTraceNoCursor()
	local startpos, hit = player:GetShootPos(), trace.HitPos
	local victim, Distance = trace.Entity, player:GetPos():Distance(hit)
	local hitpos, normal = trace.HitPos, trace.HitNormal
	
	if victim && Distance < 256 then
		local eyesSparks = EffectData()
		eyesSparks:SetEntity( self )
		eyesSparks:SetStart( startpos )
		eyesSparks:SetOrigin( hit )
		util.Effect( "StunstickImpact", eyesSparks )
		util.Decal("FadingScorch", hitpos + normal, hitpos - normal )
	end;

	if (!SERVER) then
		return;
	end;
end;

function SWEP:SecondaryAttack()
	if (!SERVER) then
		return;
	end;

end;


function SWEP:Think()
end;
