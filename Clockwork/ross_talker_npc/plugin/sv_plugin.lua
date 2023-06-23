
local PLUGIN = PLUGIN;
local p = FindMetaTable( "Player" )

function PLUGIN:PlayerRestoreCharacterData(player, data)
	if ( !data["QuestTable"] ) then
		data["QuestTable"] = {};
    end;
    if ( !data["NPCsKilled"] ) then
		data["NPCsKilled"] = {};
    end;
    if ( !data["renown"] ) then
		data["renown"] = 0;
    end;
end;

function PLUGIN:PlayerSaveCharacterData(player, data)
	if (data["QuestTable"]) then
		data["QuestTable"] = data["QuestTable"];
	else
	    data["QuestTable"] = {};
    end;
    if (data["NPCsKilled"]) then
		data["NPCsKilled"] = data["NPCsKilled"];
	else
	    data["NPCsKilled"] = {};
    end;
end;

function p:GetQuestTable()
    return self:GetCharacterData("QuestTable");
end;

function p:AddQuest(tbl)
    table.insert(self:GetQuestTable(), tbl);
end;

function p:GetNPCTable()
    return self:GetCharacterData("NPCsKilled")
end;

function PLUGIN:OnNPCKilled(npc, player, weapon) 

    if player:IsPlayer() then
        local npcs = player:GetNPCTable()
        local pValid = player:IsValid();
        local alive = player:Alive()
        if pValid && alive then
            for k, v in pairs(player:GetQuestTable()) do
                if v.type == "Убийство НПС" then

                    if npcs[npc:GetClass()] != v.amount[npc:GetClass()] then
                        if !npcs[npc:GetClass()] && v.amount[npc:GetClass()] then
                            npcs[npc:GetClass()] = 1
                        else
                            npcs[npc:GetClass()] = npcs[npc:GetClass()] + 1
                        end;
                    end;

                end;
            end;
        end;
    end;

end;

function PLUGIN:EntityHandleMenuOption(player, entity, option, arguments)
	local ec = entity:GetClass();

    if (ec == "ross_talking_npc" && arguments == "ross_talking_openwindow") then
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

        if table.Count(entity.entInfo["factionsAllowed"]) == 0 || entity.entInfo["factionsAllowed"][player:GetFaction()] == true then
            cable.send(player, 'TalkToMeNPC', entity.dialogueNPC, entity, entity.sellerData, player:GetQuestTable(), player:GetCharacterData("renown"), inventory, player:GetNPCTable());
        elseif !entity.entInfo["factionsAllowed"][player:GetFaction()] then
            Clockwork.chatBox:SendColored(player, Color(255, 100, 100), tostring(entity.entInfo["TalkOnNear"][1]))
        end;
    end;
    if (ec == "ross_talking_npc" && arguments == "ross_talker_cwu_give") then
        if table.Count(entity.CwuInventory) > 0 then

            local number = entity.CwuInventory[table.Count(entity.CwuInventory)]
            player:GiveItem( Clockwork.item:CreateInstance( number["additionalInfo"]["uniqueID"], number["additionalInfo"]["itemID"], {
                NotepadTableForMe = {
                    title = number["title"],
                    owner = number["owner"],
                    pickup = number["pickup"],
                    information = number["information"],
                    pages = number["pages"],
                    additionalInfo = number["additionalInfo"]
                }
            }), true );
            Clockwork.chatBox:SendColored(player, Color(255, 100, 100), "Вы взяли у этого продавца бланк с названием "..cutDownText(tostring(number["title"]), 5)..".")
            entity.CwuInventory[table.Count(entity.CwuInventory)] = nil;

        elseif table.Count(entity.CwuInventory) == 0 then
            Clockwork.chatBox:SendColored(player, Color(255, 100, 100), "У этого продавца нет бланков.")
        end;
    end;
    if (ec == "ross_talking_npc" && arguments == "ross_talking_opensettings" && player:IsAdmin()) then
        cable.send(player, 'SettingsNPCTalker', entity.dialogueNPC, entity, entity.entInfo, entity.sellerData);
    end;
    if (ec == "ross_talking_npc" && arguments == "ross_t_barter_1" && player:IsAdmin()) then
        entity:SetIsDisabled( !entity:GetIsDisabled() )
    end;
    if (ec == "ross_talking_npc" && arguments == "ross_t_barter_2" && player:IsAdmin()) then
        entity:SetIsDDD( !entity:GetIsDDD() )
    end;
    if (ec == "ross_talking_npc" && arguments == "ross_talking_openSell" && !entity.sellerData["isCwu"]) then
        if !entity:GetIsDisabled() then
            local inventory = {};
            local infoD = {};
            if !entity.reconizedCharacters[player:Name()] then
                entity.reconizedCharacters[player:Name()] = 0;
            end;

            for k, v in ipairs(Clockwork.inventory:GetAsItemsList(player:GetInventory())) do
                if !v:GetData("Used") then
                    if v.category == "Оружие" then
                        infoD["WeaponQuality"] = v:GetData("Quality")
                    end;
                    table.insert(inventory, {
                        name = v.name,
                        uniqueID = v.uniqueID,
                        model = v.model,
                        skin = v.skin,
                        itemID = v.itemID,
                        priceSales = v:GetData("PriceForSalesman") * (1 + 1 * entity.reconizedCharacters[player:Name()]),
                        idata = infoD
                    })
                end;
            end;
            cable.send(player, 'SellItemsTalkerNPC', entity, inventory, entity.itemInventory);
        
        elseif entity:GetIsDisabled() then
            Clockwork.chatBox:SendColored(player, Color(255, 100, 100), tostring(entity.entInfo["TalkOnNear"][data[2]]))
        end;
    end;

    if (ec == "ross_talking_npc" && arguments == "ross_talking_openBuy" && !entity.sellerData["isCwu"]) then
        if !entity:GetIsDDD() then
            if !entity.reconizedCharacters[player:Name()] then
                entity.reconizedCharacters[player:Name()] = 0;
            end;

            cable.send(player, 'BuyItemsLoyality', entity, entity.ItemsInStock, player:GetCash());
        elseif entity:GetIsDDD() then
            Clockwork.chatBox:SendColored(player, Color(255, 100, 100), "Вы не можете получить доступ к этому продавцу!")
        end;
    end;

end;

cable.receive('QuestAddPlayer', function(player, questTable)
    player:AddQuest(questTable)
end);

cable.receive('RemoveQuest', function(player, ent, id)
    if !ent.reconizedCharacters[player:Name()] then
        ent.reconizedCharacters[player:Name()] = 0;
    end;

    ent.reconizedCharacters[player:Name()] = ent.reconizedCharacters[player:Name()] - math.random(1, 5 + player:GetQuestTable()[id]['reward']["reputation"] )
    if player:GetQuestTable()[id] && player:GetQuestTable()[id].type == "Убийство НПС" then
        for k, v in pairs(player:GetQuestTable()[id].amount) do
            player:GetNPCTable()[k] = nil
        end;
    end;
    player:GetQuestTable()[id] = nil;
end);

cable.receive('GiveReward', function(player, ent, id)
    ---
    local function contractIsDone(quest, inventory, npctbl)
		local tableCounter = {}

		if quest.type == "Сбор предметов" then

			for k, v in pairs(inventory) do
				if quest.amount[v.uniqueID] then
					if !tableCounter[v.uniqueID] then
						tableCounter[v.uniqueID] = 1
					else
						tableCounter[v.uniqueID] = tableCounter[v.uniqueID] + 1
					end;
				end;
			end;

		elseif quest.type == "Убийство НПС" then

			for k, v in pairs(npctbl) do
				tableCounter[k] = v;
			end;

		end;

		table.sort(tableCounter)
		table.sort(quest.amount)

		for k, v in pairs(quest.amount) do
			if !tableCounter[k] || tableCounter[k] < v then
				return false;
			end;
		end;

		if table.Compare( tableCounter, quest.amount ) then
			return true;
		end;

		return false;
    end;
    ---
    
    local playerInv = Clockwork.inventory:GetAsItemsList(player:GetInventory());
    local name = player:Name();
    local quest = player:GetQuestTable()[id];
    local npcsTable = player:GetNPCTable()

    if contractIsDone(quest, playerInv, npcsTable) && ent.reconizedCharacters[name] then
        if quest.type != "Убийство НПС" then
            for k, v in ipairs(playerInv) do
                if quest.amount[v.uniqueID] && player:HasItemCountByID(v.uniqueID, quest.amount[v.uniqueID]) then
                    for i = 1, quest.amount[v.uniqueID] do
                        player:TakeItemByID(v.uniqueID)
                    end;
                end;
            end;
        else
            for k, v in pairs(quest.amount) do
                npcsTable[k] = nil
            end;
        end;

        for k, v in pairs(quest.reward["Rewitems"]) do
            for i = 1, v do
                player:GiveItem(Clockwork.item:CreateInstance(k), true);
            end;
        end;

        ent.reconizedCharacters[name] = ent.reconizedCharacters[name] + quest['reward']["reputation"] + math.random(0, quest['reward']["reputation"])
        player:SetCharacterData("renown", math.Clamp(player:GetCharacterData("renown") + tonumber(quest.reward["loyality"]), 0, 10000))
        Clockwork.player:GiveCash(player, quest.reward["cash"], "Выполнение квеста", false);

        player:GetQuestTable()[id] = nil;
    end;
end);

cable.receive('SaveDialogueInformation', function(player, entity, data)

    if IsValid(entity) && entity:GetClass() == "ross_talking_npc" then
        entity.dialogueNPC = data[1];
        entity.entInfo = data[2];
        entity.sellerData["name"] = data[3]["name"];
        entity.sellerData["isCwu"] = data[3]["isCwu"];
        entity:SetInfoName(entity.sellerData["name"]);
        entity:SetIsCwu(entity.sellerData["isCwu"])
        entity:SetModel(data[2].sellerMdl);
        entity:SetSequence(data[2].sequence);
    end;
end);

cable.receive('SellItemToSeller', function(player, entity, data)
    local item = player:FindItemByID(data[1], data[2])
    local infoD = {};

    if item && player:HasItemByID(data[1]) && item:GetData("PriceForSalesman") == data[3] then
        if item.category == "Weapons" or item.category == "Оружие" then
            infoD["WeaponQuality"] = item:GetData("Quality")
        end;
        player:TakeItemByID(data[1], data[2])
        Clockwork.player:GiveCash(player, data[3], "Продажа предмета", false);
        table.insert(entity.itemInventory, {
            name = item.name,
            uniqueID = item.uniqueID,
            model = item.model,
            skin = item.skin,
            itemID = item.itemID,
            priceSales = item:GetData("PriceForSalesman") * (1 + 1 * entity.reconizedCharacters[player:Name()]) + 10,
            idata = infoD     
        });
    end;
end);

cable.receive('BuyItemNPCSeller', function(player, entity, data)
    local testItem = entity.itemInventory;
    local tokens = player:GetCash();
    
    if ((tokens - testItem[data[4]].priceSales) >= 0 && tokens > 0) && testItem[data[4]] then
        if player:CanHoldWeight(Clockwork.item:FindByID(data[1]).weight) then
            player:GiveItem( Clockwork.item:CreateInstance(data[1], data[2], {Quality = entity.itemInventory[data[4]]["idata"][1]}), true);
            entity.itemInventory[data[4]] = nil;
            Clockwork.player:GiveCash(player, -data[3], "Покупка предмета", false);
        end;
    end;

end);

cable.receive('GiveSalesItem', function(player, entity, data)
    local cash = player:GetCash();
    local tEd = entity.ItemsInStock[ data[1] ];
    local Ed = data[2];
    
    if (cash - Ed.price >= 0 && cash > 0) && tEd.count > 0 && (tEd.price == Ed.price) && (Ed.uniqueID == tEd.uniqueID) then
        if player:CanHoldWeight(Clockwork.item:FindByID(data[2].uniqueID).weight) then
            player:GiveItem(Clockwork.item:CreateInstance(data[2].uniqueID));
            Clockwork.player:GiveCash(player, -data[3]);

            entity.ItemsInStock[ data[1] ] = Ed;
        end;
    end;
end);

cable.receive('ManipulateItems', function(player, entity, data)

    if !player:IsAdmin() then
        Clockwork.kernel:PrintLog(LOGTYPE_URGENT, player:GetName().." попытался получить доступ к изменению вещей продавца.");
        return;
    end;
    entity.ItemsInStock[ data[1] ] = data[2]
end);

function PLUGIN:ClockworkInitPostEntity()
	self:LoadLockedSalesman();
end;

function PLUGIN:PostSaveData()
	self:SaveLockedSalesman();
end;

function PLUGIN:SaveLockedSalesman()
    local sm = {} 

    for k, v in pairs(ents.FindByClass("ross_talking_npc")) do
        local physicsObject = v:GetPhysicsObject();
        local bMoveable = nil;
        local model = v:GetModel();	
    
        if (v:IsMapEntity() and startPos) then
            model = nil;
        end;
                    
        if (IsValid(physicsObject)) then
            bMoveable = physicsObject:IsMoveable();
        end;

        for a, b in pairs(v:GetBodyGroups()) do
            v.bodygroups[b.id] = v:GetBodygroup(b.id)
        end
    
        sm[#sm + 1] = {
			angles = v:GetAngles(),
			position = v:GetPos(),
			model = v:GetModel(),
            isMoveable = bMoveable,
            dialogueNPC = v.dialogueNPC,
            itemInventory = v.itemInventory,
            sellerData = v.sellerData,
            entInfo = v.entInfo,
            ItemsInStock = v.ItemsInStock,
            reconizedCharacters = v.reconizedCharacters,
            CwuInventory = v.CwuInventory,
            bodygroups = v.bodygroups,
            SellingDisabled = v:GetIsDisabled(),
            FleeMarketDisabled = v:GetIsDDD()
        };
    end;
    Clockwork.kernel:SaveSchemaData("plugins/ross_talker/"..game.GetMap(), sm);
end;
    
function PLUGIN:LoadLockedSalesman()
        local sm = Clockwork.kernel:RestoreSchemaData("plugins/ross_talker/"..game.GetMap());
        
        self.sm = {};
        
        for k, v in pairs(sm) do
            if (!v.model) then
                local entity = ents.Create("ross_talking_npc");
                
                entity.dialogueNPC = v.dialogueNPC
                entity.sellerData = v.sellerData
                entity.entInfo = v.entInfo
                entity.ItemsInStock = v.ItemsInStock
                entity.reconizedCharacters = v.reconizedCharacters
                entity.CwuInventory = v.CwuInventory 
                entity.itemInventory = v.itemInventory
                entity.bodygroups = v.bodygroups
                entity:SetIsDisabled( v.SellingDisabled )
                entity:SetIsDDD( v.FleeMarketDisabled )

                 for a, b in pairs(v.bodygroups) do
                    entity:SetBodygroup(a, b)
                end

                if (IsValid(entity) and entity:IsMapEntity()) then
                    self.sm[entity] = entity;
                    
                    if (IsValid(entity:GetPhysicsObject())) then
                        if (!v.isMoveable) then
                            entity:GetPhysicsObject():EnableMotion(false);
                        else
                            entity:GetPhysicsObject():EnableMotion(true);
                        end;
                    end;
                    
                    if (v.angles) then
                        entity:SetAngles(v.angles);
                        entity:SetPos(v.position);
                    end;
                end;
            else
                local entity = ents.Create("ross_talking_npc");
                
                entity.dialogueNPC = v.dialogueNPC
                entity.sellerData = v.sellerData
                entity.entInfo = v.entInfo
                entity.ItemsInStock = v.ItemsInStock
                entity.reconizedCharacters = v.reconizedCharacters     
                entity.CwuInventory = v.CwuInventory 
                entity.itemInventory = v.itemInventory
                entity.bodygroups = v.bodygroups
                entity:SetIsDisabled( v.SellingDisabled )
                entity:SetIsDDD( v.FleeMarketDisabled )
                entity:SetAngles(v.angles);
                entity:SetModel(v.model);
                entity:SetPos(v.position);
                entity:Spawn();
                
                for a, b in pairs(v.bodygroups) do
                    entity:SetBodygroup(a, b)
                end
                
                if (IsValid(entity:GetPhysicsObject())) then
                    if (!v.isMoveable) then
                        entity:GetPhysicsObject():EnableMotion(false);
                    end;
                end;
                
                self.sm[entity] = entity;
            end;
        end;
end;