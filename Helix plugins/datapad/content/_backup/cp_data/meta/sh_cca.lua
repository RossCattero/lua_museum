local cca_data = ix.meta.cca_data or {}

cca_data.__index = cca_data

cca_data.characterID = 0;
cca_data.name = "";
cca_data.sterillized_credits = 0;
cca_data.rank = "";
cca_data.certifications = {};

function cca_data:__tostring()
    return Format("CCA: %s", self:UniqueID())
end

--- Get short info
--- @return string
function cca_data:UniqueID()
    return Format("%s, [%s]", self.name, self.rank)
end;

ix.meta.cca_data = cca_data