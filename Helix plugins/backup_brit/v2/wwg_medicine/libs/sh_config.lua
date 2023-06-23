ix.medical = ix.medical || {}

ix.medical.config = ix.medical.config || {}

ix.medical.config.multiply = {
	head = 1.5,
	torso = 1.2
}

ix.medical.config.bleed = {
	time = 0,
	damage = 0,
}

ix.medical.config.bleedTime = {
	["head"] = 240,
	["torso"] = 240,
	["l_arm"] = 180,
	["r_arm"] = 180,
	["l_leg"] = 180,
	["r_leg"] = 180
}

ix.medical.config.bleedDamage = {
	["head"] = 2,
	["torso"] = 2,
	["l_arm"] = 1,
	["r_arm"] = 1,
	["l_leg"] = 1,
	["r_leg"] = 1
}

function ix.medical.Multiply( bone )
	return ix.medical.config.multiply[ bone ]
end;