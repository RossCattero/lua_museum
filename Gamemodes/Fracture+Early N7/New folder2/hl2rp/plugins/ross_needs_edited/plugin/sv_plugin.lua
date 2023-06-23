
local PLUGIN = PLUGIN;
local p = FindMetaTable( "Player" )
local math = math;
local mc = math.Clamp
PLUGIN.const = 0.25;

function PLUGIN:PlayerRestoreCharacterData(player, data)
	if ( !data["NeedsTable"] ) then
		data["NeedsTable"] = {
            hunger = 100,
            thirst = 100,
            sleep = 100
        };
    end;
    if !data["Sleeping"] then
        data["Sleeping"] = false;
    end;
end;

function PLUGIN:PlayerSaveCharacterData(player, data)
	if (data["NeedsTable"]) then
		data["NeedsTable"] = data["NeedsTable"];
	else
	    data["NeedsTable"] = {
            hunger = 100,
            thirst = 100,
            sleep = 100
        };
    end;
end;

-------

function p:GetNeed(need)
    local index = self:GetCharacterData("NeedsTable")

    return index[need]
end;

function p:SetNeed(need, number)
    local index = self:GetCharacterData("NeedsTable")

    index[need] = mc(index[need] - number, 0, 100);

end;

function p:SetOneNeed(need, number)
    local index = self:GetCharacterData("NeedsTable")

    index[need] = number;
end;

function AllowedSleeping()
    local animationTable = {
		"Lying_Down",
		"d1_town05_Winston_Down",
		"d2_coast11_Tobias",
		"sniper_victim_pre",
		"Sit_Ground"
    }
    
    return animationTable;
end;

function IsNearSleepingSource(player)
    for k, v in ipairs( ents.FindInSphere(player:GetPos(), 5)) do
        if (v:GetClass() == "sleeping_bag_unpacked") || (v:GetClass() == "prop_physics" && v:GetModel() == "models/props_c17/FurnitureMattress001a.mdl") then
            return true;
        end;
    end;

    return false;
end;
-------

function PLUGIN:EntityHandleMenuOption(player, entity, option, arguments)
    local e = entity:GetClass();
    local isBag = e == "sleeping_bag_unpacked";
    local trace = player:GetEyeTraceNoCursor();
    if isBag then
        if arguments == "sleeping_bag_pack" then
            Clockwork.entity:CreateItem(player, Clockwork.item:CreateInstance("sleeping_bag"), entity:GetPos());
            entity:Remove();
        end;
    end;
end;

function PLUGIN:PlayerSetSharedVars(player, curTime)
	player:SetSharedVar("hunger", player:GetNeed("hunger"));
	player:SetSharedVar("thirst", player:GetNeed("thirst"));
	player:SetSharedVar("sleep", player:GetNeed("sleep"));
    
end;

function PLUGIN:PlayerCanUseItem(player, itemTable, bNoMsg)
    local sleep = player:GetNeed("sleep");
    if PlayerIsSleeping(player) || sleep < 25 then
        Clockwork.chatBox:SendColored(player, Color(255, 100, 100), "Вы слишком устали или спите!")
        return false;
    end;
end;

function Clockwork:PlayerCanSayIC(player, text)
    if PlayerIsSleeping(player) then
        return false;
    end;
end;

function PLUGIN:PlayerThink(player, curTime, infoTable)

    local animationTable = AllowedSleeping();
    local fac = player:GetFaction();
    local move = player:GetMoveType();
    local const = PLUGIN.const;
    local random = math.random(100);
    local inc = random > 15;
    local walking = player:GetVelocity():Length();
    local running = player:IsRunning();
    local rag = player:IsRagdolled();
    local alive = player:Alive();
    local crouch = player:Crouching();
    local name = player:GetName();
    local health = player:Health();
    local maxhealth = player:GetMaxHealth();
    local plyIsCombine = Schema:PlayerIsCombine(player) || fac == FACTION_CREMATOR || fac == FACTION_OTA;
    local gen = player:GetGender();
    local Pind = player:EntIndex();
    local invw = player:GetInventoryWeight();
    local maxWeight = player:GetMaxWeight();
    local runSpeed = Clockwork.config:Get("run_speed"):Get();
    local walkspeed = Clockwork.config:Get("walk_speed"):Get();
    local jumpPower = Clockwork.config:Get("jump_power"):Get();
    local modelClass = Clockwork.animation:GetModelClass(player:GetModel());
    local immunity = player:GetCharacterData("Immunity");

    local first = Color(71, 218, 16);
    local second = Color(218, 213, 16)
    local third = Color(217, 126, 17)

    local hunger = player:GetNeed("hunger");
    local thirst = player:GetNeed("thirst");
    local sleep = player:GetNeed("sleep");

    if fac == FACTION_CREMATOR || fac == FACTION_OTA || move == MOVETYPE_NOCLIP || !alive then
        return;
    end;

    if !player.np || curTime >= player.np then
        if inc then
            player:SetNeed( "hunger", math.random(0, const) );
            player:SetNeed( "thirst", math.random(0, const) );
            player:SetNeed( "sleep", math.random(0, const) );
        end;

        if hunger <= 25 then
            Clockwork.player:SetRagdollState(player, RAGDOLL_KNOCKEDOUT, 60)
            Clockwork.chatBox:AddInRadius(player, "it", name.." в один момент начинает пошатываться и, закатив глаза, падает на землю, отключаясь.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get());
            Clockwork.hint:SendCenter(player, "Вам срочно надо поесть!", 30, Color(255, 100, 100), true, true);
            if health > 25 then
                player:SetHealth(health - math.random(1, 3), 0, maxhealth);
                Clockwork.limb:TakeDamage(player, HITGROUP_STOMACH, math.random(0.01, const))

                if !plyIsCombine then
                    if gen == GENDER_MALE then
                        player:EmitSound("vo/npc/male01/mygut02.wav");
                    else
                        player:EmitSound("vo/npc/female01/mygut02.wav");
                    end;
                end;

            end;
        end;
        if thirst <= 25 then
            Clockwork.limb:TakeDamage(player, HITGROUP_STOMACH, math.random(0.01, const * 3));
            player:EmitSound("ambient/voices/cough"..math.random(1, 4)..".wav");
            Clockwork.hint:SendCenter(player, "Вам срочно надо попить!", 30, Color(255, 100, 100), true, true);
            Clockwork.attributes:Update(player, ATB_ENDURANCE2, -math.random(0.1, const) )

            if health > 25 then
                player:SetHealth(health - math.random(1, 3), 0, maxhealth);
            end;
        end;
        if sleep <= 25 then
            Clockwork.player:SetRagdollState(player, RAGDOLL_KNOCKEDOUT, 80);
            timer.Create("fallen: "..Pind, 1, 40, function()
                if sleep < 35 then
                    player:SetNeed("sleep", 0.5)
                else return;
                end;
            end);
            Clockwork.limb:TakeDamage(player, HITGROUP_HEAD, math.random(0.01, const * 2));
            Clockwork.chatBox:AddInRadius(player, "it", name.." падает на землю от изнеможения.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get());
            Clockwork.hint:SendCenter(player, "Вам срочно надо отдохнуть!", 30, Color(255, 100, 100), true, true);

            if health > 25 then
                player:SetHealth(health - math.random(1, 5), 0, maxhealth);
            end;
        end;

        if inc then
            
            if hunger <= 25 then
                Clockwork.hint:SendCenter(player, "Вы умираете с голоду!", 30, first, true, true);
            elseif hunger <= 50 then
                Clockwork.hint:SendCenter(player, "Вы голодны.", 30, second, true, true);
            elseif hunger <= 75 then
                Clockwork.hint:SendCenter(player, "У вас урчит в животе.", 30, third, true, true);
            end;
            if thirst <= 25 then
                Clockwork.hint:SendCenter(player, "У вас жажда.", 30, first, true, true);
            elseif thirst <= 50 then
                Clockwork.hint:SendCenter(player, "Вы чувствуете, что сильно хотите пить.", 30, second, true, true);
            elseif thirst <= 75 then
                Clockwork.hint:SendCenter(player, "Вам хочется пить.", 30, third, true, true);
            end;
        
            if sleep <= 25 then
                Clockwork.hint:SendCenter(player, "Вы не можете стоять на ногах.", 30, first, true, true);
            elseif sleep <= 50 then
                Clockwork.hint:SendCenter(player, "Вы чувствуете ломку в мышцах.", 30, second, true, true);
            elseif sleep <= 75 then
                Clockwork.hint:SendCenter(player, "Вы чувствуете себя уставшим.", 30, third, true, true);
            end;

        end;

        player.np = curTime + 200;
    end;

    if !player.walking || curTime >= player.walking then

        if inc then
            if walking > 0 && !running then
                player:SetNeed( "hunger", math.random(0, 0.03) );
                player:SetNeed( "thirst", math.random(0, 0.03) );
                player:SetNeed( "sleep", math.random(0, 0.03) );
            elseif walking > 0 && running then
                Clockwork.attributes:Update(player, ATB_ENDURANCE2, math.random(0.01, 0.03))
                player:SetNeed( "hunger", math.random(0, 0.05) );
                player:SetNeed( "thirst", math.random(0, 0.05) );
                player:SetNeed( "sleep", math.random(0, 0.05) );
            elseif crouch then
                player:SetNeed( "hunger", math.random(0, 0.01) );
                player:SetNeed( "thirst", math.random(0, 0.01) );
                player:SetNeed( "sleep", math.random(0, 0.005) );
            end;
        end;

        if rag then
            player:SetNeed( "sleep", math.random(0, -0.03) );
        end;

        if player:GetForcedAnimation() != nil then
            if sleep > 0 && alive && modelClass == "maleHuman" && table.HasValue(animationTable, player:GetForcedAnimation()['animation']) then
                if IsNearSleepingSource(player) then
                    player:SetOneNeed("sleep", mc(sleep + const*3, 0, 100))
                elseif !IsNearSleepingSource(player) then
                    player:SetOneNeed("sleep", mc(sleep + const*math.random(0, 1.5), 0, 100))
                    if random > immunity then
                        player:AddSympthom("cough");
                    end;
                end;
            end;
        end;

        if sleep > 0 && alive && modelClass == "civilProtection" && rag then

            if IsNearSleepingSource(player) then
                player:SetOneNeed("sleep", mc(sleep + const*5, 0, 100))
            elseif !IsNearSleepingSource(player) then
                player:SetOneNeed("sleep", mc(sleep + const*math.random(0, 2), 0, 100))
                if random > immunity then
                    player:AddSympthom("cough");
                end;
            end;
        end;

        player.walking = curTime + 2;
    end;

    if invw < (maxWeight + 2) then
        infoTable.runSpeed = mc(infoTable.runSpeed - (sleep + thirst + hunger + (invw*0.5))/10, 1, runSpeed);
    	infoTable.walkSpeed = mc(infoTable.walkSpeed - (sleep + thirst + hunger + (invw*0.5))/100, 1, walkspeed);
        infoTable.jumpPower = mc(infoTable.jumpPower - (sleep + thirst + hunger + (invw*0.5))/10, 1, jumpPower);
    elseif invw > (maxWeight + 2) then
        infoTable.runSpeed = 1;
        infoTable.walkSpeed = 1;
        infoTable.jumpPower = 1;
    end;

end;

cable.receive('StartSleeping', function(player, num)

    if Schema:PlayerIsCombine(player) then
        Clockwork.chatBox:SendColored(player, Color(255, 100, 100), "Вам запрещено использовать команду сна!")
        return;
    end;
    if player:GetForcedAnimation() == nil then
        Clockwork.chatBox:SendColored(player, Color(255, 100, 100), "Вы не находитесь в нужной анимации!")
        return;
    end;

    local animationTable = AllowedSleeping();
    local IsSleeping = PlayerIsSleeping(player);
    local immunity = player:GetCharacterData("Immunity");
    local random = math.random(100);
    local sleep = player:GetNeed("sleep");

    if !IsSleeping && table.HasValue(animationTable, player:GetForcedAnimation()['animation']) then

        Clockwork.player:SetAction(player, "sleeping", num);
        Clockwork.player:ConditionTimer(player, num, function()
            if (!player:Alive() || player:GetVelocity():Length() > 0) then
                return false;
            end;
            return true;
        end, function()
            if IsNearSleepingSource(player) then
                player:SetOneNeed("sleep", mc(sleep + 0.015*60*num, 0, 100))
            elseif !IsNearSleepingSource(player) then
                player:SetOneNeed("sleep", mc(sleep + 0.015*20*num, 0, 100))
                if random > immunity then
                    player:AddSympthom("cough");
                end;
            end;
            Clockwork.player:SetAction(player, "sleeping", false);
        end);        

    elseif IsSleeping then
        Clockwork.chatBox:SendColored(player, Color(255, 100, 100), "Вы уже спите!")
    elseif !table.HasValue(animationTable, player:GetForcedAnimation()['animation']) then
        Clockwork.chatBox:SendColored(player, Color(255, 100, 100), "Вы не находитесь в нужной анимации!")
    end;

end);