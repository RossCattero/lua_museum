local ply = FindMetaTable('Player')
function ply:GetFullStatInfo(stat)
    local char = self:GetCharacter()
    local returned = 0;
    for k, v in pairs(char:GetInventory():GetItems()) do
        if v.base == "base_outfit" && v:GetData('equip') then
            returned = returned + v:GetData('OutfitInfo')[stat]
        end;
    end;
    return returned
end;

local mutants = {
    ["models/jerry/mutants/stalker_anomaly_boar.mdl"] = {
        ["boar_leg"] = 90,
        ['boar_hide'] = 35
    }, -- Кабан
    ["models/jerry/mutants/stalker_anomaly_ca1.mdl"] = {
        ["thryoid_item"] = 50,
        ['cat_tail'] = 35
    }, -- Кот
    ["models/jerry/mutants/stalker_anomaly_ca2.mdl"] = {
        ["thryoid_item"] = 50,
        ['cat_tail'] = 35
    }, -- Кот
    ["models/jerry/mutants/stalker_anomaly_ca3.mdl"] = {
        ["thryoid_item"] = 50,
        ['cat_tail'] = 35
    }, -- Кот
    ["models/jerry/mutants/stalker_anomaly_flesh.mdl"] = {
        ['flesh_hide'] = 50,
        ['flesh_eye'] = 75
    }, -- Плоть
    ["models/jerry/mutants/stalker_anomaly_pseudodog.mdl"] = {
        ['psevdo_tail'] = 50,
        ['psevdog_hide'] = 75
    }, -- Псевдособака
    ["models/jerry/mutants/stalker_anomaly_rat.mdl"] = {
        ['tush_head'] = 90
    }, -- Тушкан
    ["models/wick/zombie/wick_zombie_citizen_fast.mdl"] = {
        ['izlom_hand'] = 50
    }, -- Зомби
    ["models/stalkertnb/kontroler1.mdl"] = {
        ['kontroler_brain'] = 10,
        ['hide_controler'] = 55,
        ['hand_controller'] = 65
    }, -- Контроллер
    ["models/stalkertnb/chimera1.mdl"] = {
        ['chimera_hide'] = 30,
        ['chimera_kogot'] = 55
    }, -- Химера
    ["models/stalkertnb/pseudogiant1.mdl"] = {
        ['psevdo_hide'] = 35,
        ['psevdo_hand'] = 50
    }, -- Псевдогигант
    ["models/wick/snork/wick_snork.mdl"] = {
        ['snork_leg'] = 75
    }, -- Снорк
    ["models/wick/krovo/krovosos_little.mdl"] = {
        ['krovo_tentacles'] = 50
    }, -- Молодой кровосися
    ["models/wick/krovo/wick_krovosos.mdl"] = {
        ['krovo_tentacles'] = 40
    }, -- Большой кровосися
    ["models/wick/dog/wick_blind_dog.mdl"] = {
        ['dog_tail'] = 75,
        ['dog_hide'] = 60
    }, -- Слепой пес
    ["models/jerry/mutants/stalker_anomaly_izlom.mdl"] = {
        ['zombie_hand'] = 75
    } -- Излом
}

function Schema:EntityTakeDamage(entity, damageInfo)
    local dt = damageInfo:GetDamageType()
    
    if entity:IsPlayer() && !damageInfo:IsFallDamage() then
        local protTable = entity:GetLocalVar('ProtectionTable')
        local char = entity:GetCharacter()
        if dt == DMG_ACID then
            damageInfo:ScaleDamage( math.Clamp(1.5 - protTable["Токсины"]/100, 0.1, 1) )
        end;
        if dt == DMG_DISSOLVE or dt == DMG_SHOCK then
            damageInfo:ScaleDamage( math.Clamp(1.5 - protTable["Электричество"]/100, 0.1, 1) )
        end;
        if dt == DMG_BURN then
            damageInfo:ScaleDamage( math.Clamp(1.5 - protTable["Температура"]/100, 0.1, 1) )
        end;
        if dt == DMG_SLASH then
            damageInfo:ScaleDamage( math.Clamp(1.5 - protTable["Порез"]/100, 0.1, 1) )
        end;
        if dt == DMG_CRUSH or dt == DMG_BULLET or dt == 4098 or dt == 536875010 or dt == DMG_BUCKSHOT or dt == DMG_SNIPER or dt == DMG_BLAST or dt == DMG_CLUB then
            damageInfo:ScaleDamage( math.Clamp(1.5 - protTable["Гашение урона"]/100 - char:GetAttribute('endurance')/100, 0.1, 1) )
        end;
        local randomReduce = math.random(1, 9)/100
        for k, v in pairs(char:GetInventory():GetItemsByBase("base_outfit")) do
            if v:GetData('equip') then
                local outfits = v:GetData('outfit_info');
                if outfits then
                    for name, value in pairs(outfits) do
                        outfits[name] = math.Clamp(outfits[name] - math.Round(damageInfo:GetDamage()/10 + randomReduce, 2), 0, 1000)
                    end;
                    v:SetData('outfit_info', outfits)
                end;
            end;
        end;
        for k, v in pairs(protTable) do
            protTable[k] =  math.Clamp(protTable[k] - math.Round(damageInfo:GetDamage()/10 + randomReduce, 2), 0, 1000)
        end;
        entity:SetLocalVar('ProtectionTable', protTable)
    end;
end;

function Schema:PlayerUse(ply, ent)

    local activeWeapon = ply:GetActiveWeapon()
    local aClass = activeWeapon:GetClass()    

    if ent:GetClass() == "prop_ragdoll" && !ent.CuttedDown && (aClass == "tfa_nmrih_cleaver" or aClass == "tfa_nmrih_kknife" or aClass == "tfa_nmrih_machete" or aClass == "tfa_ins2_kabar") && ply:Crouching() then
        if mutants[ent:GetModel()] then
            ply:ForceSequence('roofidle1', nil, 0, false)
            ply:SetAction("Срезаю часть мутанта...", 10)
			ply:DoStaredAction(ent, function()
                ent.CuttedDown = true;
                for k, v in pairs( mutants[ent:GetModel()] ) do
                    if math.random(100) < v then
                        ply:GetCharacter():GetInventory():Add(k);
                    end;
                end;
                ply:LeaveSequence()
            end, 10, function()
                ply:SetAction()
                ply:LeaveSequence()
            end, 128, function()
                return ply:Crouching() && (aClass == "tfa_nmrih_cleaver" or aClass == "tfa_nmrih_kknife" or aClass == "tfa_nmrih_machete" or aClass == "tfa_ins2_kabar")
            end)
        end;
    end;

end;

function Schema:PlayerPostThink( player )
    local char = player:GetCharacter()
    local plyArea = (ix.area.stored[player:GetArea()] or {});

    if !self.AreasThink or CurTime() >= self.AreasThink then
        self.AreasThink = CurTime() + 2;
        if char then
            local protTable = player:GetLocalVar('ProtectionTable')
            if plyArea && plyArea.type == 'Пси-поле' then
                local num = math.Clamp(plyArea.properties.level - protTable["Пси-защита"]/100, 0, 100)
                player:SetHealth( math.Clamp(player:Health() - num, 0, 100) )
            end;
            if plyArea && plyArea.type == 'Жарка' then
                local num = math.Clamp(plyArea.properties.level - protTable["Температура"]/100, 0, 100)
                player:SetHealth( math.Clamp(player:Health() - num, 0, 100) )
            end;
            if plyArea && plyArea.type == 'Токсины' then
                local num = math.Clamp(plyArea.properties.level - protTable["Токсины"]/100, 0, 100)
                player:SetHealth( math.Clamp(player:Health() - num, 0, 100) )
            end;
        end;
    end;

end;

function Schema:PlayerMessageSend(speaker, chatType, text, anonymous, receivers, rawText)
	if (chatType == "ic" or chatType == "w" or chatType == "y") then
		local class = self.voices.GetClass(speaker)

		for k, v in ipairs(class) do
			local info = self.voices.Get(v, rawText)

			if (info) then
				local volume = 80

				if (chatType == "w") then
					volume = 60
				elseif (chatType == "y") then
					volume = 150
				end

				if (info.sound) then
					if (info.global) then
						netstream.Start(nil, "PlaySound", info.sound)
					else
						speaker.bTypingBeep = nil
						ix.util.EmitQueuedSounds(speaker, {info.sound, "NPC_MetroPolice.Radio.Off"}, nil, nil, volume)
					end
				end

				return info.text
			end
		end
	end
end

function Schema:PlayerDeath(client, inflictor, attacker)
    local container = ents.Create("ix_container")
    container:SetPos(client:GetPos())
    container:SetAngles(client:GetAngles())
    container:SetModel("models/kek1ch/dev_rukzak.mdl")
    container:Spawn()
    ix.item.RegisterInv("playerCorpseLoot", 10, 10)

    ix.item.NewInv(0, "playerCorpseLoot", function(inventory)
        inventory.vars.isBag = true
        inventory.vars.isContainer = true

        if (IsValid(container)) then
            container:SetInventory(inventory)
        end
    end)

    for num, id in pairs(client:GetCharacter():GetInventory():GetItems()) do
        if id.base != "base_outfit" && id.base != "base_weapons" then
            id:Transfer(container:GetInventory():GetID(), nil, nil, client, false, true)
        end;
    end;
    local tenpercent = math.Round(client:GetCharacter():GetMoney()*0.1)
    client:GetCharacter():TakeMoney(tenpercent, true)
    container:SetMoney(container:GetMoney() + tenpercent)

    timer.Create("RemoveThis"..container:EntIndex(), 200, 1, function()
        if IsValid(container) then
            container:Remove()
        end;
    end)
end;

function AllowedSleeping()
    local animationTable = {
		"Lying_Down",
		"d1_town05_Winston_Down",
		"d2_coast11_Tobias",
		"sniper_victim_pre",
        "Sit_Ground",
        "d1_town05_Wounded_Idle_1"
    }
    
    return animationTable;
end;

function Schema:InitializedConfig()
    RunConsoleCommand("vj_npc_gibcollidable", "1");
    RunConsoleCommand("ai_serverragdolls", "1");
end