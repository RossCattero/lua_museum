
local PLUGIN = PLUGIN;

RossTalkers.talktable = {};
RossTalkers.questsTable = {};

function PLUGIN:PlayerSaveCharacterData(player, data)
    if data['NPCskilled'] then
        data["NPCskilled"] = data["NPCskilled"];

    elseif !data['NPCskilled'] then
        data['NPCskilled'] = {};
        
    end;
end;

function PLUGIN:PlayerRestoreCharacterData(player, data)
    if !data["NPCskilled"] then
        data["NPCskilled"] = {};
    end;
end;

function PLUGIN:OnNPCKilled(entity, attacker, inflictor) 
    if attacker:IsPlayer() then
        local sid = attacker:SteamID() local name = attacker:GetName()
        if HasQuestTypeByID(RossTalkers.questsTable[ sid ][ name ], 'Убийство НПС') then
            local info = attacker:GetCharacterData('NPCskilled', {});
            if !info[entity:GetClass()] then info[entity:GetClass()] = 0 end;
            info[entity:GetClass()] = info[entity:GetClass()] + 1
        end;
    end;
end;

function PLUGIN:EntityHandleMenuOption(player, entity, option, arguments)
    local class = entity:GetClass(); 
    local Pfaction = player:GetFaction();

    if (class == "talker_npc") then
        local factionallowed = entity.sellerInformation['factionsAllowed'];
        local allowed = (table.Count(factionallowed) == 0 || factionallowed[Pfaction] == true);
        local inventory = {};
        local inv = player:GetInventory();
        local steamid = player:SteamID();
        local name = player:Name()
        local npc = player:GetCharacterData('NPCskilled');
        if ( arguments == "talker_npc_talk" ) then
            if allowed then
                cable.send( player, 'OpenTalkerTalking', RossTalkers.talktable, entity.identificator, entity.sellerInformation, RossTalkers.questsTable[ steamid ][ name ], npc );
            else
                Clockwork.chatBox:SendColored(player, Color(255, 100, 100), tostring(entity.sellerInformation["disallow"]) )
            end;
        elseif (arguments == 'talker_npc_settings' && (player:IsAdmin() || player:IsSuperAdmin())) then
            cable.send( player, 'OpenTalkerSettings', RossTalkers.talktable, entity.identificator, entity.sellerInformation, entity );
        elseif (arguments == 'talker_npc_vendor') then
           if allowed && entity.sellerInformation['allowtosell'] then 
                for k, v in ipairs( Clockwork.inventory:GetAsItemsList(inv) ) do
                    if !v:GetData("Used") then
                        table.insert(inventory, {
                            uniqueID = v.uniqueID,
                            name = v.name,
                            model = v.model,
                            skin = v.skin,
                            itemID = v.itemID,
                            priceSales = v:GetData("PriceForSalesman") || 0,
                            quality = v:GetData("Quality")
                        })
                    
                    end;
                end; 
                cable.send( player, 'OpenTalkerVendor', inventory, entity.sellerInventory, entity, entity.sellerInformation );
            else
                Clockwork.chatBox:SendColored(player, Color(255, 100, 100), tostring(entity.sellerInformation["disallow"]) )
            end;
        end;
	end;
end;

function PLUGIN:PlayerCharacterInitialized(player)
    if !RossTalkers.questsTable[ player:SteamID() ] then
        RossTalkers.questsTable[ player:SteamID() ] = {
            [player:Name()] = {};
        }
    elseif RossTalkers.questsTable[ player:SteamID() ] then
        if !RossTalkers.questsTable[ player:SteamID() ][player:Name()] then
            RossTalkers.questsTable[ player:SteamID() ][player:Name()] = {}
        end;
    end;
end;

function PLUGIN:PlayerDeleteCharacter(player, character) 
    if RossTalkers.questsTable[ player:SteamID() ][character.name] then
        RossTalkers.questsTable[ player:SteamID() ][character.name] = nil;
    end;
end;

-- Called when Clockwork has loaded all of the entities.
function PLUGIN:ClockworkInitPostEntity()
    self:LoadTalkerNPC();
    RossTalkers.talktable = Clockwork.kernel:RestoreSchemaData("plugins/talker_npc/talkertable");
    RossTalkers.questsTable = Clockwork.kernel:RestoreSchemaData("plugins/talker_npc/questsTable");
end;

-- Called just after data should be saved.
function PLUGIN:PostSaveData()
    self:SaveTalkerNPC();
    Clockwork.kernel:SaveSchemaData("plugins/talker_npc/talkertable", RossTalkers.talktable);
    Clockwork.kernel:SaveSchemaData("plugins/talker_npc/questsTable", RossTalkers.questsTable);
end;

function PLUGIN:SaveTalkerNPC()
    local talker = {}
    for k, v in pairs(ents.FindByClass("talker_npc")) do
        local mdl = v:GetModel();
        local ang = v:GetAngles();
        local pos = v:GetPos();
        local idti = v.identificator;
        local inventory = v.sellerInventory;
        local SellInfo = v.sellerInformation
        for a, b in pairs(v:GetBodyGroups()) do
            v.bodygroups[b.id] = v:GetBodygroup(b.id)
        end
        table.insert(talker, {
            angles = ang, position = pos, model = mdl, idit = idti, inv = inventory, sinfo = SellInfo, bodygroups = v.bodygroups
        });
    end;
    Clockwork.kernel:SaveSchemaData("plugins/talker_npc/"..game.GetMap(), talker);
end;
    
function PLUGIN:LoadTalkerNPC()
    local talker = Clockwork.kernel:RestoreSchemaData("plugins/talker_npc/"..game.GetMap());
    for k, v in pairs(talker) do
        local entity = ents.Create("talker_npc");      
        entity:SetAngles(v.angles);
        entity:SetModel(v.model);
        entity:SetPos(v.position);
        entity.bodygroups = v.bodygroups;
        entity.identificator = v.idit;
        entity.sellerInventory = v.inv;
        entity.sellerInformation = v.sinfo
        entity:SetAllowSell(v.sinfo['allowtosell'])
        entity:Spawn();
        for a, b in pairs(v.bodygroups) do
            entity:SetBodygroup(a, b)
        end
    end;
end;

cable.receive('EditEntityTalker', function(player, entity, settings)
    if !player:IsAdmin() || !player:IsSuperAdmin() then
        return;
    end;
    if entity then
        entity.sellerInformation = settings;
        if entity:GetModel() != settings['model'] then
            entity:SetModel(settings['model'])
        end;
        if entity:GetAllowSell() != tobool(settings['allowtosell']) then
            entity:SetAllowSell(tobool(settings['allowtosell']))
        end;
        if entity:GetDefaultName() != settings['name'] then
            entity:SetDefaultName(settings['name'])
        end;
        for a, b in pairs(entity:GetBodyGroups()) do
            entity.bodygroups[b.id] = entity:GetBodygroup(b.id)
        end
        for a, b in pairs(entity.bodygroups) do
            entity:SetBodygroup(a, b)
        end
        if entity:GetSequence() != tonumber(settings['sequence']) then
            local seller = ents.Create("talker_npc");
            seller:SetAngles(entity:GetAngles());
            seller:SetModel(entity:GetModel());
            seller:SetPos(entity:GetPos());
            seller.bodygroups = entity.bodygroups;
            seller.sellerInventory = entity.sellerInventory;
            seller.sellerInformation = entity.sellerInformation;
            seller:ResetSequence( tonumber(entity.sellerInformation['sequence']) );
            if !seller.identificator then
                seller.identificator = os.time() + math.random(1, 15);
            end;
            RossTalkers.talktable[seller.identificator] = RossTalkers.talktable[entity.identificator];
            for a, b in pairs(entity.bodygroups) do
                seller:SetBodygroup(a, b)
            end;
            seller:Spawn();
            entity:Remove();
        end;
    end;
end);

cable.receive('EditAnwsers', function(player, tbl)
    if !player:IsAdmin() || !player:IsSuperAdmin() then
        return;
    end;
    local id = tbl[1];
    local values = tbl[2];
    for k, v in pairs(values) do
        if v.isAnwser && v.quest && !v.quest.quid then
            v.quest.quid = os.time() + math.random(10)
        end;
    end;
    RossTalkers.talktable[id] = values;
end);

cable.receive('MIE', function(player, entity, tbl)
    local uniqueID = tbl[1]; local itemID = tbl[2]; local price = tbl[3]; local key = tbl[4]; local type = tbl[5];
    if type == 'player' then
        if player:HasItemByID(uniqueID, itemID) && entity.sellerInformation['allowsell'] then
            local item = player:FindItemByID(uniqueID, itemID);
            table.insert(entity.sellerInventory, {
                uniqueID = uniqueID,
                name = item.name,
                model = item.model,
                skin = item.skin,
                itemID = itemID,
                priceSales = item:GetData("PriceForSalesman") * 1.3,
                defaultPrice = item:GetData("PriceForSalesman") * 1.3,
                quality = item:GetData("Quality") or nil;
            });
            Clockwork.player:GiveCash(player, price, "Продажа предмета", false);
            player:TakeItem(item);
        end;
    elseif type == 'entity' then
        if entity:HasItemInInv(uniqueID, itemID) && player:GetCash() >= price && entity.sellerInformation['allowbuy'] then
            entity:TakeItemFromInv(uniqueID, itemID)
            player:GiveItem(Clockwork.item:CreateInstance(uniqueID, itemID), true);
            Clockwork.player:GiveCash(player, -price, "Покупка предмета", false);
        end;
    end;
end);

function IsValidQuest(questtable, id, vname)
    for uid, inside in pairs(RossTalkers.talktable[id]) do
        if inside.isAnwser && inside.quest && inside.quest.vendorName == vname && inside.quest.quid == questtable.quid then
            return true;
        end;
    end;
    return false;
end;

cable.receive('AcceptQuest', function(player, questtable, tbl1)
    local sid = player:SteamID(); local name = player:Name();
    local id = tbl1[1]; local vname = tbl1[2]
    if IsValidQuest(questtable, id, vname) && !HasQuestByID(vname, RossTalkers.questsTable[ sid ][ name ]) then
        if table.Count(questtable.needToDo) > 1 && questtable.randomize then
            for k, v in pairs(questtable.needToDo) do
                if math.random(100) > 75 && table.Count(questtable.needToDo) > 1 then
                    questtable.needToDo[k] = nil;
                end;
            end;
        end;
        table.insert(RossTalkers.questsTable[ sid ][ name ], questtable);
    end;
end);

cable.receive('DeclineQuest', function(player, questtable, tbl1)
    local sid = player:SteamID(); local name = player:Name();
    local id = tbl1[1]; local vname = tbl1[2]
    if IsValidQuest(questtable, id, vname) && HasQuestByID(vname, RossTalkers.questsTable[ sid ][ name ]) then
        for k, v in pairs(RossTalkers.questsTable[ sid ][ name ]) do
            if v.vendorName == vname then
                RossTalkers.questsTable[ sid ][ name ][k] = nil;
            end;
        end;
    end;
end);

cable.receive('FinishQuest', function(player, questtable, tbl1)
    local sid = player:SteamID(); local name = player:Name();
    local id = tbl1[1]; local vname = tbl1[2];
    local vq = IsValidQuest(questtable, id, vname);
    local hq = HasQuestByID(vname, RossTalkers.questsTable[ sid ][ name ])
    local npc = player:GetCharacterData('NPCskilled');
    local function PLAYER_Cantakequest( type, inventory, sellerquests, npcs )
        local littlebuffer = {};
        if type == 'Собирательство' then
            for k, v in pairs(sellerquests) do
                if player:HasItemCountByID(k, v) then
                    table.insert(littlebuffer, true)
                elseif !player:HasItemCountByID(k, v) then
                    table.insert(littlebuffer, false)
                end;
            end;
        elseif type == 'Убийство НПС' && npcs then
            for k, v in pairs(sellerquests) do
                if npcs[k] == sellerquests[k] then
                    table.insert(littlebuffer, true)
                elseif npcs[k] != sellerquests[k] then
                    table.insert(littlebuffer, false)
                end;
            end;
        end;

        if !table.HasValue(littlebuffer, false) && table.Count(littlebuffer) != 0 then return true end;
        return false;
    end;
    if vq && hq && PLAYER_Cantakequest( questtable['type'], player:GetInventory(), questtable['needToDo'], npc ) then
        if questtable['type'] == 'Собирательство' then
            for k, v in pairs(questtable['needToDo']) do
                if player:HasItemCountByID(k, v) then
                    for i = 1, v do
                        player:TakeItemByID(k)
                    end;
                elseif !player:HasItemCountByID(k, v) then
                    return;
                end;
            end;
        elseif questtable['type'] == 'Убийство НПС' then
            player:SetCharacterData('NPCskilled', {})
        end;

        if questtable['rewardToGet'] then
            for k, v in pairs(questtable['rewardToGet']) do 
                for i = 1, v do
                    player:GiveItem(Clockwork.item:CreateInstance(k))
                end;
            end;
        end;
        Clockwork.player:GiveCash(player, questtable.rewardTokens, "Выполнение квеста", false);

        for k, v in pairs(RossTalkers.questsTable[ sid ][ name ]) do
            if v.vendorName == vname then
                RossTalkers.questsTable[ sid ][ name ][k] = nil;
            end;
        end;
    end;
end);