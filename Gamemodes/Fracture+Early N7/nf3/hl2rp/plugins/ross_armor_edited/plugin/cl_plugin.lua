
local PLUGIN = PLUGIN;

local p = FindMetaTable( "Player" );
function p:GasmaskInfo()
    local iscombine = Schema:PlayerIsCombine(self)
    local fac = self:GetFaction();
    local gi = self:GetSharedVar("GasMaskInfo")
    if iscombine then
        if fac == FACTION_MPF then
            return gi
        elseif fac == FACTION_OTA then
            return 10;
        end;
    end;

    return 0;
end;