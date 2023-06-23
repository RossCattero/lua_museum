local ENTITY = FindMetaTable("Entity")

function ENTITY:CanAccessInjuries()
	return !self:GetNoDraw() && self:IsPlayer() || self:GetNetVar("player")
end;