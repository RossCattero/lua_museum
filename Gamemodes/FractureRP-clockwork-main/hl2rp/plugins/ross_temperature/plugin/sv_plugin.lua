
local PLUGIN = PLUGIN;
local math = math;
local m = math.Clamp;
local p = FindMetaTable( "Player" );

function p:IsUnderRoof()
    -- Взял из Hazard temp.
    local startpos = self:EyePos();
    local endpos = self:EyePos() + Vector(0, 0, 450)

    local t = util.TraceLine({
        start = startpos,
        endpos = endpos,
        filter = function( ent )
        if (ent:GetClass() == "prop_physics") then 
            return true 
        end 
    end})
    local hitpos = t.HitPos
        
    if (hitpos.z < startpos.z + 450) then
        return true
    end;
    
    return false
end	

function PLUGIN:PlayerRestoreCharacterData(player, data)
	if !data['defTemperature'] then
        data['defTemperature'] = 36.6
    end;

    if !data['TempInfo'] then
        data['TempInfo'] = 0
    end;
end;

function PLUGIN:PlayerThink(player, c, i)
    local tInfo = player:GetCharacterData('TempInfo')
    local plytemp = player:GetCharacterData('defTemperature')
    local roof = player:IsUnderRoof();

    if !player.temperatureDecrease || c >= player.temperatureDecrease then

        if roof then
            if player:GetAllWarming() > 10 then
                player:SetCharacterData('TempInfo', m(tInfo + 0.04, -5, 1))
            elseif player:GetAllWarming() < 10 then
                player:SetCharacterData('TempInfo', m(tInfo - 0.05, 0, 5))
            end;
        elseif !roof then
            if player:GetAllWarming() < 10 then
                player:SetCharacterData('TempInfo', m(tInfo - 0.04, -5, 5))
            elseif player:GetAllWarming() > 10 then
                player:SetCharacterData('TempInfo', m(tInfo + 0.06, -5, 1))
            end;
        end;

        if tInfo < 0 then
            if player:GetAllWarming() > 10 then
                player:SetCharacterData('TempInfo', m(tInfo + player:GetAllWarming()/1000, -5, 2))
            end;
        end;

        player:SetCharacterData('defTemperature', m(plytemp + tInfo/1000, 33, 40))

        player.temperatureDecrease = c + 100;
    end;

end;

function PLUGIN:PlayerSetSharedVars(player, curTime)
	player:SetSharedVar("dTemperature", player:GetCharacterData('defTemperature'));
    player:SetSharedVar("Tdecrease", player:GetCharacterData('TempInfo'));
end;