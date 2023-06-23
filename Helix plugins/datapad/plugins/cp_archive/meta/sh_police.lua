--[[
    Data archive class for police.
]]
-- @classmod CCA

local police = ix.meta.police or {}

police.__index = police

-- characterID of parent character
police.id = 0

-- Name of parent character
police.name = "John Doe"

-- Rank data
police.rank = "RcT"

-- Integer sterilization points amount
police.sterilization = 0

-- List of certifications data
police.certifications = {}

function police:__tostring()
    return Format("Police %s data", self:GetName())
end

--- Update archived data name
---@param name string
function police:SetName(name)
    self.name = tostring(name);

    ix.archive.edited[self.id] = self
end;

--- Get police name in data
---@return string
function police:GetName()
    return self.name;
end;

--- Set character police rank
---@param rank string (uniqueID of rank in rank list)
function police:SetRank(rank)
    if ix.ranks.Get(rank) then
        self.rank = rank;

        ix.archive.edited[self.id] = self;
    else
        ErrorNoHalt(Format("Unknown rank %s for character %s", rank, self.id))
    end;
end;

--- Get character's rank
---@return string (Rank uniqueID)
function police:GetRank()
    return self.rank:lower()
end;

--- Set sterilization points amount
---@param sterilization integer
function police:SetSterelize(sterilization)
    self.sterilization = sterilization

    ix.archive.edited[self.id] = self;
end;

--- Get sterilization points
---@return integer
function police:GetSterelize()
    return self.sterilization
end;

--- Add certification to the character data list
---@param certification string (uniqueID of certification in list)
function police:AddCertification(certification)
    local certification_object = ix.certifications.Get(certification)

    if certification_object then
        self.certifications[certification] = true;

        ix.archive.edited[self.id] = self;
    else
        ErrorNoHalt(Format("Unknown certification for character %s", self.id))
    end;
end;

--- Remove certification from character
---@param certification string (Certification uniqueID in character cert. list)
function police:RemoveCertification(certification)
    if self.certifications[certification] then
        self.certifications[certification] = nil;

        ix.archive.edited[self.id] = self;
    end;
end;

--- Get certifications list
---@return table (Certifications list of character)
function police:GetCertifications()
    return self.certifications
end;

--- Get Certification from certifications list
---@param certification string
---@return table (Certification table)
function police:HasCertification(certification)
    return self:GetCertifications()[certification]
end;

ix.meta.police = police