local PLUGIN = PLUGIN;
local ply = FindMetaTable("Player")

local BASE_NEED = 0.15
local table = table;
local math = math;
local clamp = math.Clamp
local rand = math.random
local cur = CurTime()
local netStart = netstream.Start

local min_need = 0;
local const_need = 100;

--[[ Metastases ]]--

function ply:SetHunger(number)
    local char = self:GetCharacter()

    self:SetLocalVar('hunger', number);
    char:SetData('hunger', number);
end;
function ply:SetThirst(number)
    local char = self:GetCharacter()

    self:SetLocalVar('thirst', number);
    char:SetData('thirst', number);
end;
function ply:SetSleep(number)
    local char = self:GetCharacter()

    self:SetLocalVar('sleep', number);
    char:SetData('sleep', number);
end;

--[[ Metastases ]]--

function PLUGIN:OnCharacterCreated(client, character)
    character:SetData("hunger", const_need)
    character:SetData("thirst", const_need)
    character:SetData("sleep", const_need)
end

function PLUGIN:PlayerLoadedCharacter(client, character)
    timer.Simple(0.25, function()
        client:SetLocalVar("hunger", character:GetData("hunger", const_need))
        client:SetLocalVar("thirst", character:GetData("thirst", const_need))
        client:SetLocalVar("sleep", character:GetData("sleep", const_need))
    end)
end

function PLUGIN:CharacterPreSave(character)
    local client = character:GetPlayer()

    if (IsValid(client)) then
        character:SetData("hunger", client:GetLocalVar("hunger", min_need))
        character:SetData("thirst", client:GetLocalVar("thirst", min_need))
        character:SetData("sleep", client:GetLocalVar("sleep", min_need))
    end
end

function PLUGIN:PlayerPostThink( player )
    local char = player:GetCharacter()
    local isRunnung = player:KeyDown(IN_SPEED);
    if !player.HungerTick or cur >= player.HungerTick then
        player.HungerTick = cur + 360;
        if char then
            local hunger, thirst, sleep = player:GetLocalVar('hunger'), player:GetLocalVar('thirst'), player:GetLocalVar('sleep')
            local carryWeight = char:GetData("carry", 0);
            player:SetHunger( clamp(hunger - rand(0.01, BASE_NEED) - carryWeight*0.1, min_need, const_need) )
            player:SetThirst( clamp(thirst - rand(0.01, BASE_NEED), min_need - carryWeight*0.1, const_need) )
            player:SetSleep( clamp(sleep - rand(0.01, BASE_NEED), min_need - carryWeight*0.1, const_need) )
        end;
    end;

    if isRunning then
        if !player.Running or cur >= player.Running then
            player.Running = cur + 1;

            player:SetHunger( clamp(hunger - rand(0.05, BASE_NEED * 10), min_need, const_need) )
            player:SetThirst( clamp(thirst - rand(0.05, BASE_NEED * 10), min_need, const_need) )
            player:SetSleep( clamp(sleep - rand(0.1, BASE_NEED * 10), min_need, const_need) )
        end;
    end;
end;

function PLUGIN:KeyPress(client, key)
    local char = client:GetCharacter()
    if char && (key == IN_JUMP) && client:GetLocalVar("sleep", 100) < 15 then
        local hunger, thirst, sleep = client:GetLocalVar('hunger'), client:GetLocalVar('thirst'), client:GetLocalVar('sleep')
        client:SetSleep( clamp(sleep - rand(1, 5), min_need, const_need) )
	end
end


function Schema:ShowHelp( ply )
    netStart(ply, "PreSleeping")
end;

netstream.Hook("StartSleeping", function(player, number)
    local seq = player:GetNetVar("forcedSequence");
    local allowedSequences = AllowedSleeping();
    local alive = player:Alive();
    local character = player:GetCharacter()
    
    if alive && character then
        local isSleeping = player:GetLocalVar("IsSleeping", false)
        local hunger, thirst, sleep =  player:GetLocalVar('hunger'), player:GetLocalVar('thirst'), player:GetLocalVar("sleep")

        if sleep >= 95 then player:Notify("Я не хочу спать.") return; end;

        if isSleeping then player:Notify("Вы уже спите!") return; end;

        if seq && table.HasValue(allowedSequences, player:GetSequenceName( seq )) then
            player:SetLocalVar("IsSleeping", true);
            player:ScreenFade( SCREENFADE.OUT, color_black, 1, number )
            player:SetRestricted(true, true);

            player:SetAction("[Сон]", number, function()
                player:ScreenFade( SCREENFADE.IN, color_black, 0.5, 1 )
                player:SetLocalVar("IsSleeping", false);
                player:SetRestricted(false, true);

                player:SetHunger( math.Clamp(hunger - hunger*0.5, 0, 100) )
                player:SetThirst( math.Clamp(thirst - thirst*0.5, 0, 100) )
                player:SetSleep( math.Clamp( sleep + number*0.5*10 , 0, 100))
            end);

        else
            player:Notify("Вы должны лежать, чтобы начать спать.")
        end;
    end;
end)