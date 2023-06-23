--- ix.archive.police module 
ix.archive.police = ix.archive.police or {}

--- List of combine faction which will trigger the archive data save;
-- FYI: It's not about helix data save, it's about datapad combine data save. Just in case;
ix.archive.police.list = {
	FACTION_ADMIN,
	FACTION_COUNC,
	FACTION_DISPATCH,
	FACTION_DISTRICTADMINISTRATOR,
	FACTION_EVENT,
	FACTION_MPF,
	FACTION_OTA,
	FACTION_STAFF,
	FACTION_SYNTH,
	FACTION_UNI,
	FACTION_POLICE
}

--- Check if faction is police
--- @param faction number
--- @return boolean (Is faction is on list)
function ix.archive.police.IsCombine(faction)
	return table.HasValue(ix.archive.police.list, faction)
end;