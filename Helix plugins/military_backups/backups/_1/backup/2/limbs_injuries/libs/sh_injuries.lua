INJURIES = INJURIES || {};

INJURIES.LIST = INJURIES.LIST || {}
INJURIES.INSTANCES = INJURIES.INSTANCES || {}
INJURIES.INDEX = INJURIES.INDEX || 0;

function INJURIES.Get(uniqueID)
	return INJURIES.LIST[uniqueID]
end;

function INJURIES.Find(id)
	return INJURIES.INSTANCES[id]
end;

function INJURIES.LoadFromDir(directory)
	local files, folders = file.Find(directory.."/*", "LUA")

	for _, v in ipairs(files) do
		INJURIES.Load(directory.."/"..v)
	end
end

function INJURIES.Load(path)
	local uniqueID = path:match("sh_([_%w]+)%.lua")

	if (uniqueID) then
		INJURIES.Register(uniqueID, path)
	end
end

function INJURIES.insert(uniqueID, object)
	INJURIES.LIST[uniqueID] = object
end;

function INJURIES.FindStage( amount )
	for i = 1, #INJURIES.STAGES do
		local stage = INJURIES.STAGES[i]

		if stage && amount >= stage.min && amount <= stage.max then
			return i;
		end
	end;

	return INJURIES.STAGES[#INJURIES.STAGES] // return max if not found;
end;

function INJURIES.FindPain( amount )
	for i = 1, #INJURIES.PAIN do
		local pain = INJURIES.PAIN[i]

		if pain && amount >= pain.min && amount <= pain.max then
			return pain
		end
	end;
end;

function INJURIES.Register(uniqueID, path)
	if (!uniqueID) then return; end
	
	INJURY = INJURIES.Get( uniqueID ) or setmetatable({}, INJURIES.meta)
	INJURY.uniqueID = uniqueID

	if (path) then ix.util.Include(path) end
	INJURIES.insert(INJURY.index, INJURY)

	if (IX_RELOADED) then
		for _, v in pairs(INJURIES.LIST) do
			if (v.uniqueID == uniqueID) then
				table.Merge(v, INJURY)
			end
		end
	end

	INJURY = nil
end

function INJURIES.New(uniqueID, id, characterID, data)
	local inst = INJURIES.INSTANCES[id];

	if (inst && inst.uniqueID == uniqueID) then return inst end;

	local injuries = INJURIES.Get(uniqueID)

	if (injuries) then
		local injury = setmetatable(
		{
			id = id,
			charID = characterID,
			data = data || {
				stage = 0, 
				bleed = 0, 
				occured = os.time(),
				expire = os.time() + 60,
				heal = "",
				healAmount = 0,
				healTime = 0,
			},
		}, 
		{
			__index = injuries,
			__eq = injuries.__eq,
			__tostring = injuries.__tostring
		})

		INJURIES.INSTANCES[id] = injury

		return injury
	end
end;