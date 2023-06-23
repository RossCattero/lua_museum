
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

function p:GetAllWarming()
    local clothes = self:GetCharacterData('ClothesSlot')
    local item1 = clothes['head']
    local item2 = clothes['body']
    local item3 = clothes['legs']
    local item4 = clothes['hands']

    if self:FindItemByID(item1) then
        item1 = self:FindItemByID(item1):GetData('ClothesWarm')
    else
        item1 = 0
    end;
    if self:FindItemByID(item2) then
        item2 = self:FindItemByID(item2):GetData('ClothesWarm')
    else
        item2 = 0
    end;
    if self:FindItemByID(item3) then
        item3 = self:FindItemByID(item3):GetData('ClothesWarm')
    else
        item3 = 0
    end;
    if self:FindItemByID(item4) then
        item4 = self:FindItemByID(item4):GetData('ClothesWarm')
    else
        item4 = 0
    end;

    return item1 + item2 + item3 + item4
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

function p:GasmaskInfo()
    local iscombine = Schema:PlayerIsCombine(self)
    local fac = self:GetFaction();
    local gi = self:GetCharacterData("GasMaskInfo")
    if iscombine then
        if fac == FACTION_MPF then
            return gi
        elseif fac == FACTION_OTA then
            return 10;
        end;
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
    if !data["GasMaskInfo"] && Schema:PlayerIsCombine(player) then
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

    -- infoTable.runSpeed = m(infoTable.runSpeed - player:GetCharClothesInfo('decreaseSpeed'), 1, runSpeed);
    -- infoTable.walkSpeed = m(infoTable.walkSpeed - player:GetCharClothesInfo('decreaseSpeed'), 1, walkspeed);
    -- infoTable.jumpPower = m(infoTable.jumpPower - player:GetCharClothesInfo('decreaseSpeed'), 1, jumpPower);
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
    
    if hg == 1 && (slots['head'] != "" || slots['gasmask'] != "") then
        local headItem = player:FindItemByID(slots['head']);
        local gasmaskItem = player:FindItemByID(slots['gasmask']);
        local armor, quality, warm, battery = 0, 0, 0, 0;
        if headItem then
            if headItem:GetData('Used') then
                headItem:SetData('Armor', m(headItem:GetData('Armor') - damage, 0, 100));
                headItem:SetData('Quality', m(headItem:GetData('Quality') - damage, 0, 100));
                headItem:SetData('ClothesWarm', m(headItem:GetData('ClothesWarm') - damage, 0, 100));
                headItem:SetData('Battery', m(headItem:GetData('Battery') - damage, 0, 100));                
                armor = armor + headItem:GetData('Armor');
                quality = quality + headItem:GetData('Quality');
                warm = warm + headItem:GetData('ClothesWarm');
                battery =  battery + headItem:GetData('Battery');
            end;
        end;
        if gasmaskItem then
            if gasmaskItem:GetData('Used') then
                gasmaskItem:SetData('Armor', m(gasmaskItem:GetData('Armor') - damage, 0, 100));
                gasmaskItem:SetData('Quality', m(gasmaskItem:GetData('Quality') - damage, 0, 100));
                gasmaskItem:SetData('ClothesWarm', m(gasmaskItem:GetData('ClothesWarm') - damage, 0, 100));
                gasmaskItem:SetData('Battery', m(gasmaskItem:GetData('Battery') - damage, 0, 100));    
                armor = armor + gasmaskItem:GetData('Armor');
                quality = quality + gasmaskItem:GetData('Quality');
                warm = warm + gasmaskItem:GetData('ClothesWarm');
                battery =  battery + gasmaskItem:GetData('Battery');
            end;
        end;
        damageInfo:ScaleDamage( 1 - (armor*4)/1000 - (quality*4)/1000 - (battery*4)/1000 );
    elseif (hg == 2 || hg == 3) && (slots['body'] != "" || slots['armorKevlar'] != "") then
        local bodyClothes = player:FindItemByID(slots['body']);
        local armorItem = player:FindItemByID(slots['armorKevlar']);
        local armor, quality, warm, battery = 0, 0, 0, 0;
        if bodyClothes then
            if bodyClothes:GetData('Used') then
                bodyClothes:SetData('Armor', m(bodyClothes:GetData('Armor') - damage, 0, 100));
                bodyClothes:SetData('Quality', m(bodyClothes:GetData('Quality') - damage, 0, 100));
                bodyClothes:SetData('ClothesWarm', m(bodyClothes:GetData('ClothesWarm') - damage, 0, 100));
                bodyClothes:SetData('Battery', m(bodyClothes:GetData('Battery') - damage, 0, 100));    
                armor = armor + bodyClothes:GetData('Armor');
                quality = quality + bodyClothes:GetData('Quality');
                warm = warm + bodyClothes:GetData('ClothesWarm');
                battery =  battery + bodyClothes:GetData('Battery');
            end;
        end;
        if armorItem then
            if armorItem:GetData('Used') then
                armorItem:SetData('Armor', m(armorItem:GetData('Armor') - damage, 0, 100));
                armorItem:SetData('Quality', m(armorItem:GetData('Quality') - damage, 0, 100));
                armorItem:SetData('ClothesWarm', m(armorItem:GetData('ClothesWarm') - damage, 0, 100));
                armorItem:SetData('Battery', m(armorItem:GetData('Battery') - damage, 0, 100));    
                armor = armor + armorItem:GetData('Armor');
                quality = quality + armorItem:GetData('Quality');
                warm = warm + armorItem:GetData('ClothesWarm');
                battery =  battery + armorItem:GetData('Battery');
            end;
        end;
        
        damageInfo:ScaleDamage( 1 - (armor*4)/1000 - (quality*4)/1000 - (battery*4)/1000 );
    elseif (hg == 4 || hg == 5) && (slots['elbow'] != "" || slots['hands'] != "") then
        local elbows = player:FindItemByID(slots['elbow']);
        local handy = player:FindItemByID(slots['hands']);
        local armor, quality, warm, battery = 0, 0, 0, 0;
        if elbows then
            if elbows:GetData('Used') then
                elbows:SetData('Armor', m(elbows:GetData('Armor') - damage, 0, 100));
                elbows:SetData('Quality', m(elbows:GetData('Quality') - damage, 0, 100));
                elbows:SetData('ClothesWarm', m(elbows:GetData('ClothesWarm') - damage, 0, 100));
                elbows:SetData('Battery', m(elbows:GetData('Battery') - damage, 0, 100));    
                armor = armor + elbows:GetData('Armor');
                quality = quality + elbows:GetData('Quality');
                warm = warm + elbows:GetData('ClothesWarm');
                battery =  battery + elbows:GetData('Battery');
            end;
        end;
        if handy then
            if handy:GetData('Used') then
                handy:SetData('Armor', m(handy:GetData('Armor') - damage, 0, 100));
                handy:SetData('Quality', m(handy:GetData('Quality') - damage, 0, 100));
                handy:SetData('ClothesWarm', m(handy:GetData('ClothesWarm') - damage, 0, 100));
                handy:SetData('Battery', m(handy:GetData('Battery') - damage, 0, 100));    
                armor = armor + handy:GetData('Armor');
                quality = quality + handy:GetData('Quality');
                warm = warm + handy:GetData('ClothesWarm');
                battery =  battery + handy:GetData('Battery');
            end;
        end;
        damageInfo:ScaleDamage( 1 - (armor*4)/1000 - (quality*4)/1000 - (battery*4)/1000 );
    elseif (hg == 6 || hg == 7) && (slots['legs'] != "" || slots['knee'] != "") then
        local leggy = player:FindItemByID(slots['legs']);
        local kneess = player:FindItemByID(slots['knee']);
        local armor, quality, warm, battery = 0, 0, 0, 0;
        if leggy then
            if leggy:GetData('Used') then
                leggy:SetData('Armor', m(leggy:GetData('Armor') - damage, 0, 100));
                leggy:SetData('Quality', m(leggy:GetData('Quality') - damage, 0, 100));
                leggy:SetData('ClothesWarm', m(leggy:GetData('ClothesWarm') - damage, 0, 100));
                leggy:SetData('Battery', m(leggy:GetData('Battery') - damage, 0, 100));  
                armor = armor + leggy:GetData('Armor');
                quality = quality + leggy:GetData('Quality');
                warm = warm + leggy:GetData('ClothesWarm');
                battery =  battery + leggy:GetData('Battery');
            end;
        end;
        if kneess then
            if kneess:GetData('Used') then
                kneess:SetData('Armor', m(kneess:GetData('Armor') - damage, 0, 100));
                kneess:SetData('Quality', m(kneess:GetData('Quality') - damage, 0, 100));
                kneess:SetData('ClothesWarm', m(kneess:GetData('ClothesWarm') - damage, 0, 100));
                kneess:SetData('Battery', m(kneess:GetData('Battery') - damage, 0, 100));  
                armor = armor + kneess:GetData('Armor');
                quality = quality + kneess:GetData('Quality');
                warm = warm + kneess:GetData('ClothesWarm');
                battery =  battery + kneess:GetData('Battery');
            end;
        end;
        damageInfo:ScaleDamage( 1 - (armor*4)/1000 - (quality*4)/1000 - (battery*4)/1000 );
    end;
end;

function PLUGIN:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)
    if firstSpawn then
        local citizenData = player:GetCharacterData("CitizenInfo")
    	if player:FindItemByID("citizen_civ_card") && (player:FindItemByID("citizen_civ_card"):GetData("CardInformation")["OwnerName"] == '' or player:FindItemByID("citizen_civ_card"):GetData("CardInformation")["OwnerName"] == player:Name()) then
		    player:FindItemByID("citizen_civ_card"):GetData("CardInformation")["OwnerName"] = player:Name();
	    	player:FindItemByID("citizen_civ_card"):GetData("CardInformation")["OwnerCID"] = player:GetCharacterData("cid")
    		citizenData["parentedCardNumber"] = player:FindItemByID("citizen_civ_card").itemID;
	    end;
    end;
end;

function PLUGIN:ClockworkInitPostEntity()
    self:LoadArmorBatteryChargers()
    self:LoadHealthBioChargers()
    self:LoadRepairTable()
end;

function PLUGIN:PostSaveData()
    self:SaveArmorBatteryChargers()
    self:SaveHealthBioChargers()
    self:SaveRepairTable()
end;

function PLUGIN:SaveArmorBatteryChargers()
    local tbl = {}
    for k, v in pairs(ents.FindByClass("armor_batterycharger")) do
        local mdl = v:GetModel();
        local ang = v:GetAngles();
        local pos = v:GetPos();
        table.insert(tbl, {
            angles = ang, position = pos, model = mdl
        });
    end;
    Clockwork.kernel:SaveSchemaData("plugins/armor_stations/"..game.GetMap(), tbl);
end;
function PLUGIN:SaveHealthBioChargers()
    local tbl = {}
    for k, v in pairs(ents.FindByClass("health_biocharger")) do
        local mdl = v:GetModel();
        local ang = v:GetAngles();
        local pos = v:GetPos();
        table.insert(tbl, {
            angles = ang, position = pos, model = mdl
        });
    end;
    Clockwork.kernel:SaveSchemaData("plugins/health_stations/"..game.GetMap(), tbl);
end;
function PLUGIN:SaveRepairTable()
    local tbl = {}
    for k, v in pairs(ents.FindByClass("ross_repair_table")) do
        local mdl = v:GetModel();
        local ang = v:GetAngles();
        local pos = v:GetPos();
        table.insert(tbl, {
            angles = ang, position = pos, model = mdl
        });
    end;
    Clockwork.kernel:SaveSchemaData("plugins/repair_tables/"..game.GetMap(), tbl);
end;
function PLUGIN:LoadArmorBatteryChargers()
    local tbl = Clockwork.kernel:RestoreSchemaData("plugins/armor_stations/"..game.GetMap());
    for k, v in pairs(tbl) do
        local entity = ents.Create("armor_batterycharger");      
        entity:SetAngles(v.angles);
        entity:SetModel(v.model);
        entity:SetPos(v.position);
        entity:Spawn();
    end;
end;
function PLUGIN:LoadHealthBioChargers()
    local tbl = Clockwork.kernel:RestoreSchemaData("plugins/health_stations/"..game.GetMap());
    for k, v in pairs(tbl) do
        local entity = ents.Create("health_biocharger");      
        entity:SetAngles(v.angles);
        entity:SetModel(v.model);
        entity:SetPos(v.position);
        entity:Spawn();
    end;
end;
function PLUGIN:LoadRepairTable()
    local tbl = Clockwork.kernel:RestoreSchemaData("plugins/repair_tables/"..game.GetMap());
    for k, v in pairs(tbl) do
        local entity = ents.Create("ross_repair_table");      
        entity:SetAngles(v.angles);
        entity:SetModel(v.model);
        entity:SetPos(v.position);
        entity:Spawn();
    end;
end;