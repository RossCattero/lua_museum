
function PLUGIN:EntityFireBullets(entity, bulletInfo) 
    if (entity:IsPlayer() && entity:IsValid()) then
        local char = entity:GetCharacter()
		local random, weapon = math.random(0, 110) weapon = entity:GetActiveWeapon();
        local wep = char:GetInventory():HasItem(weapon:GetClass()) 
        if !wep then return; end;
        local dat = wep:GetData("WeaponQuality", 100);
        weapon.CanJam = true;

        if IsWeaponTFA(weapon) && !IsWeaponMelee(weapon:GetClass()) then
			local attribute = char:GetAttribute( GetWeaponTFAtype(weapon:GetClass()) )
			weapon.Primary.KickUp = math.Clamp(10 - attribute, 0.5, 8)
		end;

        if dat < 55 && random > dat then
            weapon:SetJammed(true)
        end;
		if wep && random > 50 then
			wep:SetData("WeaponQuality", math.Clamp(dat - math.Round(weapon.Primary.Damage/1000, 2), 0, 100));
        end;
        local rand = math.random(100);
        local addition = 0
        local attributes = {
            assault = 1, shotgun = 1, pistol = 1, melee = 1, bolt_sniper = 1, submachine = 1
        }
        if player && random > 66 then
            local wepclass = weapon:GetClass();
            local wepType = GetWeaponTFAtype(wepclass);
            if wepType == 'melee' then
                addition = addition + math.random(0.01, 0.1);
            end;
            char:UpdateAttrib(wepType, 0.01 + addition)
            attributes[wepType] = nil;

            for k, v in pairs(attributes) do
                if char:GetAttribute(k) && char:GetAttribute(k) > 0 then
                    char:UpdateAttrib(k, -0.02)
                end;
            end;
        end;
	end;
end;

function PLUGIN:PlayerSwitchWeapon(player, oldWeapon, weapon)
	local item = player:GetCharacter():GetInventory():HasItem(weapon:GetClass());
	
    if item && item:GetData('WepAttachments') then
        for k, v in pairs(item:GetData('WepAttachments')) do
            if weapon:CanAttach(v) && v != '' then
                weapon:Attach(v)
            end;
        end;
     end;
end;

function PLUGIN:KeyPress( player, key )
    local weapon = player:GetActiveWeapon();
    if key == IN_RELOAD then
        timer.Create("ixToggleRaise"..player:SteamID(), 1, 1, function()
            if (IsValid(player)) then
                if IsWeaponTFA(weapon) then
                    weapon:CycleSafety()
                    player:SetWepRaised(weapon:IsSafety(), weapon)
                end;
				player:ToggleWepRaised()
			end
		end)
    end;

    if IsWeaponTFA(weapon) && player:KeyDown(IN_SPEED) && player:KeyDown(IN_USE) && !player:KeyPressed(IN_RELOAD) then
        weapon:CycleSafety()
        player:SetWepRaised(!weapon:IsSafety(), weapon)
    end;
end;

function PLUGIN:KeyRelease(client, key)
    local weapon = client:GetActiveWeapon()
	if (key == IN_RELOAD) then
		timer.Remove("ixToggleRaise" .. client:SteamID())
	end
end

netstream.Hook("ToolRepair_action", function(client, repairAmount, item, AdditionalItem, RepairKit)
    local character = client:GetCharacter()
    local repair = character:GetAttribute('crafting')
    local inventory = client:GetCharacter():GetInventory()
    local NewItem = inventory:GetItemByID(item.id);
    local NewAdditional;

    if AdditionalItem then NewAdditional = inventory:GetItemByID(AdditionalItem.id) end;

    if item && NewItem && NewItem.uniqueID == inventory:GetItems()[item.id].uniqueID then
        client:SetRestricted(true, true)
        client:SetAction("Произвожу починку...", 15 - repair, function()
            local rep = inventory:GetItemByID(RepairKit.id)
            if math.random(85) - repair < math.random(repair, 75) + repair then

                if item.base == "base_outfit" then
                    for k, v in pairs(NewItem:GetData('outfit_info')) do
                        NewItem:GetData('outfit_info')[k] = math.Clamp(NewItem:GetData('outfit_info')[k] + repairAmount + repair, 0, NewItem:GetData('outfit_buffer')[k])
                    end;

                    if NewItem:GetData('equip') then
                        local protTable = client:GetLocalVar('ProtectionTable')
                       for k, v in pairs(protTable) do
                            protTable[k] =  math.Clamp(protTable[k] + repairAmount + repair, 0, 1000)
                        end;
                        client:SetLocalVar('ProtectionTable', protTable)
                    end;
                elseif item.base == "base_weapons" then
                    NewItem:SetData('WeaponQuality', math.Clamp(NewItem:GetData('WeaponQuality') + repairAmount + repair, 0, 100))
                end;

                character:UpdateAttrib('crafting', math.random(1, 5)/100)
            else
                client:Notify("У вас не получилось починить.")
            end;
            rep:SetData('useamount', math.Clamp(rep:GetData('useamount') - 1, 0, 20))
            if inventory:GetItemByID(RepairKit.id):GetData('useamount') < 1 then
                character:RemoveCarry(inventory:GetItemByID(RepairKit.id))
                inventory:Remove(RepairKit.id)
            end;
            client:SetRestricted(false, true)
        end)

        if AdditionalItem && NewAdditional && NewAdditional.uniqueID == inventory:GetItems()[AdditionalItem.id].uniqueID then
            character:RemoveCarry(inventory:GetItemByID(NewAdditional.id))
            inventory:Remove(NewAdditional.id)
        end;
    end;
end)

local function CountQualityPercent(item)
	local counted = 0;
	local hundredPercent = 0;
	local outInfo, buffer = item['qualityTable'], item["qualityTableBuffer"]

	for k, v in pairs(outInfo) do
		counted = counted + v;
	end;
	for k, v in pairs(buffer) do
		hundredPercent = hundredPercent + v;
	end;
	
	return math.Round((counted * 100)/hundredPercent);
end;

netstream.Hook("Table_repairAction", function(client, entity, item, repairKits, Materials, Blueprints)
    local character = client:GetCharacter();
    local inventory = character:GetInventory();
    local repair = character:GetAttribute('crafting')
    local countAmount = 0;

    if entity.itemInside.uniqueID ~= item.uniqueID then
        client:Notify("Я не могу чинить на этом рабочем столе.")
        return;
    end;

    client:SetAction("Произвожу починку на рабочем столе...", 20 - repair)
    client:DoStaredAction(entity, function()
        local firstRandom = math.random(85) - repair
        local secondRandom = math.random(repair, 75) + repair;

        for k, v in pairs(repairKits) do
            if inventory:GetItemByID(v.id) then
                countAmount = countAmount + inventory:GetItemByID(v.id).tableAddRepair;
                inventory:GetItemByID(v.id):SetData('useamount', math.Clamp(inventory:GetItemByID(v.id):GetData("useamount") - 1, 0, 100))

                if inventory:GetItemByID(v.id):GetData('useamount') < 1 then
                    character:RemoveCarry(inventory:GetItemByID(v.id))
                    inventory:Remove(v.id)
                end;
            end;
        end;
        
        for k, v in pairs(Materials) do
            if inventory:GetItemByID(v.id) then
                countAmount = countAmount + inventory:GetItemByID(v.id).addPercent
                character:RemoveCarry(inventory:GetItemByID(v.id))
                inventory:Remove(v.id)
            end;
        end;
        if firstRandom >= secondRandom then
            client:Notify("Я не могу чинить на этом рабочем столе.")
            return;
        end;

        if item.base == "base_outfit" then
            for k, v in pairs(entity.itemInside.qualityTable) do
                entity.itemInside.qualityTable[k] = math.Clamp(entity.itemInside.qualityTable[k] + countAmount, 0, entity.itemInside.qualityTableBuffer[k])
            end;
            entity.itemInside.quality = CountQualityPercent(entity.itemInside)
        elseif item.base == "base_weapons" then
            entity.itemInside.quality = math.Clamp(entity.itemInside.quality + countAmount, 0, 100)
        end;

        character:UpdateAttrib('crafting', math.random(1, 8)/100)
    end, 20 - repair, function()
        client:SetAction()
    end, 128)
end)


function PLUGIN:SaveData()
    local data = {}

    for _, entity in ipairs(ents.FindByClass("ross_repair_table")) do
        data[#data + 1] = {
            pos = entity:GetPos(),
            angles = entity:GetAngles(),
            model = entity:GetModel(),
            skin = entity:GetSkin(),
            InsideItem = entity.itemInside
        }
    end

    self:SetData(data)
end

function PLUGIN:LoadData()
    for _, v in ipairs(self:GetData() or {}) do
        local entity = ents.Create("ross_repair_table")
        entity:SetPos(v.pos)
        entity:SetAngles(v.angles)
        entity:Spawn()
        entity:SetModel(v.model)
        entity:SetSkin(v.skin or 0)
        entity:SetSolid(SOLID_BBOX)
        entity:PhysicsInit(SOLID_BBOX)
        local physObj = entity:GetPhysicsObject()
        if (IsValid(physObj)) then
            physObj:EnableMotion(false)
            physObj:Sleep()
        end
        entity.itemInside = v.InsideItem
    end
end