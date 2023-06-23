local PLUGIN = PLUGIN

PLUGIN.name = "Броня & Защита"
PLUGIN.author = "Ross Cattero"
PLUGIN.description = "Набор механик, которые вносят системы защиты и брони для персонажей."

PLUGIN.debug = true;

ix.util.Include("sh_meta.lua")
ix.util.Include("sv_meta.lua")
ix.util.Include("sv_plugin.lua")
ix.util.Include("cl_plugin.lua")

function PLUGIN:HitBone(trace)
	local ent, pbone = trace.Entity, trace.PhysicsBone
	if !ent:IsValid() then return false; end;
	local bone = ent:TranslatePhysBoneToBone( pbone )
	if !ent.bones then return end;

	return ent.bones[ bone ] or 0;
end;