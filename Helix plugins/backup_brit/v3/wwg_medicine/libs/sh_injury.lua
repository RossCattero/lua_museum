/*
	Injury manipulation and helper functions;
*/
-- @module ix.injury
ix.injury = ix.injury || {};

/*
	List of injuries sorted by injury global indexes;
	@table ix.injury.list
	@realm [shared]
	@usage print(ix.injury.list[DMG_GENERIC])
	> INJURY[0]
*/
ix.injury.list = ix.injury.list || {}

/*
	Load all data from provided directory with injuries;
	@realm [shared]
	@argument [directory] [string] The directory which contains the injuries.
*/
function ix.injury.LoadFromDir(directory)
	local files, folders = file.Find(directory.."/*", "LUA")

	for _, v in ipairs(files) do
		local path = directory.."/"..v
		ix.injury.Register(path:match("sh_([_%w]+)%.lua"), path)
	end
end

/*
	Register the injury object and add it to global array.
	@realm [shared]
	@argument [uniqueID] [string] The uniqueID of injury.
	@argument [path] [string] The path to the injury.
*/
function ix.injury.Register(uniqueID, path)
	if (!uniqueID) then return; end
	
	INJURY = ix.injury.list[uniqueID] || setmetatable({}, ix.meta.injury)
	INJURY.uniqueID = uniqueID

	if (path) then ix.util.Include(path) end
	ix.injury.list[ INJURY.index ] = INJURY;

	// In case the injuries all reloaded.
	if (IX_RELOADED) then
		for _, v in pairs(ix.injury.list) do
			if (v.uniqueID == uniqueID) then
				table.Merge(v, INJURY)
			end
		end
	end

	INJURY = nil
end