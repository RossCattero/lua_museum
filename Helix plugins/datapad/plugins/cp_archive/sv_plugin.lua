function PLUGIN:LoadData()
    -- load all the data on server startup;
    ix.archive.Load()
    
    -- Load log file
    ix.archive.logs.Load()
end;

function PLUGIN:SaveData()
    -- save all data on server data save hook;
    ix.archive.Save()
end;

-- When character is created;
function PLUGIN:OnCharacterCreated(client, character)
    local faction = character:GetFaction()

    -- register new civilian
    if ix.archive.civilians.IsCivilian(faction) then
        ix.archive.civilians.Register(character:GetID(), character:GetName())
    end;

    -- register new cca member
    if ix.archive.police.IsCombine(faction) then
        ix.archive.police.Register(character:GetID(), character:GetName(), ix.ranks.default)
    end;
end;

-- Right before the character deleted;
function PLUGIN:PreCharacterDeleted(client, character)
    -- index
    local faction = character:GetFaction()

    -- check if character in civils list and delete him too
    if ix.archive.civilians.IsCivilian(faction) then
        ix.archive.civilians.Delete(character.id)
    end;

    -- check if character in police list and delete him too
    if ix.archive.police.IsCombine(faction) then
        ix.archive.police.Delete(character.id)
    end;
end;

-- On character load;
function PLUGIN:PlayerLoadedCharacter(client, character, currentChar)
    timer.Simple(0, function()
        local id = character:GetID();
        local data = ix.archive.Get(id);

        -- To synchronize previous CIDs if it's present.
        if character:GetData("cid") then
            data:SetCID(character:GetData("cid"))
        end;

        -- Set personal local data in buffer to check rank, etc. on local player.
        if ix.archive.Get(id) then
            client:SetLocalVar("_persona", data)
        end;
    end)
end;