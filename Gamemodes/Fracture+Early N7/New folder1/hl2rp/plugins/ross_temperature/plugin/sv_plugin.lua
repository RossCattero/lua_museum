
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

    if !player.temperatureDecrease || c >= player.temperatureDecrease then
        local item1 = player:FindItemByID(clothes['head']);
        local item2 = player:FindItemByID(clothes['body']);
        local item3 = player:FindItemByID(clothes['legs']);
        local item4 = player:FindItemByID(clothes['hands']);
        local roof = player:IsUnderRoof();
        local buffer1 = Temperature['headtemp']
        local buffer2 = Temperature['bodytemp']
        local buffer3 = Temperature['legstemp']
        local buffer4 = Temperature['handstemp']

        if item1 || roof then
            if item1 && item1:GetData('ClothesWarm') > 0 then
                Temperature['headtemp'] = m( Temperature['headtemp'] + math.random(0.1, item1:GetData('ClothesWarm')/100 ), 0, 100 )
            end;
            Temperature['headtemp'] = m( Temperature['headtemp'] + math.random(0.1, 0.5), 0, 55 )
        elseif !item1 && !roof then
            if Temperature['headtemp'] > 55 then
                Temperature['headtemp'] = m( Temperature['headtemp'] - 2.5, 55, 100 )
            elseif Temperature['headtemp'] <= 55 then
                Temperature['headtemp'] = m( Temperature['headtemp'] - 0.5, 0, 100 )
            end;
        end;

        if item2 || roof then
            if item2 && item2:GetData('ClothesWarm') > 0 then
                Temperature['bodytemp'] = m( Temperature['bodytemp'] + math.random(0.1, item2:GetData('ClothesWarm')/100 ), 0, 100 )
            end;
            Temperature['bodytemp'] = m( Temperature['bodytemp'] + math.random(0.1, 0.5), 0, 100 )
        elseif !item2 && !roof then
            if Temperature['bodytemp'] > 55 then
                Temperature['bodytemp'] = m( Temperature['bodytemp'] - 2.5, 55, 100 )
            elseif Temperature['bodytemp'] <= 55 then
                Temperature['bodytemp'] = m( Temperature['bodytemp'] - 0.5, 0, 100 )
            end;
        end;

        if item3 || roof then
            if item3 && item3:GetData('ClothesWarm') > 0 then
                Temperature['legstemp'] = m( Temperature['legstemp'] + math.random(0.1, item3:GetData('ClothesWarm')/100 ), 0, 100 )
            end;            
            Temperature['legstemp'] = m( Temperature['legstemp'] + math.random(0.1, 0.5), 0, 100 )
        elseif !item3 || !roof then
            if Temperature['legstemp'] > 55 then
                Temperature['legstemp'] = m( Temperature['legstemp'] - 2.5, 55, 100 )
            elseif Temperature['legstemp'] <= 55 then
                Temperature['legstemp'] = m( Temperature['legstemp'] - 0.5, 0, 100 )
            end;
        end;

        if item4 || roof then
            if item4 && item4:GetData('ClothesWarm') > 0 then
                Temperature['handstemp'] = m( Temperature['handstemp'] + math.random(0.1, item1:GetData('ClothesWarm')/100 ), 0, 100 )
            end;            
            Temperature['handstemp'] = m( Temperature['handstemp'] + math.random(0.1, 0.5 ), 0, 100 )
        elseif !item4 && !roof then
            if Temperature['handstemp'] > 55 then
                Temperature['handstemp'] = m( Temperature['handstemp'] - 2.5, 55, 100 )
            elseif Temperature['handstemp'] <= 55 then
                Temperature['handstemp'] = m( Temperature['handstemp'] - 0.5, 0, 100 )
            end;
        end;

        if (buffer1 < Temperature['headtemp']) || (buffer2 < Temperature['bodytemp']) || (buffer3 < Temperature['legstemp']) || (buffer4 < Temperature['handstemp']) then
            Clockwork.hint:SendCenter(player, "Вам становится теплее.", 10, Color(239, 244, 11), true, true);
        elseif (buffer1 > Temperature['headtemp']) || (buffer2 > Temperature['bodytemp']) || (buffer3 > Temperature['legstemp']) || (buffer4 > Temperature['handstemp']) then
            Clockwork.hint:SendCenter(player, "Вам становится холоднее.", 10, Color(50, 50, 255), true, true);
        end;

        player.temperatureDecrease = c + 25;
    end;

end;

function PLUGIN:PlayerSetSharedVars(player, curTime)
    local Temperature = player:GetCharacterData('BodyTemp')

	player:SetSharedVar("headtemp", Temperature['headtemp']);
	player:SetSharedVar("bodytemp", Temperature['bodytemp']);
    player:SetSharedVar("legstemp", Temperature['legstemp']);
    player:SetSharedVar("handstemp", Temperature['handstemp']);
end;