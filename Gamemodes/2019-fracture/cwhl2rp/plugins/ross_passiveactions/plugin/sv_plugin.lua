
local PLUGIN = PLUGIN;
local math = math;
local m = math.Clamp;
local p = FindMetaTable( "Player" );

function p:ClothesGetWarm()
    local items = Clockwork.inventory:GetAsItemsList(self:GetInventory());
    local clothesslot = self:GetCharacterData("ClothesSlot");
    local num = 0;

    for k, v in ipairs(items) do
        if clothesslot then
        if (clothesslot["head"] == true || clothesslot["gasmask"] == true) && (v("clothesslot") == "gasmask" || v("clothesslot") == "head") && v:GetData("Warming") > 0 && v:GetData("Used") == true then
            num = num + v:GetData("Warming");
        end;
        if (clothesslot["body"] == true) && (v("clothesslot") == "body") && v:GetData("Warming") > 0 && v:GetData("Used") == true then
            num = num + v:GetData("Warming");
        end;
        if (clothesslot["legs"] == true) && (v("clothesslot") == "legs") && v:GetData("Warming") > 0 && v:GetData("Used") == true then
            num = num + v:GetData("Warming");
        end;
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
    local clean = player:GetNeed("clean");
    local random = math.random(1, 100);

    if (!player.TempRise or curTime >= player.TempRise) then

    if temp >= 20 && random > 45 then
        player:SetCharacterData("BodyTemp", math.Round(m(tempPly + temp/1000 + warm/1000, 34, 40), 2));

        player:SetCharacterData("Heatness", math.Round(m(heatness + tempPly/100 + warm/10, 0, 100), 2));
    elseif temp < 20 && random > 45 then
        player:SetCharacterData("BodyTemp", math.Round(m(tempPly - (temp*0.5/100) + warm/1000, 34, 40), 2));

        player:SetCharacterData("Heatness", math.Round(m(heatness - tempPly/100 + warm/10, 0, 100), 2));
    end;

    player:SetNeed("clean", m(clean + heatness/100, 0, 100))

    if tempPly >= 37.4 then 
        player:AddSympthom("temperature")
    elseif tempPly < 37 && player:HasSym("temperature") then 
        player:RemSym("temperature")
    end;        
     
    player.TempRise = curTime + 20;
    end;

end;