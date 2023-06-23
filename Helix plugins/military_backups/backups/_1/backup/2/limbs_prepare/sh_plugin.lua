local PLUGIN = PLUGIN

PLUGIN.name = "Limbs: Prepare"
PLUGIN.author = Schema.author
PLUGIN.description = "Module for limbs system."

ix.util.Include("sv_plugin.lua")
ix.util.Include("meta/sh_meta.lua")
ix.util.Include("meta/sv_meta.lua")

LIMBS = LIMBS || {}

LIMBS.LIST = {
	{index = "head", name = "Голова"},
	{index = "chest", name = "Грудь"},
	{index = "stomach", name = "Живот"},
	{index = "left_arm", name = "Левая рука"},
	{index = "right_arm", name = "Правая рука"},
	{index = "right_hand", name = "Правая ладонь"},
	{index = "left_hand", name = "Левая ладонь"},
	{index = "right_leg", name = "Правая нога"},
	{index = "left_leg", name = "Левая нога"},
	{index = "right_foot", name = "Правая ступня"},
	{index = "left_foot", name = "Левая ступня"},
}
LIMBS.BONES = LIMBS.BONES || {
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

function LIMBS:HitBone(entity, pbone)
	if !entity:IsValid() then return false; end;
	local bone = entity:TranslatePhysBoneToBone( pbone )
	local bones = entity:GetLocalVar("Bones")

	return bones && bones[ bone ];
end;

function LIMBS:GetLimbByID(i)
	return self.list[i]
end;

-- === --
function PLUGIN:HUDPaint()
	local ply = LocalPlayer();
	if !ply:GetCharacter() then return end;
	if ix.bar.Get("health") then ix.bar.Remove("health") end;
	if ix.bar.Get("armor") then ix.bar.Remove("armor") end; 
end;

-- === --

LIMBS.images = {}
local limbPath = "materials/limbs/"
local limbs = file.Find( limbPath.."*.png", "GAME" )

for i = 1, #limbs do
	local limb = limbs[i]
	local isBody = limb:match("body");

	LIMBS.images[ isBody && "body" || limb:match("([%w_]+).png") ] = Material( limbPath..limb );
	resource.AddFile( limbPath..limb )
end;
LIMBS.bloodDrop = Material("materials/source/drop.png")
resource.AddFile( "materials/source/drop.png" )