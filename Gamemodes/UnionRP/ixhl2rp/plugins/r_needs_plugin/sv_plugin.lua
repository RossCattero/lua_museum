local PLUGIN = PLUGIN;

local math = math;
local mc = math.Clamp;
local floor = math.floor
local random = math.random
local minimum = 0;
local maximum = 125;

local painSounds = {
	Sound("vo/npc/male01/pain01.wav"),
	Sound("vo/npc/male01/pain02.wav"),
	Sound("vo/npc/male01/pain03.wav"),
	Sound("vo/npc/male01/pain04.wav"),
	Sound("vo/npc/male01/pain05.wav"),
	Sound("vo/npc/male01/pain06.wav")
}

--[[ Config ]]--
local timeVar = 360;

local function ChangeNeeds(player)

    local character = player:GetCharacter();
    local h, t, s = player:GetHunger(), player:GetThirst(), player:GetSleep()
    
    local jump, altwalk, walk, shift, crouch = player:GetJumpPower(), player:GetSlowWalkSpeed(), player:GetWalkSpeed(), player:GetRunSpeed(), player:GetCrouchedWalkSpeed()
    local maxwalk, maxRun = ix.config.Get("walkSpeed"), ix.config.Get("runSpeed")
    local painSound = painSounds[math.random(1, #painSounds)];
    local wep = player:GetActiveWeapon();

    if character then

        player:SetHunger( mc(h - math.random(1, 10)/10 - ((maximum/100) - ((maximum/100) - (t/100))), minimum, maximum) )
        player:SetThirst( mc(t - math.random(1, 10)/10, minimum, maximum) )
        player:SetSleep( mc(s - 0.05 - ((maximum/100) - ((maximum/100) - (t/100))), minimum, maximum) )
        if h > 100 && t > 100 then
            player:SetHealth( mc(player:Health() + 2, 0, player:GetMaxHealth()) )
            player:SetHunger( mc(h - 5, 100, maximum) )
            player:SetThirst( mc(t - 5, 100, maximum) )
        end;
        if h < 15 then
            player:SetHealth( mc(player:Health() - 1, 0, player:GetMaxHealth()) )
            if wep:GetClass() == 'ix_hands' then wep:DropObject(true) end;
            if (player:IsFemale() and !painSound:find("female")) then painSound:gsub("male", "female") end
            player:EmitSound(painSound)
        end;
        if t < 15 then
            player:SetHealth( mc(player:Health() - 1, 0, player:GetMaxHealth()) )
            player:EmitSound('usesound/cough_0.wav');
        end;

        if s < 35 then
            local srandom = math.random(1, 35)
            if srandom > s then
                player:SetRagdolled(true, srandom)
                player:ScreenFade(SCREENFADE.IN, color_black, 0.5, srandom)
                local moanSound = 'vo/npc/male01/moan01.wav'
                if (player:IsFemale() and !moanSound:find("female")) then moanSound:gsub("male", "female") end
                player:EmitSound(moanSound)
            end;
        end;

        if h < 65 then
            if math.random(100) > 50 then
                player:ChatNotify('** Я хочу немного поесть.')
            end;
        elseif h < 45 then
            if math.random(100) > 50 then
                player:ChatNotify('** Мне болит живот и очень сильно.')
            end;
        elseif h < 15 then
            if math.random(100) > 50 then
                player:ChatNotify('** Я точно без еды не протяну.')
            end;
        end;

        if t < 65 then
            if math.random(100) > 50 then
                player:ChatNotify('** В горле слегка пересохло.')
            end;
        elseif t < 45 then
            if math.random(100) > 50 then
                player:ChatNotify('** Я сильно хочу воды, хоть какой.')
            end;
        elseif t < 15 then
            if math.random(100) > 50 then
                player:ChatNotify('** Я не протяну больше без воды...')
            end;
        end;



        --[[
            .Голод будет в механическом плане влиять на скорость передвижения в общем. 
            .Игрок не сможет двигаться при низком голоде, прыгать или бегать.
            .Чем меньше голод, тем больше человек будет получать помутнение в глазах.
            .При голоде у человека отнимается по 1 хп.

            Уменьшается:
            .пассивно по 0.1 - 1 в 5 минут.
            .В зависимости от силы жажды.
        ]]
        --[[
            .Жажда будет в механическом плане влиять на усиление голода, усталости и ослабление иммунитета.
            .При обезвоживании у человека отнимается по 1 хп.

            Уменьшается:
            .Пассивно по 0.1 - 1 в 5 минут.
            .При беге, прыжках, ходьбе в присяде.
            .При ношении большого веса.
        ]]
        --[[
            .Усталость будет влиять на шансы в крафтинге(в будущем), переносимый вес и помутнение сознания(появление серости, потемнения).
            .Если у игрока слишком сильная усталость, то: он упадет в обморок; Он не может использовать двери и предметы при низкой усталости;

            .При выходе с сервера и отсутствии игрока на нем в течении 1-2 часов - усталость полностью восстанавливается.
            .Усталость: Игрок, если он гражданский или го, может лечь спать в любом месте. Однако количество времени он выбирает сам, как и последствия от поверхности.
            .Ситы ложатся в анимки, а ГОшники должны посмотреть вверх, сидя на любой поверхности. Костыль, ну да ладно.
            .Уменьшение: -0.05 в 5 минут.
        ]]

        --[[
            Комплексное:

            В будущем усталость должна будет влиять на скорость работы на станках.
            В будущем жажда должна влиять на шанс появления болезней.
            .В чате или на экране у игрока должны появляться уведомления о том, что ему нужно покушать.

            Если человек съест больше, чем 125 за раз, то есть шанс, что его стошнит. Небольшой, но есть.
            Тогда человек не сможет есть еду в течении нескольких минут, а его жажда и голод уменьшаются в два раза.
        ]]

        player:SetWalkSpeed( mc(maxwalk - (100 - h), maxwalk - (100 - h), maxwalk) )
        player:SetJumpPower( mc(200 - (maximum - h), 200 - (maximum - h), 200) )
        player:SetSlowWalkSpeed( mc(100 - (maximum - h), 100 - (maximum - h), 100) )
        player:SetRunSpeed( mc(maxRun - (150 - h), maxRun - (150 - h), maxRun) )
        player:SetCrouchedWalkSpeed( mc(0.3 - (0.4 - (math.Round(h/30)/10) ), 0.3 - (0.3 - (math.Round(h/30)/10) ), 0.3) )        
    end;

end;

function PLUGIN:PlayerUse(client, entity)
    local s = client:GetSleep()
    if entity:IsDoor() then
        return entity:IsDoor() && s > 25;
    end;

end;

local function ChangeThirst(player)

    local character = player:GetCharacter();
    local t = player:GetThirst()
    local sprint, jump, crouches = player:IsSprinting(), player:KeyDown(IN_JUMP), player:KeyDown(IN_FORWARD) && player:Crouching()
    local weight = character:GetData('carry')

    if character then
        if sprint or jump or crouches then
            player:SetThirst( mc(t - 0.01, minimum, maximum) )
        end;
        player:SetThirst( mc(t - weight/1000, minimum, maximum))
    end;

end;

function PLUGIN:ShowHelp(ply)

    netstream.Start(ply, 'OpenSleepInterface')

end

function PLUGIN:PostPlayerLoadout(client)
    local uniqueID = "r_needs_" .. client:SteamID()
    local ThirstuniqueID = "r_thirst_" .. client:SteamID()

    timer.Create(uniqueID, timeVar, 0, function()
        if !client:GetCharacter() then
            timer.Remove(uniqueID)
            return
        end
        ChangeNeeds(client)
    end)

    timer.Create(ThirstuniqueID, 1, 0, function()
        if !client:GetCharacter() then
            timer.Remove(uniqueID)
            return
        end

        ChangeThirst(client)
    end)
end

function PLUGIN:CharacterPreSave(character)
    local client = character:GetPlayer()

    if (IsValid(client)) then
        character:SetData("hunger", client:GetLocalVar("hunger", 0))
        character:SetData("thirst", client:GetLocalVar("thirst", 0))
        character:SetData("sleep", client:GetLocalVar("sleep", 0))
    end
end

function PLUGIN:PlayerLoadedCharacter(client, character)
    timer.Simple(0.25, function()
        client:SetLocalVar("hunger", character:GetData("hunger", 100))
        client:SetLocalVar("thirst", character:GetData("thirst", 100))
        client:SetLocalVar("sleep", character:GetData("sleep", 100))

        local query = mysql:Select("ix_characters")
    		query:Where("id", character:GetID())
            query:Select("last_join_time")
            query:Callback(function(result)
                local joinTime = result[1]['last_join_time']
                local timeTable = {
                    year = os.date("%Y", joinTime),
                    month = os.date("%m", joinTime),
                    day = os.date("%d", joinTime),
                    hour = os.date("%H", joinTime),
                    minute = os.date("%M", joinTime),
                    second = os.date("%S", joinTime)
                }
                local timeRightNow = system.SteamTime()
                local tblRightNow = {
                    year = os.date("%Y", timeRightNow),
                    month = os.date("%m", timeRightNow),
                    day = os.date("%d", timeRightNow),
                    hour = os.date("%H", timeRightNow),
                    minute = os.date("%M", timeRightNow),
                    second = os.date("%S", timeRightNow)
                }
                if tonumber(timeTable['year']) < tonumber(tblRightNow['year'])
                or tonumber(timeTable['month']) < tonumber(tblRightNow['month'])
                or tonumber(timeTable['day']) < tonumber(tblRightNow['day'])
                or tonumber(timeTable['hour']) + 2 < tonumber(tblRightNow['hour'])
                then
                    client:SetSleep(125)
                end;

            end);
        query:Execute()

    end)
end

--[[ meta ]]--
local player = FindMetaTable('Player')

function player:SetHunger(number)
    local character = self:GetCharacter();

    character:SetData("hunger", number)
    self:SetLocalVar("hunger", character:GetData("hunger", 100))
    return number
end;

function player:SetThirst(number)
    local character = self:GetCharacter();

    character:SetData("thirst", number)
    self:SetLocalVar("thirst", character:GetData("thirst", 100))
    return number
end;

function player:SetSleep(number)
    local character = self:GetCharacter();

    character:SetData("sleep", number)
    self:SetLocalVar("sleep", character:GetData("sleep", 100))
    return number
end;

function player:GetHunger(number)
    local character = self:GetCharacter();

    number = number or 0

    return tonumber(character:GetData("hunger", number))
end;

function player:GetThirst(number)
    local character = self:GetCharacter();

    number = number or 0

    return tonumber(character:GetData("thirst", number))
end;

function player:GetSleep(number)
    local character = self:GetCharacter();

    number = number or 0

    return tonumber(character:GetData("sleep", number))
end;

local function AllowedSleeping()
    local animationTable = {
		"Lying_Down",
		"d1_town05_Winston_Down",
		"d2_coast11_Tobias",
		"sniper_victim_pre",
        "Sit_Ground",
        "d1_town05_Wounded_Idle_1"
    }
    
    return animationTable;
end;

netstream.Hook('SleepStart', function(player, number)
    local seq = player:GetNetVar("forcedSequence");
    local allowedSequences = AllowedSleeping();
    local alive = player:Alive();
    local character = player:GetCharacter()
    local modelClass = ix.anim.GetModelClass(player:GetModel())
    
    if alive && character then
        local isSleeping = player:GetLocalVar("IsSleeping", false)
        local hunger, thirst, sleep = player:GetHunger(), player:GetThirst(), player:GetSleep()

        if sleep >= 95 then player:Notify("Я не хочу спать.") return; end;

        if isSleeping then player:Notify("Вы уже спите!") return; end;

        if ((seq && table.HasValue(allowedSequences, player:GetSequenceName( seq )) && modelClass != 'metrocop') or (modelClass == 'metrocop' && player:Crouching()) ) then
            player:SetLocalVar("IsSleeping", true);
            player:ScreenFade( SCREENFADE.OUT, color_black, 1, number )
            player:SetRestricted(true, true);

            player:SetAction("[Сон]", number, function()
                player:ScreenFade( SCREENFADE.IN, color_black, 0.5, 1 )
                player:SetLocalVar("IsSleeping", false);
                player:SetRestricted(false, true);

                player:SetHunger( mc(hunger - hunger*0.5, 0, 100) )
                player:SetThirst( mc(thirst - thirst*0.5, 0, 100) )
                player:SetSleep( mc( sleep + number*0.5*10 , 0, 100))
            end);

        else
            player:Notify("Вы должны лежать, чтобы начать спать.")
        end;
    end;
end)