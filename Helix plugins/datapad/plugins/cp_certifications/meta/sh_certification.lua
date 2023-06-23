--[[
    Certification class
]]
-- @classmod Certificate

local Certification = ix.meta.certification or {}

Certification.__index = Certification

-- Title of the Certification
Certification.name = "Unknown Certification"

-- UniqueID of the Certification
Certification.uniqueID = "None"

-- The rank of Certification
Certification.rank = "Unknown"

-- The class of Certification
Certification.class = "Unknown"

-- The color of Certification
Certification.color = Color(255, 255, 255, 255)

function Certification:__tostring()
	return Format("Certification: %s", self.uniqueID)
end

ix.meta.certification = Certification