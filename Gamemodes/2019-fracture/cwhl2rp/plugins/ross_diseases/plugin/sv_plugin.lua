
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

function p:AddSympthom(sym)
    local data = self:GetCharacterData("Sympthoms", {});
    
    if !table.HasValue(data, sym) then
        table.insert(data, sym)
    end;

return;
end;

function p:RemSym(sym)
    local data = self:GetCharacterData("Sympthoms", {});

    if table.HasValue(data, name) then
        table.RemoveByValue(data, name)
    end;

    return;
end;

function p:HasSym(sym)
	local data = self:GetCharacterData("Sympthoms", {});

    if table.HasValue(data, sym) then
        return true;
    end;

return false;
end;

function p:AddLocalDisease(name)
    local data = self:GetCharacterData("Diseases", {});

    if !table.HasValue(data, name) then
        table.insert(data, name)
    end;

    return;
end;

function p:RemLocalDisease(name)
    local data = self:GetCharacterData("Diseases", {});

    if table.HasValue(data, name) then
        table.RemoveByValue(data, name)
    end;

    return;
end;

function p:HasLocalDisease(name)
    local data = self:GetCharacterData("Diseases", {});

    if table.HasValue(data, name) then
        return true;
    end;

    return false;
end;

function IsValidSympthom(name)
    local sympthoms = {
        "cought",
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
    if (!player.decreaseImmunity || curTime >= player.decreaseImmunity) then
        local temperatureInfl = 0;
        if tempPly < 36 && immunity > 0 then
            temperatureInfl = tempPly/10
        elseif tempPly > 36 && immunity < 100 then
            temperatureInfl = -tempPly/10
        end;
        player:SetCharacterData("Immunity", mc(immunity - ((toxins/1000) + temperatureInfl) + GetSkillValue(player, ATB_SUSPECTING)/10, 0, 100))
        player.decreaseImmunity = curTime + 10;
    end;

    if (!player.checkdisease or curTime >= player.checkdisease) then

        if player:GetCharacterData("Immunity") < 40 then
            local sympthoms = {
                "cought",
                "headache"
            };
            if math.random(100) > player:GetCharacterData("Immunity") then
                player:AddSympthom(sympthoms[math.random(1, 2)])
            end;
        end;

        if player:HasSym("cough") && player:HasSym("temperature") && !player:HasLocalDisease("orvi") then
            player:AddLocalDisease("orvi");
        elseif !player:HasSym("cough") || !player:HasSym("temperature") && player:HasLocalDisease("orvi") then
            player:RemLocalDisease("orvi");
        end;
        if player:HasSym("vomit") && player:HasSym("temperature") && !player:HasLocalDisease("poisoned") then
            player:AddLocalDisease("poisoned");
        elseif !player:HasSym("vomit") || !player:HasSym("temperature") && player:HasLocalDisease("poisoned") then
            player:RemLocalDisease("poisoned");
        end;
        if player:HasSym("eyeache") && !player:HasLocalDisease("eyeache") then
            player:AddLocalDisease("eyeache");
        elseif !player:HasSym("eyeache") && player:HasLocalDisease("eyeache") then
            player:RemLocalDisease("eyeache");
        end;
        if player:HasSym("bloodcough") && player:HasSym("headache") && player:HasSym("temperature") && !player:HasLocalDisease("infection") then
            player:AddLocalDisease("infection");
        elseif !player:HasSym("bloodcough") || !player:HasSym("headache") || !player:HasSym("temperature") && player:HasLocalDisease("infection") then
            player:RemLocalDisease("infection");
        end;

        if player:HasSym("cough") || player:HasSym("bloodcough") then
            player:EmitSound("ambient/voices/cough"..math.random(1, 4)..".wav");
            if player:HasSym("bloodcough") then
                player:CreateSpecialEffect( "Blood" )
            end;
        end;
        if player:HasSym("temperature") then
            Clockwork.hint:SendCenter(player, "В один момент вам становится жарко.", 10, Color(255, 100, 100), true, true);
            player:SetNeed("clean", mc(player:GetNeed("clean") + 0.05, 0, 100));
        end;
        if player:HasSym("vomit") then
            player:CreateSpecialEffect( "Antlion.Splat" )
            player:SetNeed("clean", mc(player:GetNeed("clean") + 1.6, 0, 100));
            player:EmitSound("npc/barnacle/barnacle_die2.wav")
            if player:Health() >= 20 then
                player:SetHealth(mc(player:Health() - 15, 20, 100))
            elseif player:Health() < 20 && !player:IsRagdolled() then
                Clockwork.player:SetRagdollState(player, RAGDOLL_KNOCKEDOUT, 30);
            end;
        end;
        player.checkdisease = curTime + 300;
    end;

end;