local CHAR = ix.meta.character;

--- Setup character's CID
--- @param cid (string) (Optional) (Citizen ID)
function CHAR:SetCID(cid)
    if not cid then
        local digits = 5;
        local number = math.random(1, 99999);
        cid = string.rep("0", math.Clamp(digits - string.len(number), 0, digits))..number;
    end;

    self:SetData("CID", cid);
    if self.player then
        self.player:SetLocalVar("CID", self:GetData("CID"))
    end;
end;

--- Get character's CID
--- @return string (Citizen ID)
function CHAR:GetCID()
	return self:GetData("CID")
end;