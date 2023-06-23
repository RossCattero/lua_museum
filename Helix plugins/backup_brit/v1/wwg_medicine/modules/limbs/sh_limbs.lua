local PLUGIN = PLUGIN

ix.medical.limbs = ix.medical.limbs || {}

ix.medical.limbs.bones = ix.medical.limbs.bones || {
	["foot"] = "leg",
	["leg"] = "leg",
	["calf"] = "leg",
	["thigh"] = "leg",
	["toe"] = "leg",

	["trapezius"] = "torso",
	["spine"] = "torso",
	["pectoral"] = "torso",
	["pelvis"] = "torso",
	["body"] = "torso",
	["latt"] = "torso",

	["neck"] = "head",
	["head"] = "head",

	["arm"] = "arm",
	["upperarm"] = "arm",
	["forearm"] = "arm",
	["hand"] = "arm",
	["shoulder"] = "arm",
	["wrist"] = "arm",
	["finger"] = "arm",
}

ix.medical.limbs.sideless = ix.medical.limbs.sideless || {
	["torso"] = true,
	["head"] = true
}

function ix.medical.limbs.FindBone(entity, bone)
	local res, bones = entity:TranslatePhysBoneToBone( bone ), entity:GetLocalVar("Bones")

	return bones && bones[ res ];
end;

function ix.medical.limbs.trace(entity)
	if !entity:IsValid() || !entity.GetShootPos then return end;
	local pos, angle = entity:GetShootPos(), entity:GetAimVector();

	return util.TraceLine({
		start = pos, 
		endpos = pos + (angle * 2048), 
		filter = entity
	});
end;