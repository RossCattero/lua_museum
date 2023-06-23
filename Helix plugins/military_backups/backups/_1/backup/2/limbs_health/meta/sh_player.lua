local PLAYER = FindMetaTable("Player")

function PLAYER:CanLookMed( id )
	local rgn = self:WhoLookMed()

	return rgn:find(","..id..",")
end;

function PLAYER:WhoLookMed()
	return self:GetLocalVar("rgn_med", "")
end;

function PLAYER:CanBeMedicalObserved(id)
	local reco = self:GetNetVar("rgn_med", "")

	return reco:find("," .. id .. ",") || self:GetNetVar("restricted") || self:GetNetVar("Wounded")
end;