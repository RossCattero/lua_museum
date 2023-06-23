
local PLUGIN = PLUGIN;
local p = FindMetaTable( "Player" )

function PLUGIN:PlayerRestoreCharacterData(player, data)
	if ( !data["QuestTable"] ) then
		data["QuestTable"] = {};
    end;
end;

function PLUGIN:PlayerSaveCharacterData(player, data)
	if (data["QuestTable"]) then
		data["QuestTable"] = data["QuestTable"];
	else
	    data["QuestTable"] = {};
	end;
end;

function p:GetQuestTable()
    return self:GetCharacterData("QuestTable");
end;

function p:AddQuest(tbl)
    table.insert(self:GetQuestTable(), tbl);
    return;
end;

function PLUGIN:EntityHandleMenuOption(player, entity, option, arguments)
	local ec = entity:GetClass();

    if (ec == "ross_talking_npc" && arguments == "ross_talking_openwindow") then
        if table.Count(entity.entInfo["factionsAllowed"]) == 0 || entity.entInfo["factionsAllowed"][player:GetFaction()] == true then
            cable.send(player, 'TalkToMeNPC', entity.dialogueNPC, entity);
        end;
    end;
    if (ec == "ross_talking_npc" && arguments == "ross_talking_opensettings") then
        cable.send(player, 'SettingsNPCTalker', entity.dialogueNPC, entity, entity.entInfo);
    end;
    if (ec == "ross_talking_npc" && arguments == "ross_talking_openSell") then
        local inventory = {}
        if !entity.reconizedCharacters[player:Name()] then
            entity.reconizedCharacters[player:Name()] = 0;
        end;

        for k, v in ipairs(Clockwork.inventory:GetAsItemsList(player:GetInventory())) do
            if !v:GetData("Used") then
                table.insert(inventory, {
                    uniqueID = v.uniqueID,
                    name = v.name,
                    model = v.model,
                    skin = v.skin,
                    itemID = v.itemID,
                    priceSales = v:GetData("PriceForSalesman") or 0
                })
            end;
        end;

        cable.send(player, 'SellItemsTalkerNPC', inventory, entity, entity.reconizedCharacters[player:Name()]);
    end;

    if (ec == "ross_talking_npc" && arguments == "ross_talking_openBuy") then
        if !entity.reconizedCharacters[player:Name()] then
            entity.reconizedCharacters[player:Name()] = 0;
        end;
        cable.send(player, 'BuyItemsLoyality', entity, entity.ItemsInStock, entity.reconizedCharacters);
    end;

    if (ec == "ross_talking_npc" && arguments == "ross_talking_openBuySett") then
        cable.send(player, 'BuyItemsLoyality', entity, entity.ItemsInStock);
    end;

end;

cable.receive('QuestAddPlayer', function(player, questTable)

    player:AddQuest(questTable)
    PrintTable(player:GetQuestTable())
    
end);

cable.receive('SaveDialogueInformation', function(player, dialogues, entity, eInfo)

    if IsValid(entity) && entity:GetClass() == "ross_talking_npc" then
        entity.dialogueNPC = dialogues;
        entity.entInfo = eInfo;
    end;
end);

cable.receive('SellItemToNPC', function(player, uniqueID, itemID, entity, reput)
    local item = player:FindItemByID(uniqueID, itemID)

    if item then
        player:TakeItemByID(uniqueID, itemID)
        entity.reconizedCharacters[player:Name()] = reput
    end;
end);