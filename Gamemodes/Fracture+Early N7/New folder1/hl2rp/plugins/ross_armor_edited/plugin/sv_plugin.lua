
local PLUGIN = PLUGIN;
local p = FindMetaTable( "Player" );
local math = math;
local m = math.Clamp;

function p:AddCharClothesInfo(info, amount)
    local getClothesInfoData = self:GetCharacterData('AdditionalClothesInfo');

    if getClothesInfoData[info] then
        getClothesInfoData[info] = getClothesInfoData[info] + amount
    end;
end;

function p:GetCharClothesInfo(info)
    local getClothesInfoData = self:GetCharacterData('AdditionalClothesInfo');

    return getClothesInfoData[info];
end;

function p:GetClothesSlot()
    local clothes = self:GetCharacterData('ClothesSlot')

    return clothes
end;

function p:GetFilterQuality()
    local slots = player:GetClothesSlot();
    local uniqueItemID = '';

    if slots['head'] != "" then
        uniqueItemID = slots['head'];
    elseif slots['gasmask'] != "" then
        uniqueItemID = slots['gasmask'];
    elseif slots['body'] != "" then
        uniqueItemID = slots['body'];
    else
        return;
    end;

    local item = player:FindItemByID(uniqueItemID);
    local hasgasmask = item:GetData('HasGasmask');
    local filterQuality = item:GetData('FilterQuality');
    local hasFilter = item:GetData('HasFilter');

    if item && hasgasmask && hasFilter then
        return filterQuality;
    end;

    return 0;
end;

function p:SetFilterQuality(number)
    local slots = player:GetClothesSlot();
    local uniqueItemID = '';

    if slots['head'] != "" then
        uniqueItemID = slots['head'];
    elseif slots['gasmask'] != "" then
        uniqueItemID = slots['gasmask'];
    elseif slots['body'] != "" then
        uniqueItemID = slots['body'];
    else
        return;
    end;

    local item = player:FindItemByID(uniqueItemID);
    local hasgasmask = item:GetData('HasGasmask');
    local filterQuality = item:GetData('FilterQuality');

    if item && hasgasmask && hasFilter && filterQuality > 0 then
        item:SetData('FilterQuality', filterQuality);
    end;
end;

function PLUGIN:PlayerSaveCharacterData(player, data)
	if (data["ClothesSlot"]) then
		data["ClothesSlot"] = data["ClothesSlot"];
	else
	    data["ClothesSlot"] = {
            head = "",
            body = "",
            legs = "",
            gasmask = "",
            armorKevlar = "",
            backpack = '',
            hands = '',
            steto = '',
            tools = '',
            knee = '',
            elbow = ''
		};
    end;

    if data['bgs'] then
        data['bgs'] = data['bgs']
    else
        data['bgs'] = {}
    end;

    if data['AdditionalClothesInfo'] then
        data["AdditionalClothesInfo"] = data["AdditionalClothesInfo"];
    else
        data['AdditionalClothesInfo'] = {
            decreaseSpeed = 0,
            incWeight = 0,
            incSpace = 0
        };
    end;
      
end;

function PLUGIN:PlayerRestoreCharacterData(player, data)
	if ( !data["ClothesSlot"] ) then
		data["ClothesSlot"] = {
            head = "",
            body = "",
            legs = "",
            gasmask = "",
            armorKevlar = "",
            backpack = '',
            hands = '',
            steto = '',
            tools = '',
            knee = '',
            elbow = ''
		};
    end;

    if !data['bgs'] then
        data['bgs'] = {}
    end;

    if !data['AdditionalClothesInfo'] then
        data['AdditionalClothesInfo'] = {
            decreaseSpeed = 0,
            incWeight = 0,
            incSpace = 0
        }
    end;
    if !data["GasMaskInfo"] then
        data["GasMaskInfo"] = 0;
  end;
end;

function PLUGIN:PlayerSetSharedVars(player, curTime)
    player:SetSharedVar("GasMaskInfo", player:GetCharacterData("GasMaskInfo"));
end;

function PLUGIN:PlayerThink(player, curTime, infoTable)
    local runSpeed = Clockwork.config:Get("run_speed"):Get();
    local walkspeed = Clockwork.config:Get("walk_speed"):Get();
    local jumpPower = Clockwork.config:Get("jump_power"):Get();

    infoTable.runSpeed = m(infoTable.runSpeed - player:GetCharClothesInfo('decreaseSpeed'), 1, runSpeed);
    infoTable.walkSpeed = m(infoTable.walkSpeed - player:GetCharClothesInfo('decreaseSpeed'), 1, walkspeed);
    infoTable.jumpPower = m(infoTable.jumpPower - player:GetCharClothesInfo('decreaseSpeed'), 1, jumpPower);
    infoTable.inventoryWeight = infoTable.inventoryWeight + player:GetCharClothesInfo('incWeight');
    infoTable.inventorySpace = infoTable.inventorySpace + player:GetCharClothesInfo('incSpace');

end;

function PLUGIN:PlayerModelChanged(player, model)
    local clothes = player:GetClothesSlot();
    for k, v in pairs(clothes) do
        if player:FindItemByID(clothes[k]) then
            player:FindItemByID(clothes[k]):OnPlayerUnequipped(player, 'takedown')
        end;
    end;
end;

function PLUGIN:PlayerScaleDamageByHitGroup(player, attacker, hg, damageInfo, baseDamage)
    local slots = player:GetClothesSlot()
    local damage = damageInfo:GetDamage();

    damageInfo:ScaleDamage(1.5)

    if hg == 1 && (slots['head'] != "" || slots['gasmask'] != "") then
        local headitem = player:FindItemByID(slots['head']);
        local used = headitem:GetData('Used');
        local armor = headitem:GetData('Armor');
        local quality = headitem:GetData('Quality');
        local warm = headitem:GetData('ClothesWarm');
        local battery = headitem:GetData('Battery');

        if headitem && used then
            headitem:SetData('Armor', m(armor - damage, 0, 100));
            headitem:SetData('Quality', m(quality - damage, 0, 100));
            headitem:SetData('ClothesWarm', m(warm - damage, 0, 100));
            headitem:SetData('Battery', m(battery - damage, 0, 100));
            damageInfo:ScaleDamage( 1 - (armor*4)/1000 - (quality*4)/1000 );
        end;
    elseif (hg == 2 || hg == 3 || hg == 4 || hg == 5) && (slots['body'] != "" || slots['armorKevlar'] != "") then
        local bodyClothes = player:FindItemByID(slots['body']);
        local used = bodyClothes:GetData('Used');
        local armor = bodyClothes:GetData('Armor');
        local quality = bodyClothes:GetData('Quality');
        local warm = bodyClothes:GetData('ClothesWarm');
        local battery = bodyClothes:GetData('Battery');

        if bodyClothes && used then

            bodyClothes:SetData('Armor', m(armor - damage, 0, 100));
            bodyClothes:SetData('Quality', m(quality - damage, 0, 100));
            bodyClothes:SetData('ClothesWarm', m(warm - damage, 0, 100));
            bodyClothes:SetData('Battery', m(battery - damage, 0, 100));

            if hg == 2 || hg == 3 then
                damageInfo:ScaleDamage( 1 - (armor*4)/1000 - (quality*4)/1000 );
            elseif hg == 4 || hg == 5 then
                damageInfo:ScaleDamage( 1 - (armor*4)/1000 - (quality*4)/1000 );
            end;
        end;
    elseif (hg == 6 || hg == 7) && (slots['legs'] != "") then
        local legsItem = player:FindItemByID(slots['legs']);
        local used = legsItem:GetData('Used');
        local armor = legsItem:GetData('Armor');
        local quality = legsItem:GetData('Quality');
        local warm = legsItem:GetData('ClothesWarm');
        local battery = legsItem:GetData('Battery');

        if legsItem && used then
            legsItem:SetData('Armor', m(armor - damage, 0, 100));
            legsItem:SetData('Quality', m(quality - damage, 0, 100));
            legsItem:SetData('ClothesWarm', m(warm - damage, 0, 100));
            legsItem:SetData('Battery', m(battery - damage, 0, 100));
            damageInfo:ScaleDamage( 1 - (armor*4)/1000 - (quality*4)/1000 );
        end;    
    end;
end;

function PLUGIN:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)

    local bgs = player:GetCharacterData('bgs') local skins = player:GetCharacterData('skins');

    if bgs && bgs[player:GetModel()] then
        for a, b in pairs(bgs[player:GetModel()]) do
            player:SetBodygroup(a, b)
        end
    end;
    if skins then
        player:SetSkin( skins )
    end;

end;