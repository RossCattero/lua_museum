ix.medical.limbs = ix.medical.limbs || {}
ix.medical.bodies = ix.medical.bodies || {}
ix.medical.characters = ix.medical.characters || {}

ix.medical.limbs.list = ix.medical.limbs.list || {
	[1] = "head",
	[2] = "torso",
	[3] = "torso",
	[4] = "l_arm",
	[5] = "r_arm",
	[6] = "l_leg",
	[7] = "r_leg"
}

ix.medical.limbs.names = ix.medical.limbs.names || {
	[1] = "Head",
	[2] = "Torso",
	[3] = "Torso",
	[4] = "Left arm",
	[5] = "Right arm",
	[6] = "Left leg",
	[7] = "Right leg"
}

ix.medical.limbs.data = ix.medical.limbs.data || {
	["head"] = {},
	["torso"] = {},
	["l_arm"] = {},
	["r_arm"] = {},
	["l_leg"] = {},
	["r_leg"] = {}
}

function ix.medical.limbs.Get( id )
	return ix.medical.limbs.list[ id ]
end;

function ix.medical.CreateBody(id)
	ix.medical.bodies[ id ] = table.Copy(ix.medical.limbs.data)
	ix.medical.characters[ id ] = {}
	ix.medical.bleed_wounds_amount[ id ] = {}
end;

function ix.medical.DeleteBody(id)
	ix.medical.bodies[ id ] = nil;
	ix.medical.characters[ id ] = nil;
	ix.medical.bleed_wounds_amount[ id ] = nil;

	for k, v in pairs( ix.medical.instances ) do
		if v.charID == id then
			v:Remove();
		end
	end
end;

function ix.medical.LoadBody( receiver, id )
	for k, v in pairs( ix.medical.FindCharacter(id) ) do
		v:Network( receiver )
	end
end;

function ix.medical.FindBody(id)
	return ix.medical.bodies[ id ]
end;

function ix.medical.FindCharacter(id)
	return ix.medical.characters[ id ]
end;

function ix.medical.trace(entity)
	if !entity:IsValid() || !entity.GetShootPos then return end;
	local pos, angle = entity:GetShootPos(), entity:GetAimVector();

	return util.TraceLine({
		start = pos, 
		endpos = pos + (angle * 2048), 
		filter = entity
	});
end;