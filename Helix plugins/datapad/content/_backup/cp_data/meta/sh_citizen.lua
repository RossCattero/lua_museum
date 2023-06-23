local citizen_data = ix.meta.citizen_data or {}

citizen_data.__index = citizen_data

citizen_data.characterID = 0;
citizen_data.name = "John Doe";
citizen_data.cid = "#000000";
citizen_data.loyality_points = 0;
citizen_data.criminal_ponits = 0;
citizen_data.notes = ""
citizen_data.BOL = ""

function citizen_data:__tostring()
    return Format("CITIZEN:", self:UniqueID())
end

--- Get short info
--- @return string
function citizen_data:UniqueID()
    return Format("%s, %s", self.name, self.cid)
end;

ix.meta.citizen_data = citizen_data