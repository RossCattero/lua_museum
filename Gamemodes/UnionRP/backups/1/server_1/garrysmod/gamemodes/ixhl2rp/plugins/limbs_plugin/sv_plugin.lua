local PLUGIN = PLUGIN;

limbslist = {
    ['head'] = {
        name = 'Голова',
        health = 100
    },
    ['body'] = {
        name = 'Тело',
        health = 100
    },
    ['rightarm'] = {
        name = 'Правая рука',
        health = 100
    },
    ['leftarm'] = {
        name = 'Левая рука',
        health = 100
    },
    ['leftleg'] = {
        name = 'Левая нога',
        health = 100
    },
    ['rightleg'] = {
        name = 'Правая нога',
        health = 100
    }
}

slots = {
    ['legs'] = "",
    ['body'] = "",
    ['hands'] = "",
    ['head'] = "",
    ['gasmask'] = "",
    ['kneepads'] = "",
    ['elbowpads'] = "",
    ['steto'] = "",
    ['tools'] = "",
    ['gear'] = ""
}

function PLUGIN:CharacterPreSave(character)
    local client = character:GetPlayer()

    if (IsValid(client)) then
        character:SetData("limbs", client:GetLocalVar("limbs", limbslist))
        character:SetData("ClothesUps", client:GetLocalVar("ClothesUps", slots))
    end
end

function PLUGIN:PlayerLoadedCharacter(client, character)
    timer.Simple(0.25, function()
        if !character:GetData("ClothesUps") then
            character:SetData("ClothesUps", slots)
        end;
        client:SetLocalVar("limbs", character:GetData("limbs", limbslist))
        client:SetLocalVar("ClothesUps", character:GetData("ClothesUps", slots))
    end)
end

function PLUGIN:ScalePlayerDamage( victim, hitgroup, damage )
    local attacker = damage:GetAttacker();

    -- if IsValid(victim) && victim:Alive() && IsValid(attacker) then
    --     local char = victim:GetCharacter();
    --     local pos, angle = attacker:GetShootPos(), attacker:GetAimVector()
    --     local tracedata = {start = pos, endpos = pos+(angle*1024), filter = attacker}
    --     local trace = util.TraceLine(tracedata)
    --     local bone = GetHitGroupBone(trace, victim);
    --     local limbs = char:GetData('limbs');
    --     local damage = damage:GetDamage();

    --     if bone == 1 then
    --         limbs['head']['health'] = math.Clamp(limbs['head']['health'] - damage, 0, limbs['head']['health'])
    --     elseif bone == 2 then
    --         limbs['body']['health'] = math.Clamp(limbs['body']['health'] - damage, 0, limbs['body']['health'])
    --     elseif bone == 4 then
    --         limbs['rightarm']['health'] = math.Clamp(limbs['rightarm']['health'] - damage, 0, limbs['rightarm']['health'])
    --         limbs['leftarm']['health'] = math.Clamp(limbs['leftarm']['health'] - damage, 0, limbs['leftarm']['health'])
    --     elseif bone == 6 then
    --         limbs['rightleg']['health'] = math.Clamp(limbs['rightleg']['health'] - damage, 0, limbs['rightleg']['health'])
    --         limbs['leftleg']['health'] = math.Clamp(limbs['leftleg']['health'] - damage, 0, limbs['leftleg']['health'])
    --     end;
        
    --     char:SetData('limbs', character:GetData('limbs'))
    --     victim:SetLocalVar('limbs', character:GetData('limbs'))
    -- end;

end;

-- function PLUGIN:PlayerSpawn(client)
--     local char = client:GetCharacter();

--     if char then
--         char:SetData('limbs', limbslist)
--         client:SetLocalVar('limbs', char:GetData('limbs'));
--     end;
-- end;

netstream.Hook("TakeDownClothes", function(ply, uniqueID)
    local character = ply:GetCharacter()
    local data = character:GetData('ClothesUps');
    local cloth = data[uniqueID]

    if cloth then
        local itemlist = ix.item.list;
        
        for k, _ in pairs(itemlist[cloth].bodyGroups or {}) do
                local index = ply:FindBodygroupByName(k)
        
            if (index > -1) then
                ply:SetBodygroup(index, 0)
        
                local groups = character:GetData("groups", {})
                if (groups[index]) then
                    groups[index] = nil
                    character:SetData("groups", groups)
                end
            end
        end
        if (character:GetData("oldGroups" .. itemlist[cloth].outfitCategory)) then
            for k, v in pairs(character:GetData("oldGroups" .. itemlist[cloth].outfitCategory, {})) do
                ply:SetBodygroup(k, v)
            end
        
            character:SetData("groups", character:GetData("oldGroups" .. itemlist[cloth].outfitCategory, {}))
            character:GetData("oldGroups" .. itemlist[cloth].outfitCategory, nil)
        end

        local inv = character:GetInventory()

        inv:Add(cloth)

        character:GetData('ClothesUps')[uniqueID] = "";
        character:SetData('ClothesUps', character:GetData('ClothesUps'))
        ply:SetLocalVar('ClothesUps', character:GetData('ClothesUps'))
    end;
end)