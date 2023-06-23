
local PLUGIN = PLUGIN;
local p = FindMetaTable( "Player" )
local math = math;
local mc = math.Clamp;

function PLUGIN:PlayerSaveCharacterData(player, data)
	if (data["Sympthoms"]) then
		data["Sympthoms"] = data["Sympthoms"];
	else
		data["Sympthoms"] = {};
    end;
    if (data["Diseases"]) then
		data["Diseases"] = data["Diseases"];
	else
		data["Diseases"] = {};
	end;
end;
function PLUGIN:PlayerRestoreCharacterData(player, data)
	if ( !data["Sympthoms"] ) then
		data["Sympthoms"] = {};
    end;
    if ( !data["Diseases"] ) then
		data["Diseases"] = {};
    end;
    if ( !data["Immunity"] ) then
		data["Immunity"] = 100;
    end;
end;

function p:CreateSpecialEffect( effect )
	local trace = {};
	trace.start = self:GetPos();
	trace.endpos = trace.start;
	trace.filter = self;
	trace = util.TraceLine(trace);

	return util.Decal(effect, trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal);
end;

function PLUGIN:PlayerSetSharedVars(player, curTime)
	player:SetSharedVar("Eyeache", player:HasSym("eyeache"));
    player:SetSharedVar("DiseaseEyeache", player:HasLocalDisease("eyeache"));
end;

function p:AddSympthom(sym)
    local data = self:GetCharacterData("Sympthoms", {});
    
    if !table.HasValue(data, sym) && IsValidSympthom(sym) then
        table.insert(data, sym)
    end;

return;
end;

function p:RemSym(sym)
    local data = self:GetCharacterData("Sympthoms", {});

    data[table.KeyFromValue( data, sym )] = nil;

    return;
end;

function p:HasSym(sym)
	local data = self:GetCharacterData("Sympthoms", {});

    if table.HasValue(data, sym) then
        return true;
    end;

return false;
end;

function p:RemLocalDisease(name)
    local data = self:GetCharacterData("Diseases", {});

    data[table.KeyFromValue( data, name )] = nil;

    return;
end;

function p:HasLocalDisease(name)
    local data = self:GetCharacterData("Diseases", {});

    if table.HasValue(data, name) then
        return true;
    end;

    return false;
end;

function p:AddLocalDisease(name)
    local data = self:GetCharacterData("Diseases", {});

    if !self:HasLocalDisease(name) then
        table.insert(data, name)
    end;

    return;
end;

function IsValidSympthom(name)
    local sympthoms = {
        "cough",
        "temperature",
        "vomit",
        "eyeache",
        "bloodcough",
        "headache"
    };
    if table.HasValue(sympthoms, string.lower(name)) then
        return true;
    end;

    return false;
end;

function IsValidDisease(name)
    local disease = {
        "orvi",
        "poisoned",
        "eyeache",
        "infection"
    };
    if table.HasValue(disease, string.lower(name)) then
        return true;
    end;

    return false;
end;

function PLUGIN:PlayerThink(player, curTime, infoTable)
    local immunity = player:GetCharacterData("Immunity");
    local toxins = player:GetCharacterData("Toxins");
    local tempPly = player:GetCharacterData("BodyTemp");
    local clean = player:GetNeed("clean");
    local hunger = player:GetNeed('hunger');
    local sleep = player:GetNeed('sleep');
    local health = player:Health();
    local maxhealth = player:GetMaxHealth();
    local sympthoms = {
        "cough",
        "headache"
    };
    local cough = player:HasSym("cough");
    local temp =  player:HasSym("temperature");
    local vomit = player:HasSym("vomit");
    local eyeache = player:HasSym("eyeache");
    local bCough = player:HasSym("bloodcough");
    local head = player:HasSym("headache");
    local disOrvi = player:HasLocalDisease("orvi");
    local poison = player:HasLocalDisease("poisoned");
    local diseyeache = player:HasLocalDisease("eyeache");
    local disInf = player:HasLocalDisease("infection");
    local dec = 0;

    return;

    if (!player.decreaseImmunity || curTime >= player.decreaseImmunity) then

        if player:GetAverageHeat() > 300 then
            dec = 0.5 + (player:GetAverageHeat()/100)

        elseif player:GetAverageHeat() < 170 then
            dec = 2 + (player:GetAverageHeat()/100 + 1)

        elseif player:GetAverageHeat() >= 170 && player:GetAverageHeat() <= 300 then
            dec = 0.2
        end;
        local bufferedImmunity = immunity;

        player:SetCharacterData("Immunity", mc(immunity - dec - (toxins/1000) + GetSkillValue(player, ATB_SUSPECTING)/10, 0, 100))

        if bufferedImmunity < immunity && dec != 0.2 then
            player:EmitSound('usesound/cough_0.mp3')
        end;
        player.decreaseImmunity = curTime + 60;
    end;

    if (!player.checkdisease or curTime >= player.checkdisease) then

        if immunity < 40 then
            if math.random(50) - 5 > immunity then
                player:AddSympthom(sympthoms[math.random(1, 2)])
            end;
        end;

        if cough && temp && !disOrvi then
            player:AddLocalDisease("orvi");
        elseif (!cough || !temp) && disOrvi then
            player:RemLocalDisease("orvi");
        end;
        if vomit && temp && !poison then
            player:AddLocalDisease("poisoned");
        elseif (!vomit || !temp) && poison then
            player:RemLocalDisease("poisoned");
        end;
        if eyeache && !diseyeache then
            player:AddLocalDisease("eyeache");
        elseif !eyeache && diseyeache then
            player:RemLocalDisease("eyeache");
        end;
        if (bCough && head && temp) && !disInf then
            player:AddLocalDisease("infection");
        elseif (!bCough || !head || !temp) && disInf then
            player:RemLocalDisease("infection");
        end;

        if head then
            Schema:PlayerStunEntity(player, player)
            if player:GetGender() == GENDER_MALE then
                player:EmitSound("vo/npc/male01/moan0"..math.random(1, 5)..".wav")
            else
                player:EmitSound("vo/npc/female01/moan0"..math.random(1, 5)..".wav")
            end;
        end;

        if cough || bCough then
            player:EmitSound("ambient/voices/cough"..math.random(1, 4)..".wav");
            if bCough then
                player:CreateSpecialEffect( "Blood" )
                if health > 35 then
                    player:SetHealth( mc(health - 1, 0, maxhealth))
                end;
            end;
        end;

        if temp && tempPly > 37.3 then
            Clockwork.hint:SendCenter(player, "Вам очень жарко.", 10, Color(255, 100, 100), true, true);
            player:SetNeed("clean", mc(clean - 0.05, 0, 100));
        end;

        if vomit || poison then
            player:CreateSpecialEffect( "Antlion.Splat" )
            player:EmitSound("npc/barnacle/barnacle_die2.wav")
            if hunger > 40 then
                player:SetOneNeed("hunger", mc(hunger - 40, 0, 100))
            elseif hunger < 40 && !player:IsRagdolled() then
                Clockwork.player:SetRagdollState(player, RAGDOLL_KNOCKEDOUT, 30);
            end;

            if poison then
                player:SetHealth(mc(health - 2, 0, maxhealth))
            end;
        end;

        if disOrvi then
            player:SetOneNeed("sleep", mc( sleep - 10, 0, 100 ))
        end;

        if infection then
            if maxhealth > 25 && health > 25 then
                player:SetMaxHealth(mc(maxhealth - 10, 0, 100))
                player:SetHealth(mc(health - 10, 0, maxhealth))
            end;
        end;
        
        player.checkdisease = curTime + 300;
    end;

end;
