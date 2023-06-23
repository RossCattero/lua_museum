-- module ix.ranks
ix.ranks = ix.ranks or {}

-- Ranks list
ix.ranks.list = ix.ranks.list or {}

-- Ranks permissions list
ix.ranks.permissions = ix.ranks.permissions or {}

-- Default rank to set on police character init;
ix.ranks.default = ix.ranks.default or "RcT"

-- Permissions
ix.ranks.permissions = {
	[2] = "open_datapad",
	[4] = "edit_citizens",
	[8] = "cca_access",
	[16] = "set_ranks",
	[32] = "set_sterilized",
	[64] = "set_certifications",
	[128] = "access_logs",
	open_datapad = 2,
	edit_citizens = 4,
	cca_access = 8,
	set_ranks = 16,
	set_sterilized = 32,
	set_certifications = 64,
	access_logs = 128
}

--- Load all ranks from a directory
--- @param directory string
function ix.ranks.LoadFromDir(directory)
	local files, folder = file.Find(directory.."/*", "LUA")

	for _, v in ipairs(files) do
		local path = directory.."/"..v
		ix.ranks.Register(path:match("sh_([_%w]+)%.lua"), path)
	end
end

--- Register a rank class
--- @param uniqueID string
--- @param path string
function ix.ranks.Register(uniqueID, path)
	if (not uniqueID) then return; end
	uniqueID = uniqueID:lower()
	
	Rank = setmetatable({}, ix.meta.rank)
	Rank.uniqueID = uniqueID
	
	if (path) then ix.util.Include(path) end

	-- Set the default rank unique ID if CCA_Rank have default field set to true
	if Rank.default then
		ix.ranks.default = uniqueID
	end;

	ix.ranks.list[ uniqueID ] = Rank;

	Rank = nil
end

--- Retrieve a rank table by it's uniqueID
--- @param uniqueID string (Rank unique ID in ix.ranks.list)
--- @return table
function ix.ranks.Get(uniqueID)
    return ix.ranks.list[ uniqueID ]
end;

--- Check if rank is allowed to do something
--- @param rank_uniqueID string (The rank name)
--- @param permission number (The permission number listed above)
--- @return boolean (True if allowed)
--[[
	Example:
	recruit = ix.ranks.list["rct"]
	print(ix.ranks.Permission(recruit.rank, ix.ranks.permissions.set_ranks))
	>> false
]]
function ix.ranks.Permission(rank_uniqueID, permission)
	local rank = ix.ranks.Get(rank_uniqueID)
	if not rank then
		return false;
	end;

	for i = 1, #rank.permissions do
		local _permission = rank.permissions[i]

		if ix.ranks.permissions[permission] and bit.band(_permission, permission) > 0 then
			return true
		end;
	end;
	
	return false;
end;