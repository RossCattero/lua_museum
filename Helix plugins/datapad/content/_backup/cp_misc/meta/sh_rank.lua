local CCA_Rank = ix.meta.CCA_Rank or {}

CCA_Rank.__index = CCA_Rank

-- Name of the rank
CCA_Rank.name = "Unknown rank"

-- UniqueID of the rank
CCA_Rank.uniqueID = "None"

-- Should this rank be default
-- ! Alert. Leave at least one rank at default
CCA_Rank.default = false

-- The datapad permissions list.
-- Don't add this to new rank if you want new rank to have access to datapad and edit citizens data
CCA_Rank.permissions = {
    ix.ranks.permissions.open_datapad,
    ix.ranks.permissions.edit_citizens
}

function CCA_Rank:__tostring()
	return Format("CCA rank: %s", self:UniqueID())
end

--- Get the rank unique ID
--- @return string
function CCA_Rank:UniqueID()
    return self.uniqueID
end;

ix.meta.CCA_Rank = CCA_Rank