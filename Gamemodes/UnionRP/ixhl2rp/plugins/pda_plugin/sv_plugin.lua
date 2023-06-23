local PLUGIN = PLUGIN;

Schema.pdaData = Schema.pdaData or {}
Schema.chatList = Schema.chatList or {}

function PLUGIN:InitializedPlugins()
    if !ix.data.Get("DataInformation") then
        ix.data.Set("DataInformation", {})
    end;

    if !ix.data.Get("PDAChat") then
        ix.data.Set("PDAChat", {})
    end;
end;

function PLUGIN:LoadData()
	Schema.pdaData = ix.data.Get("DataInformation");
end

function PLUGIN:CharacterLoaded(character)
    if character then
        
        if !character:GetData('PDAID') && !Schema.pdaData[character:GetData('PDAID')] && !character:IsCombine() then
            character:SetData('PDAID', Schema:ZeroNumber(math.random(1, 999999), 6));
            character:GetPlayer():SetLocalVar('PDAID', character:GetData('PDAID'))

            Schema.pdaData[character:GetData('PDAID')] = {
                name = character:GetName(),
                class = 'ГАММА',
                authorized = false,
                cardID = 0,
                warned = false,
                lastseen = 'none',
                logs = {}
            }

            ix.data.Set("DataInformation", Schema.pdaData)
        end;
    end;
    
end

function PLUGIN:CharacterPreSave(character)
    local client = character:GetPlayer()

    if (IsValid(client)) then
        character:SetData("PDAID", client:GetLocalVar("PDAID"))
    end
end

function PLUGIN:PlayerLoadedCharacter(client, character)
    timer.Simple(0.25, function()
        client:SetLocalVar("PDAID", character:GetData("PDAID"))
    end)
end

netstream.Hook('ChatboxMessageAdd', function(ply, name, time, text)

    if !ply:GetCharacter():GetInventory():HasItem('pda') then

        return;
    end;

    if ply:GetName() != name then

        return;
    end;

    Schema.chatList[#Schema.chatList + 1] = {
        name = name,
        time = time,
        message = text
    }
    ix.data.Set("PDAChat", Schema.chatList)
    
    for k, v in pairs(player.GetAll()) do
        netstream.Start(v, 'SyncMessageOnClient', name, time, text)
    end;
end)

netstream.Hook('LogCharacterADD', function(ply, id, name, time, type, text)

    if !ply:GetCharacter():GetInventory():HasItem('pda') then

        return;
    end;

    Schema.pdaData[id].logs[#Schema.pdaData[id].logs + 1] = {
        text = text,
        time = time,
        type = type
    }

    ix.data.Set("DataInformation", Schema.pdaData)
    
    for k, v in pairs(player.GetAll()) do
        netstream.Start(v, 'SyncLogFileOnClients', id, time, type, text)
    end;
end)

netstream.Hook('PDA_MakeSomeNoise', function(ply, id, type, what)

    if !ply:GetCharacter():GetInventory():HasItem('pda') then

        return;
    end;

    if type == 'class' then
        Schema.pdaData[id].class = what
    elseif type == 'authorize' then
        if what then
            Schema.pdaData[id].authorized = 'Да'
        else
            Schema.pdaData[id].authorized = 'Нет'
        end;
    elseif type == 'warned' then
        if what then
            Schema.pdaData[id].warned = 'Да'
        else
            Schema.pdaData[id].warned = 'Нет'
        end;
    elseif type == 'last' then    
        Schema.pdaData[id].lastseen = what
    end;

    ix.data.Set("DataInformation", Schema.pdaData)
end)