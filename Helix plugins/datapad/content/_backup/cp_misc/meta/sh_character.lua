local CHAR = ix.meta.character;

--- Set character rank in database and locally
---	@param uniqueID string (rank uniqueID in ix.ranks.list table)
function CHAR:SetCCARank(uniqueID)
    self:SetData("CCA_Rank", uniqueID)

	-- Load rank to the local player's data if player is exists
	if self.player then
		self.player:SetLocalVar("CCA_Rank", uniqueID)
	end;
end;

--- Get character rank from database
--- @return string (Character rank unique ID or default rank unique ID)
function CHAR:GetCCARank()
	return self:GetData("CCA_Rank", ix.ranks.default)
end;