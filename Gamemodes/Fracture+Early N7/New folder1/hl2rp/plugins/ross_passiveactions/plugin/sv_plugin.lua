
local PLUGIN = PLUGIN;
local math = math;
local m = math.Clamp;
local p = FindMetaTable( "Player" );

function p:ClothesGetWarm()
    local clothes = self:GetClothesSlot()
    local num = 0;

    if clothes["body"] != "" then
        local body = self:FindItemByID(clothes["body"]);
        if body:GetData("Used") && body:GetData("Warming") then
            num = num + body:GetData("Warming")
        end;
    end;

    if clothes["legs"] != "" then
        local legs = self:FindItemByID(clothes["legs"]);
        if legs:GetData("Used") && legs:GetData("Warming") then
            num = num + legs:GetData("Warming")
        end;
    end;

    if clothes["head"] != '' then
        local head = self:FindItemByID(clothes["head"]);

        if head:GetData("Used") && head:GetData("Warming") then
            num = num + head:GetData("Warming")
        end;
    end;

    return num;

end;

function p:NotifyCenter(player, text, delay, color)
    if !color || color == nil then
        color = Color(255, 255, 255);
    end;
    if !delay || delay == nil then
        delay = 10;
    end;
    
    return Clockwork.hint:SendCenter(player, text, delay, color, true, false);
end;

local CwKernel = Clockwork.kernel;

function PLUGIN:PlayerRestoreCharacterData(player, data)
	if ( !data["BodyTemp"] ) then
		data["BodyTemp"] = 36.6;
    end;
    if ( !data["Heatness"] ) then
		data["Heatness"] = 0;
    end;
end;

function PLUGIN:Initialize()
    if CwKernel:GetSharedVar("Temperature") == 0 then
        CwKernel:SetSharedVar("Temperature", 19);
    end;
end;

function PLUGIN:PlayerThink(player, curTime, infoTable)
    local temp = CwKernel:GetSharedVar("Temperature");
    local tempPly = player:GetCharacterData("BodyTemp");
    local heatness = player:GetCharacterData("Heatness");
    local warm = player:ClothesGetWarm();
    local random = math.random(1, 100);

    if (!player.TempRise or curTime >= player.TempRise) then

    if temp >= 20 && random > 45 then
        player:SetCharacterData("BodyTemp", math.Round(m(tempPly + temp/1000 + warm/1000, 34, 40), 2));

        player:SetCharacterData("Heatness", math.Round(m(heatness + tempPly/100 + warm/10, 0, 100), 2));
    elseif temp < 20 && random > 45 then
        player:SetCharacterData("BodyTemp", math.Round(m(tempPly - (temp*0.5/100) + warm/1000, 34, 40), 2));

        player:SetCharacterData("Heatness", math.Round(m(heatness - tempPly/100 + warm/10, 0, 100), 2));
    end;     
     
    player.TempRise = curTime + 20;
    end;

end;