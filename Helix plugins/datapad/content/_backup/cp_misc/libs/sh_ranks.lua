-- Ranks library
ix.ranks = ix.ranks or {}

-- Ranks list
ix.ranks.list = ix.ranks.list or {}

-- Character default rank on creation or assignment
ix.ranks.default = ix.ranks.default or "RcT"

-- Character factions allowed to receive a rank
ix.ranks.factions = {
	[FACTION_POLICE] = true,
}

-- Ranks permissions list
--[[ 
	Permissions explanation:
	open_datapad = Open the datapad UI itself and see citizens data.
	edit_citizens = Edit citizens data in database
	cca_access = Access to CCA database
	set_ranks = Set the CCA rank
	set_sterilized = Set the sterelized credits
	set_certifications = Set the CCA certifications

	If you want to add a new permission - please use a ^2 for new permission as listed below.

	Sorry in advance to making it a bit complicated.
	But it's better than making a string list.
]]--
ix.ranks.permissions = {
	[2] = "open_datapad",
	[4] = "edit_citizens",
	[8] = "cca_access",
	[16] = "set_ranks",
	[32] = "set_sterilized",
	[64] = "set_certifications",
	open_datapad = 2,
	edit_citizens = 4,
	cca_access = 8,
	set_ranks = 16,
	set_sterilized = 32,
	set_certifications = 64
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
	
	CCA_Rank = setmetatable({}, ix.meta.CCA_Rank)
	CCA_Rank.uniqueID = uniqueID
	
	if (path) then ix.util.Include(path) end

	-- Set the default rank unique ID if CCA_Rank have default field set to true
	if CCA_Rank.default then
		ix.ranks.default = uniqueID
	end;

	ix.ranks.list[ uniqueID ] = CCA_Rank;

	CCA_Rank = nil
end

--- Retrieve a rank table by it's uniqueID
--- @param uniqueID string (Rank unique ID in ix.ranks.list)
--- @return table
function ix.ranks.Get(uniqueID)
    return ix.ranks.list[ uniqueID ]
end;

--- Retrieve a rank factions as string
--- @return string (Factions numbers list)
function ix.ranks.FactionsToString()
	return table.concat(table.GetKeys(ix.ranks.factions), ",")
end;

--- Get if faction is actually allowed for ranks
--- @param faction_index number (Index or number of faction, FACTION_NAME)
--- @return boolean (True if allowed, False if not)
function ix.ranks.Allowed(faction_index)
	return ix.ranks.factions[faction_index]
end;

--- Check if rank is allowed to do something
--- @param rank_uniqueID string (The rank name)
--- @param permission number (The permission number listed above)
--- @return boolean (True if allowed)
function ix.ranks.Permission(rank_uniqueID, permission)
	local rank = ix.ranks.Get(rank_uniqueID)
	if not rank then
		return false;
	end;

	for i = 1, #rank.permissions do
		local _permission = rank.permissions[i]

		if bit.band(_permission, permission) > 0 then
			return true
		end;
	end;
	
	return false;
end;