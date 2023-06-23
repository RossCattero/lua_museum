--[[--
    Data archive class for civilians.
]]
-- @classmod Civilian

local civilian = ix.meta.civilian or {}

civilian.__index = civilian

-- characterID of parent character
civilian.id = 0

-- Name of parent character
civilian.name = "John Doe"

-- CID of parent character
civilian.cid = "00000"

-- Integer field for loyality points
civilian.loyality = 0

-- Integer field for criminal points
civilian.criminal = 0

-- Data field for notes
civilian.notes = ""

-- Data field for apartment
civilian.apartment = ""

-- Data field for bol
civilian.bol = ""

function civilian:__tostring()
    return Format("Civilian #%s data", self.cid)
end

--- Update archived data name
---@param name string
function civilian:SetName(name)
    if name == self:GetName() then return end;

    self.name = name;

    ix.archive.edited[self.id] = self
end;

--- Get civilian name in data
---@return string
function civilian:GetName()
    return self.name;
end;

--- Set Citizen ID
---@param cid string
function civilian:SetCID(cid)
    if cid == self:GetCID() then return end;

    self.cid = cid

    ix.archive.edited[self.id] = self
end

--- Get Citizen ID
---@return string
function civilian:GetCID()
    return self.cid
end;

--- Set apartment
---@param apartment string
function civilian:SetApartment(apartment)
    if apartment == self:GetApartment() then return end;

    self.apartment = apartment

    ix.archive.edited[self.id] = self
end

--- Get apartment
---@return string
function civilian:GetApartment()
    return self.apartment
end;

--- Set loyality of data
---@param loyality integer
function civilian:SetLoyality(loyality)
    if loyality == self:GetLoyality() then return end;

    self.loyality = tonumber(loyality)

    ix.archive.edited[self.id] = self
end;

--- Get loyality of data
---@return integer
function civilian:GetLoyality()
    return self.loyality
end;

--- Set criminal points
---@param crimimal integer
function civilian:SetCriminal(crimimal)
    if crimimal == self:GetCriminal() then return end;

    self.criminal = tonumber(crimimal)

    ix.archive.edited[self.id] = self
end;

--- Get criminal points
---@return integer
function civilian:GetCriminal()
    return self.criminal
end;

--- Set notes text
---@param text string
function civilian:SetNotes(text)
    if text == self:GetNotes() then return end;

    self.notes = text

    ix.archive.edited[self.id] = self
end;

--- Get notes text
---@return string
function civilian:GetNotes()
    return self.notes
end;

--- Set BOL for character
---@param bol string
function civilian:SetBOL(bol)
    if bol == self:GetBOL() then return end;

    self.bol = bol;

    ix.archive.edited[self.id] = self
end

--- Get BOL of character
---@returns string
function civilian:GetBOL()
    return self.bol
end

ix.meta.civilian = civilian