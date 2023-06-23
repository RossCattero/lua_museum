
local PLUGIN = PLUGIN;

function PLUGIN:PlayerRestoreCharacterData(player, data)
	if ( !data["CombinedInfo"] && Schema:PlayerIsCombine(player) ) then
		data["CombinedInfo"] = {
            Squad = "UNION",
            Status = "10-7",
            Info = "Just a regular MPF unit...",
            CombineRank = "RCT"
        };
    end;
    if ( !data["CitizenInfo"] ) then
        data["CitizenInfo"] = {
            ol = 0,
            on = 0,
            work = "",
            liveplace = "",
            information = "",
            parentedCardNumber = 0
        };
    end;
    if !data["GivenCitizenCard"] then
        data["GivenCitizenCard"] = false;
    end;

end;

function PLUGIN:PlayerSaveCharacterData(player, data)
	if (data["CombinedInfo"] && Schema:PlayerIsCombine(player) ) then
		data["CombinedInfo"] = data["CombinedInfo"];
	else
	    data["CombinedInfo"] = {
            Squad = "UNION",
            Status = "10-7",
            Info = "Just a regular MPF unit...",
            CombineRank = "RCT"
        };
    end;

    if (data["CitizenInfo"]) then
        data["CitizenInfo"] = data["CitizenInfo"];
    else
        data["CitizenInfo"] = {
            ol = 0,
            on = 0,
            work = "",
            liveplace = "",
            information = "",
            parentedCardNumber = 0
        };
    end;   

end;

function PLUGIN:PlayerSetSharedVars(player, curTime)
    if Schema:PlayerIsCombine(player) then
        local combineData = player:GetCharacterData("CombinedInfo")
    
        player:SetSharedVar("squad", combineData["Squad"]);
    	player:SetSharedVar("status", combineData["Status"]);
        player:SetSharedVar("info", combineData["Info"]);
        player:SetSharedVar("CombineRanke", combineData["CombineRank"])
    end;
end;

function PLUGIN:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)
    local CP = player:GetCharacterData("CombinedInfo")
    if Schema:PlayerIsCombine(player) then
        if CP["CombineRank"] != Schema:GetCombineRank(player:Name()) then
            CP["CombineRank"] = Schema:GetCombineRank(player:Name());
        end;
    end;
end;
function PLUGIN:PlayerNameChanged(player, previousName, newName)
    local CP = player:GetCharacterData("CombinedInfo")
    if Schema:PlayerIsCombine(player) then
        if CP["CombineRank"] != Schema:GetCombineRank(newName) then
            CP["CombineRank"] = Schema:GetCombineRank(newName);
        end;
    end;
end;

function pdaAddLog(name, ol, on, workinfo, liveinfo, editorName)
    table.insert(Schema.PDAlogs, {
        name = name,
        OL = ol,
        ON = on,
        WorkInfo = workinfo,
        LiveInfo = liveinfo,
        editor = editorName
    })
end;

cable.receive('ChangeDataOfUnit', function(player, type, str, name)

    for k, v in pairs(cwPlayer.GetAll()) do
        if v:GetFaction() == FACTION_MPF && v:GetName() == name && string.find(name, "C17") then
        local CP = v:GetCharacterData("CombinedInfo")
            if type == "Rank" then
                if !Schema:IsCombineRank(str) then
                    return;
                end;
                local nameStart, nameEnd = string.find( name, Schema:GetCombineRank(name) )
                if nameStart then
                    local nameReplacedText = string.sub( name, 1, nameStart - 1 ) .. str .. string.sub( name, nameEnd + 1 )
                    Clockwork.player:SetName(v, nameReplacedText);
                    CP["CombineRank"] = str;
                end;
            elseif type == "Squad" then 
                CP["Squad"] = str;
            elseif type == "Info" then 
                CP["Info"] = str;
            end;
        end;
    end;

end);

cable.receive('ChangePDAGlobalData', function(player, index, tbl)

    Schema.avaiblePDAs[index] = tbl;

end);

cable.receive('AddNewCombineLinePDA', function(player, name)

    local x, y, z = player:GetPos();
    local curTime = CurTime();
		
	if (!player.nextRequestTime || curTime >= player.nextRequestTime) then
		Schema:AddCombineDisplayLine( "!ГСР_ПДА: "..name.." запрашивает поддержку Гражданской Обороны на координатах: "..x..", "..y..", "..z..".", Color(255, 100, 100, 255) );
		Clockwork.chatBox:SendColored(player, "Ваш запрос доставлен юнитам ГО...")
    else
		Clockwork.player:Notify(player, "Вы не можете отправить запрос еще "..math.ceil(player.nextRequestTime - curTime).." секунд(ы)!");
	end;

end);

cable.receive('ChangeDataOfCitizen', function(player, type, callback, name)

    for k, v in pairs(cwPlayer.GetAll()) do
        if v:GetFaction() == FACTION_CITIZEN && v:GetName() == name then
        local CP = v:GetCharacterData("CitizenInfo")
            if type == "editOL" then
                CP["ol"] = CP["ol"] + callback;
                if v:FindItemByID("citizen_civ_card") then
                    v:FindItemByID("citizen_civ_card"):GetData("CardInformation")["OL"] = CP["ol"]
                end;
                pdaAddLog(name, CP["ol"], "---", "---", "---", player:GetName())
            elseif type == "editON" then 
                CP["on"] = CP["on"] + callback;
                if v:FindItemByID("citizen_civ_card") then
                    v:FindItemByID("citizen_civ_card"):GetData("CardInformation")["OL"] = CP["ol"]
                end;
                pdaAddLog(name, "---", CP["on"], "---", "---", player:GetName())
            elseif type == "LivePlace" then 
                CP["work"] = callback;
                pdaAddLog(name, "---", "---", CP["work"], "---", player:GetName())
            elseif type == "WorkPlace" then 
                CP["liveplace"] = callback;
                pdaAddLog(name, "---", "---", "---", CP["liveplace"], player:GetName())
            elseif type == "InfoR" then 
                CP["information"] = callback;     
            end;
        end;
    end;

end);

cable.receive('EditUniversalSettingsPDA', function(player, id, settings)
    local item = player:FindItemByID("cp_pda", id)
    
    item:SetData("SettingsData", settings)
    
end);

cable.receive('EditCodeForPDA', function(player, code)
    local t = player:GetEyeTraceNoCursor();
    local ent = t.Entity;
    local cardItem = player:FindItemByID("pda_password_edit")

    if ent:GetClass() == "cw_item" && player:GetPos():Distance(ent:GetPos()) < 90 && git(ent, "uniqueID") == "cwu_pda" then
        git(ent, "data")["CWU_PDA_INFO"]["Code"] = tonumber(code);
        cardItem:SetData("PasswordEdited", true);
    else
        local pda = player:FindItemByID("cwu_pda");
        if pda then
            pda:GetData("CWU_PDA_INFO")["Code"] = tonumber(code)
            cardItem:SetData("PasswordEdited", true);
        end;
    end;
end);

cable.receive("EditOptionsForCWUPDA", function(player, setting, info)
    local t = player:GetEyeTraceNoCursor();
    local ent = t.Entity;

    if setting == "Text" then

        if ent:GetClass() == "cw_item" && player:GetPos():Distance(ent:GetPos()) < 90 && git(ent, "uniqueID") == "cwu_pda" then
            git(ent, "data")["CWU_PDA_INFO"]["Notepad"] = info;
        else
            local pda = player:FindItemByID("cwu_pda");
            if pda then
                pda:GetData("CWU_PDA_INFO")["Notepad"] = info
            end;
        end;

    elseif setting == "Color" then

        if ent:GetClass() == "cw_item" && player:GetPos():Distance(ent:GetPos()) < 90 && git(ent, "uniqueID") == "cwu_pda" then
            git(ent, "data")["CWU_PDA_INFO"]["BackGroundColor"] = info;
        else
            local pda = player:FindItemByID("cwu_pda");
            if pda then
                pda:GetData("CWU_PDA_INFO")["BackGroundColor"] = info
            end;
        end;

    end;

end);

function PLUGIN:ClockworkInitPostEntity()
    Schema.avaiblePDAs = Clockwork.kernel:RestoreSchemaData("plugins/pda_info/"..game.GetMap());
    Schema.PDAlogs = Clockwork.kernel:RestoreSchemaData("plugins/pda_log/"..game.GetMap());
end;

function PLUGIN:PostSaveData()
    Clockwork.kernel:SaveSchemaData("plugins/pda_info/"..game.GetMap(), Schema.avaiblePDAs);
    Clockwork.kernel:SaveSchemaData("plugins/pda_log/"..game.GetMap(), Schema.PDAlogs);
end;

function PLUGIN:ItemEntityDestroyed(itemEntity, itemTable) 
    if Schema.avaiblePDAs[itemTable.itemID] then
        Schema.avaiblePDAs[itemTable.itemID] = nil;
    end;
end;