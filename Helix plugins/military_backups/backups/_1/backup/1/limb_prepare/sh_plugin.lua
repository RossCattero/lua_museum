local PLUGIN = PLUGIN

PLUGIN.name = "Limbs - bones"
PLUGIN.author = "Ross Cattero"
PLUGIN.description = ""

ix.util.Include("sh_meta.lua")
ix.util.Include("sv_plugin.lua")
ix.util.Include("sv_meta.lua")

LimbBody = {}
local limbPath = "materials/limbs/"
local limbs = file.Find( limbPath.."*.png", "GAME" )
local i = #limbs;
while (i > 0) do
		local limb = limbs[i]
		local isBody = limb:match("body");

		LimbBody[ isBody && "body" || i ] = Material( limbPath..limb );
		resource.AddFile( limbPath..limb )
		i = i - 1;
end;

dropMat = Material("materials/source/drop.png")
resource.AddFile( "materials/source/drop.png" )

PLUGIN.limbs = {
	{index = "head", name = "Голова"},
	{index = "chest", name = "Грудь"},
	{index = "stomach", name = "Живот"},
	{index = "right_arm", name = "Правая рука"},
	{index = "left_arm", name = "Левая рука"},
	{index = "right_hand", name = "Правая ладонь"},
	{index = "left_hand", name = "Левая ладонь"},
	{index = "right_leg", name = "Правая нога"},
	{index = "left_leg", name = "Левая нога"},
	{index = "right_foot", name = "Правая ступня"},
	{index = "left_foot", name = "Левая ступня"},
}

PLUGIN.bones = PLUGIN.bones || {
	{bone = "foot", parent = "foot"},
	{bone = "leg", parent = "leg"},
	{bone = "calf", parent = "leg"}, 
	{bone = "thigh", parent = "leg"},
	{bone = "toe", parent = "foot"},
	{bone = "trapezius", parent = "chest"},
	{bone = "spine", parent = "chest"},
	{bone = "pectoral", parent = "chest"},
	{bone = "pelvis", parent = "stomach"},
	{bone = "body", parent = "chest"},
	{bone = "latt", parent = "chest"},
	{bone = "neck", parent = "head"},
	{bone = "arm", parent = "arm"},
	{bone = "upperarm", parent = "arm"},
	{bone = "forearm", parent = "arm"},
	{bone = "hand", parent = "hand"},
	{bone = "shoulder", parent = "arm"},
	{bone = "wrist", parent = "hand"},
	{bone = "head", parent = "head"},
}

function HitBone(trace)
	local ent, pbone = trace.Entity, trace.PhysicsBone
	if !ent:IsValid() then return false; end;
	local bone = ent:TranslatePhysBoneToBone( pbone )
	local bones = ent:GetLocalVar("Bones")

	return bones && bones[ bone ] or 0;
end;

function PLUGIN:HUDPaint()
		local ply = LocalPlayer();
		if !ply:GetCharacter() then return end;
		if ix.bar.Get("health") then ix.bar.Remove("health") end;
		if ix.bar.Get("armor") then ix.bar.Remove("armor") end; 
end;