local ENTITY = FindMetaTable("Entity")

function ENTITY:CanBeWounded()
	return !self:GetNoDraw() && (self:IsPlayer() || self:GetNetVar("player"))
end;