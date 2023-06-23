local player = FindMetaTable("Player");
local math = math;
local round = math.Round
local clamp = math.Clamp

function player:SetExp( number )
    self:SetNWFloat("Expirience", number)
end;

function player:GetExp()
    return self:GetNWFloat("Expirience", 0);
end;

function player:LoadExp()

end;