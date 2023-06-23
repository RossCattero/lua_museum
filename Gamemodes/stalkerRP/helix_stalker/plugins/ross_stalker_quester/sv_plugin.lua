local PLUGIN = PLUGIN;
local ply = FindMetaTable("Player")

netstream.Hook('PlayerQuest_setting', function(player, quest, option)
    if option == "Принять" then
        if !player:HasQuest(quest.quid) then
            player:AddQuest(quest)
        end;
    elseif option == "Отклонить" then
        if player:HasQuest(quest.quid) then
            player:RemQuest(quest.quid)
        end;
    elseif option == "Завершить" then
        if player:HasQuest(quest.quid) && player:CanFinishQuest(quest.quid) then
            player:GiveReward(quest.quid)
            player:RemQuest(quest.quid)
        end;
    end;
end);

netstream.Hook('EditAnwsers', function(player, tbl)
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
    local newdata = ix.data.Get("TalkerMessages")
    newdata[id] = values;

    ix.data.Set("TalkerMessages", newdata)
end);

netstream.Hook('EditEntityTalker', function(player, entity, settings)
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
            ix.data.Get("TalkerMessages")[seller.identificator] = ix.data.Get("TalkerMessages")[entity.identificator];
            for a, b in pairs(entity.bodygroups) do
                seller:SetBodygroup(a, b)
            end;
            seller:Spawn();
            entity:Remove();
        end;
    end;
end);

function PLUGIN:InitializedPlugins()
    if !ix.data.Get("TalkerMessages") then
        ix.data.Set("TalkerMessages", {})
    end;
end;

function PLUGIN:OnNPCKilled(entity, attacker, inflictor) 
    if attacker:IsPlayer() && entity:IsNPC() then
        local char = attacker:GetCharacter();
        local info = char:GetData('NPC_task_list', {})

        for k, v in pairs(info) do
            if info[k][entity:GetClass()] then
                if !info[k][entity:GetClass()] then info[entity:GetClass()] = 0 end;
                info[k][entity:GetClass()] = info[k][entity:GetClass()] + 1
            end;

            attacker:SetLocalVar("NPC_task_list", info)
        end;
    end;
end;

function PLUGIN:SaveData()
    local data = {}

    for _, entity in ipairs(ents.FindByClass("talker_npc")) do
        for a, b in pairs(entity:GetBodyGroups()) do
            entity.bodygroups[b.id] = entity:GetBodygroup(b.id)
        end
        data[#data + 1] = {
            pos = entity:GetPos(),
            angles = entity:GetAngles(),
            model = entity:GetModel(),
            id = entity.identificator,
            information = entity.sellerInformation,
            bodygroups = entity.bodygroups
        }
    end
    self:SetData(data)
end

function PLUGIN:LoadData()
    for _, v in ipairs(self:GetData() or {}) do
        local entity = ents.Create("talker_npc");      
        entity:SetAngles(v.angles);
        entity:SetModel(v.model);
        entity:SetPos(v.pos);
        entity.bodygroups = v.bodygroups;
        entity.identificator = v.id;
        entity.sellerInformation = v.information
        entity:SetAllowSell(v.information['allowtosell'])
        entity:SetDefaultName( v.information['name'] )
        entity:Spawn();
        for a, b in pairs(v.bodygroups) do
            entity:SetBodygroup(a, b)
        end
    end
end

function PLUGIN:OnCharacterCreated(client, character)
    character:SetData("QuestList", {})

    character:SetData("NPC_task_list", {})
end

function PLUGIN:PlayerLoadedCharacter(client, character)
    timer.Simple(0.25, function()
        client:SetLocalVar("QuestList", character:GetData("QuestList", {}))
        client:SetLocalVar("NPC_task_list", character:GetData("NPC_task_list", {}))
    end)
end

function PLUGIN:CharacterPreSave(character)
    local client = character:GetPlayer()
    if (IsValid(client)) then
        character:SetData("QuestList", client:GetLocalVar("QuestList", {}))
        character:SetData("NPC_task_list", client:GetLocalVar("NPC_task_list", {}))
    end
end

function ply:AddQuest(infotbl)
    local char = self:GetCharacter();

    if !self:HasQuest(infotbl.quid) then
        char:GetData('QuestList')[infotbl.quid] = { 
            vendorName = infotbl["vendorName"],
            type = infotbl["type"],
            needToDo = infotbl["needToDo"],
            rewardToGet = infotbl["rewardToGet"],
            randomize = infotbl["randomize"],
            rewardTokens = infotbl["rewardTokens"]
        }
        self:SetLocalVar('QuestList', char:GetData('QuestList'))

        if infotbl.type == "Истребление мутантов" then
            char:GetData('NPC_task_list')[infotbl.quid] = {};
            for k, v in pairs(infotbl.needToDo) do
                char:GetData('NPC_task_list')[infotbl.quid][k] = 0;
            end;
            self:SetLocalVar('NPC_task_list', char:GetData('NPC_task_list'))
        end;
    end;
end;
function ply:RemQuest(id)
    local char = self:GetCharacter();
    if self:HasQuest(id) then
        local questTable = self:GetLocalVar("QuestList", {})

        if questTable[id].type == "Истребление мутантов" && self:GetLocalVar("NPC_task_list", {})[ id ] then
            char:GetData('NPC_task_list')[id] = nil
            self:SetLocalVar("NPC_task_list", char:GetData('NPC_task_list'))
        end;

        char:GetData('QuestList')[id] = nil
        self:SetLocalVar('QuestList', char:GetData('QuestList'))
    end;
end;
function ply:HasQuest(id)
    local char = self:GetCharacter();
    return tobool(char:GetData('QuestList')[id])
end;

function ply:CanFinishQuest(id)
    local questTable = self:GetLocalVar("QuestList", {})
    if !questTable[id] then return false end;
    local task = questTable[id]
    local char = self:GetCharacter();
    local inv = char:GetInventory();
    local invList = inv:GetItems()

    if task.type == "Истребление мутантов" then
        local npcs = self:GetLocalVar('NPC_task_list', {})

        for k, v in pairs(task["needToDo"]) do
            if npcs[id][k] < v then
                return false;
            end;
        end;

    else
        for k, v in pairs(task["needToDo"]) do
            if inv:GetItemCount(k) < v then
                return false;
            end;
        end;
    end;

    return true;
end;

function ply:GiveReward(id)
    if self:CanFinishQuest(id) && self:HasQuest(id) then
        local questTable = self:GetLocalVar("QuestList", {})
        if !questTable[id] then return false end;
        local task = questTable[id]
        local char = self:GetCharacter();
        local inv = char:GetInventory();
        local invList = inv:GetItems()

        if task.type != "Истребление мутантов" then
            for k, v in pairs(task["needToDo"]) do
                for i = 1, v do
                    char:RemoveCarry(inv:HasItem(k))
                    inv:Remove(inv:HasItem(k).id)
                end;
            end;
        end;

        for k, v in pairs(task['rewardToGet']) do 
            inv:Add(k, v)
        end;
        char:GiveMoney(task["rewardTokens"])
    end;
end;