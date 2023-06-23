
local CHAR = ix.meta.character

function CHAR:IsCombine()
	local faction = self:GetFaction()
	return faction == FACTION_MINISTERY_OF_ORDER or faction == FACTION_MINISRY_OF_SECURITY or faction == FACTION_MINISRY_OF_DEFENCE
end
