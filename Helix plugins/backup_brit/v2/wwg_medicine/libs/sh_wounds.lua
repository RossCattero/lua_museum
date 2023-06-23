ix.medical.list = ix.medical.list || {}
ix.medical.instances = ix.medical.instances || {}
ix.medical.index = ix.medical.index or 0;
ix.medical.bleed_wounds_amount = ix.medical.bleed_wounds_amount || {}

function ix.medical.GetByIndex( index )
	return ix.medical.list[index]
end;

function ix.medical.LoadFromDir(directory)
	local files, folders = file.Find(directory.."/*", "LUA")

	for _, v in ipairs(files) do
		ix.medical.Load(directory.."/"..v)
	end
end

function ix.medical.Load(path)
	local uniqueID = path:match("sh_([_%w]+)%.lua")

	if (uniqueID) then
		ix.medical.Register(uniqueID, path)
	end
end

function ix.medical.BleedAmount( id, bone )
	return ix.medical.bleed_wounds_amount[ id ] && ix.medical.bleed_wounds_amount[ id ][ bone ]
end;

function ix.medical.Register(uniqueID, path)
	if (!uniqueID) then return; end
	
	WOUND = ix.medical.GetByIndex( uniqueID ) || setmetatable({}, ix.medical.meta)
	WOUND.uniqueID = uniqueID

	if (path) then ix.util.Include(path) end
	ix.medical.list[ WOUND.index ] = WOUND;

	if (IX_RELOADED) then
		for _, v in pairs(ix.medical.list) do
			if (v.uniqueID == uniqueID) then
				table.Merge(v, WOUND)
			end
		end
	end

	WOUND = nil
end

function ix.medical.New(index, id)
	local instance = ix.medical.instances[id];

	if (instance && instance.index == index) then return instance end;

	ix.medical.index = ix.medical.index + 1;
	id = id || ix.medical.index;

	local wound = ix.medical.GetByIndex(index)

	if (wound) then
		local wound = setmetatable(
		{
			id = id,
			data = {}
		}, 
		{
			__index = wound,
			__eq = wound.__eq,
			__tostring = wound.__tostring
		})

		ix.medical.instances[id] = wound

		return wound
	end
end;

function ix.medical.Create( index, charID, bone )
	local wound = ix.medical.New( index )
	wound.charID = charID;
	wound.bone = bone
	wound.occured = os.time()

	ix.medical.Insert( charID, bone, wound:GetID() )

	return wound;
end;

function ix.medical.Insert( charID, bone, woundID )
	if !charID then
		ErrorNoHalt( "Character id not found!" )
		return;
	end

	if !bone || (bone && !ix.medical.limbs.data[bone]) then
		ErrorNoHalt( "Bone is not valid!" )
		return;
	end

	if !woundID || (woundID && !ix.medical.instances[woundID]) then
		ErrorNoHalt( "Wound is not valid!" )
		return;
	end

	local wound = ix.medical.instances[woundID]
	ix.medical.bodies[ charID ][ bone ][ woundID ] = wound
	ix.medical.characters[ charID ][ woundID ] = wound;

	if wound:CanBleed() then
		if !ix.medical.bleed_wounds_amount[ charID ][ bone ] then
			ix.medical.bleed_wounds_amount[ charID ][ bone ] = 0;
		end

		ix.medical.bleed_wounds_amount[ charID ][ bone ] = ix.medical.bleed_wounds_amount[ charID ][ bone ] + 1;
	end;
end;