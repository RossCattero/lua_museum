
local PLUGIN = PLUGIN;

CP_PDA.CivilProtectionChat = {}

function PLUGIN:PlayerRestoreCharacterData(player, data)
	if ( !data["CombinedInfo"] && Schema:PlayerIsCombine(player) ) then
		data["CombinedInfo"] = {
            Squad = "UNION",
            Status = "10-7",
            Info = "Just a regular MPF unit...",
            CombineRank = "RCT"
        };
    end;
    if ( !data["CitizenInfo"] && !Schema:PlayerIsCombine(player) ) then
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

function PLUGIN:PlayerSaveCharacterData(player, data)
    if Schema:PlayerIsCombine(player) then
    	if (data["CombinedInfo"] ) then
    		data["CombinedInfo"] = data["CombinedInfo"];
	    else
    	    data["CombinedInfo"] = {
                Squad = "UNION",
                Status = "10-7",
                Info = "Just a regular MPF unit...",
                CombineRank = "RCT"
            };
        end;
    end;

    if !Schema:PlayerIsCombine(player) then
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

end;

function PLUGIN:PlayerSetSharedVars(player, curTime)
        local combineData = player:GetCharacterData("CombinedInfo")
        local citdata = player:GetCharacterData("CitizenInfo")
    
        if Schema:PlayerIsCombine(player) then
            player:SetSharedVar("squad", combineData["Squad"]);
        	player:SetSharedVar("status", combineData["Status"]);
            player:SetSharedVar("info", combineData["Info"]);
            player:SetSharedVar("CombineRanke", combineData["CombineRank"])
        end;
        if !Schema:PlayerIsCombine(player) then
            player:SetSharedVar("ol", citdata["ol"]);
        	player:SetSharedVar("on", citdata["on"]);
            player:SetSharedVar("liveplace", citdata["liveplace"]);
            player:SetSharedVar("work", citdata["work"])
            player:SetSharedVar("information", citdata["information"])
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

cable.receive('ChangeDataOfUnit', function(player, tbl)
    local type = tbl[1] 
    local str = tbl[2]
    local name = tbl[3]

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


cable.receive('AddChatMessage', function(player, data)
    table.insert(CP_PDA.CivilProtectionChat, {
        text = data[1],
        name = data[2],
        id = data[3]
    })
end);

cable.receive('RemoveChatMessage', function(player, id)
    CP_PDA.CivilProtectionChat[id] = nil;
end);

cable.receive('ChangePDAGlobalData', function(player, index, tbl)

    Schema.avaiblePDAs[index] = tbl;

end);

cable.receive('AddNewCombineLinePDA', function(player, name)

    local curTime = CurTime();
		
    if (!player.nextRequestTime || curTime >= player.nextRequestTime) then
        Schema:SayRequest(player, "!ГСР_ПДА: ЗАПРОС ПОМОЩИ.")
		Clockwork.chatBox:SendColored(player, "Ваш запрос доставлен юнитам ГО.")
    else
		Clockwork.player:Notify(player, "Вы не можете отправить запрос еще "..math.ceil(player.nextRequestTime - curTime).." секунд(ы)!");
	end;

end);

cable.receive('ChangeDataOfCitizen', function(player, tbl)
    
    local type = tbl[1]
    local callback = tbl[2]
    local name = tbl[3]

    local item = player:FindItemByID('cp_pda');
    if !item || (item:GetData('SettingsData')['blocked'] || Schema.avaiblePDAs[tonumber(item.itemID)][1]) then
        return;
    end;

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
    CP_PDA.CivilProtectionChat = Clockwork.kernel:RestoreSchemaData("plugins/pda_chat/"..game.GetMap());
end;

function PLUGIN:PostSaveData()
    Clockwork.kernel:SaveSchemaData("plugins/pda_info/"..game.GetMap(), Schema.avaiblePDAs);
    Clockwork.kernel:SaveSchemaData("plugins/pda_log/"..game.GetMap(), Schema.PDAlogs);
    Clockwork.kernel:SaveSchemaData("plugins/pda_chat/"..game.GetMap(), CP_PDA.CivilProtectionChat);
end;

function PLUGIN:ItemEntityDestroyed(itemEntity, itemTable) 
    if Schema.avaiblePDAs[itemTable.itemID] then
        Schema.avaiblePDAs[itemTable.itemID] = nil;
    end;
end;