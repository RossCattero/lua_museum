--- ix.archive.civilian module
ix.archive.civilians = ix.archive.civilians or {}

--- List of civilian faction which will trigger the archive data save;
-- FYI: It's not about helix data save, it's about datapad citizen data save. Just in case;
ix.archive.civilians.list = {
    FACTION_ACBMD,
    FACTION_ANTLION,
    FACTION_HEADCRAB,
    FACTION_WILDLIFE,
    FACTION_CWUDIRECT,
    FACTION_CWU,
    FACTION_CITIZEN,
    FACTION_CIU,
    FACTION_CSU,
    FACTION_CIC,
    FACTION_CAU,
    FACTION_FREEVORT,
    FACTION_VORT,
}

--- Check if faction is civilian
--- @param faction number
--- @return boolean (Is faction is on list)
function ix.archive.civilians.IsCivilian(faction)
	return table.HasValue(ix.archive.civilians.list, faction)
end;