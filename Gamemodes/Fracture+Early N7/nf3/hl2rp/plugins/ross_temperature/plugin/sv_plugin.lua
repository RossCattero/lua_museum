
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

function p:GetAverageHeat()
    local Temperature = self:GetCharacterData('BodyTemp')

    return Temperature['headtemp'] + Temperature['bodytemp'] + Temperature['legstemp'] + Temperature['handstemp']

end;

function p:GetHeadTemp()
    local Temperature = self:GetCharacterData('BodyTemp')
    return Temperature['headtemp'];
end;
function p:SetHeadTemp(n)
    local Temperature = self:GetCharacterData('BodyTemp')
    Temperature['headtemp'] = n
end;
function p:GetBodyTemp()
    local Temperature = self:GetCharacterData('BodyTemp')
    return Temperature['bodytemp']
end;
function p:SetBodyTemp(n)
    local Temperature = self:GetCharacterData('BodyTemp')
    Temperature['bodytemp'] = n
end;
function p:GetLegsTemp()
    local Temperature = self:GetCharacterData('BodyTemp')
    return Temperature['legstemp']
end;
function p:SetLegsTemp(n)
    local Temperature = self:GetCharacterData('BodyTemp')
    Temperature['legstemp'] = n
end;
function p:GetHandsTemp()
    local Temperature = self:GetCharacterData('BodyTemp')
    return Temperature['handstemp']
end;
function p:SetHandsTemp(n)
    local Temperature = self:GetCharacterData('BodyTemp')
    Temperature['handstemp'] = n
end;

function PLUGIN:PlayerSaveCharacterData(player, data)
	if (data["BodyTemp"]) then
		data["BodyTemp"] = data["BodyTemp"];
	else
	    data["BodyTemp"] = {
            headtemp = 50,
            bodytemp = 50,
            legstemp = 50,
            handstemp = 50
        };
    end;
      
end;

function PLUGIN:PlayerRestoreCharacterData(player, data)
	if ( !data["BodyTemp"] ) then
		data["BodyTemp"] = {
            headtemp = 50,
            bodytemp = 50,
            legstemp = 50,
            handstemp = 50
        };
    end;
end;

function PLUGIN:PlayerThink(player, c, i)
    local clothes = player:GetClothesSlot()
    local Temperature = player:GetCharacterData('BodyTemp')
    local item1 = player:FindItemByID(clothes['head']);
    local item2 = player:FindItemByID(clothes['body']);
    local item3 = player:FindItemByID(clothes['legs']);
    local item4 = player:FindItemByID(clothes['hands']);
    local roof = player:IsUnderRoof();
    local buffer1 = Temperature['headtemp']
    local buffer2 = Temperature['bodytemp']
    local buffer3 = Temperature['legstemp']
    local buffer4 = Temperature['handstemp']
    local temperatureInc = 0

    if !player.temperatureDecrease || c >= player.temperatureDecrease then

        if roof then
            temperatureInc = temperatureInc + 0.2
        elseif !roof then
            temperatureInc = temperatureInc - 0.4
        end;

        if item1 then
            Temperature['headtemp'] = m(Temperature['headtemp'] + item1:GetData('ClothesWarm')/1000, 0, 100)
        end;
        if item2 then
            Temperature['bodytemp'] = m(Temperature['bodytemp'] + item2:GetData('ClothesWarm')/1000, 0, 100)
        end;
        if item3 then
            Temperature['legstemp'] = m(Temperature['legstemp'] + item2:GetData('ClothesWarm')/1000, 0, 100)
        end;
        if item4 then
            Temperature['handstemp'] = m(Temperature['handstemp'] + item2:GetData('ClothesWarm')/1000, 0, 100)
        end;

        if Temperature['headtemp'] <= 65 then
            Temperature['headtemp'] = m(Temperature['headtemp'] + temperatureInc, 0, 100);
        elseif Temperature['headtemp'] >= 65 then
            Temperature['headtemp'] = m(Temperature['headtemp'] + 0.1, 0, 100);
        end;
        if Temperature['bodytemp'] <= 65 then
            Temperature['bodytemp'] = m(Temperature['bodytemp'] + temperatureInc, 0, 100);
        elseif Temperature['bodytemp'] >= 65 then
            Temperature['bodytemp'] = m(Temperature['bodytemp'] + 0.1, 0, 100);
        end;
        if Temperature['legstemp'] <= 65 then
            Temperature['legstemp'] = m(Temperature['legstemp'] + temperatureInc, 0, 100);
        elseif Temperature['legstemp'] > 65 then
            Temperature['legstemp'] = m(Temperature['legstemp'] + 0.1, 0, 100);
        end;
        if Temperature['handstemp'] <= 65 then
            Temperature['handstemp'] = m(Temperature['handstemp'] + temperatureInc, 0, 100);
        elseif Temperature['handstemp'] > 65 then
            Temperature['handstemp'] = m(Temperature['handstemp'] + 0.1, 0, 100);
        end;

        if (buffer1 < Temperature['headtemp']) || (buffer2 < Temperature['bodytemp']) || (buffer3 < Temperature['legstemp']) || (buffer4 < Temperature['handstemp']) then
            Clockwork.hint:SendCenter(player, "Вам становится теплее.", 10, Color(239, 244, 11), true, true);
        elseif (buffer1 > Temperature['headtemp']) || (buffer2 > Temperature['bodytemp']) || (buffer3 > Temperature['legstemp']) || (buffer4 > Temperature['handstemp']) then
            Clockwork.hint:SendCenter(player, "Вам становится холоднее.", 10, Color(50, 50, 255), true, true);
        end;

        player.temperatureDecrease = c + 100;
    end;

end;

function PLUGIN:PlayerSetSharedVars(player, curTime)
    local Temperature = player:GetCharacterData('BodyTemp')

	player:SetSharedVar("headtemp", Temperature['headtemp']);
	player:SetSharedVar("bodytemp", Temperature['bodytemp']);
    player:SetSharedVar("legstemp", Temperature['legstemp']);
    player:SetSharedVar("handstemp", Temperature['handstemp']);
end;