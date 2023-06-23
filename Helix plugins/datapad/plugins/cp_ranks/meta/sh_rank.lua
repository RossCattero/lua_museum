--[[
    Class for rank object.
]]
--- @classmod CCA rank
local Rank = ix.meta.rank or {}

Rank.__index = Rank

-- Rank title
Rank.name = "Unknown bank"

-- Bool for default rank
Rank.default = false

-- Rank value.
-- For example:
-- Rank value 1 can't set ranks for rank value 2
-- But can access rank values 0
Rank.value = 0

-- Permissions list
Rank.permissions = {
    ix.ranks.permissions.open_datapad,
    ix.ranks.permissions.edit_citizens
}

function Rank:__tostring()
	return Format("Rank: %s", self.name)
end

ix.meta.rank = Rank