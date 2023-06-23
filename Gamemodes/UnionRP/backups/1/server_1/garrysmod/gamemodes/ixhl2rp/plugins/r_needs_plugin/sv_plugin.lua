local math = math;
local mc = math.Clamp;
local floor = math.floor
local random = math.random
local minimum = 0;
local maximum = 100;

--[[ Config ]]--
local timeVar = 360;

local function ChangeNeeds(player)

    local character = player:GetCharacter();
    local h, t = player:GetLocalVar('hunger'), player:GetLocalVar('thirst')
    local health, maxhealth = player:Health(), player:GetMaxHealth()

    if character then

        if player:Alive() then
            if h < 50 && t < 50 then
                player:SetHealth( mc( health - 2, 1, maxhealth ) );
            elseif h < 25 && t < 25 then
                player:SetHealth( mc( health - 3, 1, maxhealth ) );  
            end;

            -- if h == 0 && t == 0 then
            --     player:Kill();
            -- end;
        end;
        
    end;

end;

function PLUGIN:PostPlayerLoadout(client)
    local uniqueID = "r_needs_" .. client:SteamID()

    timer.Create(uniqueID, timeVar, 0, function()
        if !client:GetCharacter() then
            timer.Remove(uniqueID)
            return
        end

        ChangeNeeds(client)
    end)
end

function PLUGIN:CharacterPreSave(character)
    local client = character:GetPlayer()

    if (IsValid(client)) then
        character:SetData("hunger", client:GetLocalVar("hunger", 0))
        character:SetData("thirst", client:GetLocalVar("thirst", 0))
    end
end

function PLUGIN:PlayerLoadedCharacter(client, character)
    timer.Simple(0.25, function()
        client:SetLocalVar("hunger", character:GetData("hunger", 100))
        client:SetLocalVar("thirst", character:GetData("thirst", 100))
    end)
end
