local mc = math.Clamp;
local ITEM = Clockwork.item:New(nil, true);
ITEM.name = "Clothes_base";
ITEM.uniqueID = "clothes_base";
ITEM.model = "models/props_junk/cardboard_box001a.mdl";
ITEM.weight = 5;
ITEM.useText = "Надеть";
ITEM.category = "Одежда";
ITEM.useSound = 'items/ammopickup.wav'

ITEM.costumeTable = {};
ITEM.isCostume = false;

ITEM.armor = 0;
ITEM.quality = 100;
ITEM.warm = 0;
ITEM.Setskin = 0;
ITEM.reduceSpeed = 0;
ITEM.addInventoryWeight = 0;
ITEM.addInventorySpace = 0;

ITEM.bid = 0;
ITEM.bstate = 0;
ITEM.clothesslot = "body";
ITEM.combineOnly = false;
ITEM.hasGasmask = false;
ITEM.isRespirator = false;

ITEM.allowBattery = false;

ITEM:AddData("Used", false, true);
ITEM:AddData("Armor", -1, true);
ITEM:AddData("Quality", -1, true);
ITEM:AddData("ClothesWarm", -1, true);
ITEM:AddData("SpeedDecrease", -1, true);
ITEM:AddData("AddWeight", -1, true);
ITEM:AddData("AddSpace", -1, true);
ITEM:AddData("HasGasmask", -1, true);
ITEM:AddData("HasRespirator", -1, true)
ITEM:AddData("HasFilter", false, true);
ITEM:AddData("FilterQuality", 0, true);
ITEM:AddData('HasBattery', false, true);
ITEM:AddData('Battery', 0, true);

function ITEM:OnHandleUnequip(Callback)
	if (self.OnDrop) then
		local menu = DermaMenu();
			menu:SetMinimumWidth(100);
			menu:AddOption("Снять", function()
				Callback("takedown");
            end);

            if self.hasGasmask && self:GetData('HasGasmask') then
                if !self:GetData('HasFilter') then
                    menu:AddOption("Вкрутить фильтр", function()
                       Callback("filterInsert");
                    end);
                elseif self:GetData('HasFilter') then
                    menu:AddOption("Выкрутить фильтр", function()
                        Callback("filterTake");
                    end);
                end;
            end;

            if self.clothesslot == 'armorKevlar' then
                if (self:GetData('Armor') > 0) then
                    menu:AddOption("Заменить бронепластину", function()
                        Callback("armorPlateInsert");
                    end);
                end;
            end;

            if self.allowBattery then
                if !self:GetData('HasBattery') then
                    menu:AddOption("Вставить батарею", function()
                       Callback("batteryInsert");
                    end);
                elseif self:GetData('HasBattery') then
                    menu:AddOption("Достать батарею", function()
                        Callback("batteryTake");
                    end);
                end;
            end;

		menu:Open();
	end;
end;
function ITEM:OnPlayerUnequipped(player, extraData)
    local trace = player:GetEyeTraceNoCursor();
    local slot = player:GetCharacterData("ClothesSlot");

    if extraData == "takedown" then
            player:GiveItem(self) -- armorPlateInsert
            self:RemSlot(player);
            self:RemPlayerBGroup(player)
            self:SetData("Used", false)
            player:AddCharClothesInfo('decreaseSpeed', -self:GetData('SpeedDecrease'));
            player:AddCharClothesInfo('incWeight', -self:GetData('AddWeight'));
            player:AddCharClothesInfo('incSpace', -self:GetData('AddSpace'));

            if self.MetrocopGasmask then
                player:SetCharacterData("GasMaskInfo", 0)
            end;
    elseif extraData == "armorPlateInsert" then        
        if (player:TakeItemByID('armor_plate_refiller')) then
            self:SetData('Armor', math.Clamp(self:GetData('Armor') + 50, 0, 100));
        end;
    elseif extraData == "filterInsert" then
        local itemTable = player:FindItemByID('item_respirator_filter');
        if !self:GetData('HasFilter') && itemTable then
            self:SetData('HasFilter', true)
            self:SetData('FilterQuality', itemTable:GetData('FilterQuality'))
            player:TakeItem(itemTable);
        end;
    elseif extraData == "filterTake" then
        if self:GetData('HasFilter') then
            player:GiveItem(Clockwork.item:CreateInstance("item_respirator_filter", nil, {FilterQuality = self:GetData('FilterQuality')}), true);
            self:SetData('HasFilter', false);
            self:SetData('FilterQuality', 0);
        end;
    elseif extraData == "batteryInsert" then
        local itemTable = player:FindItemByID('item_battery_charger');
        if !self:GetData('HasBattery') && itemTable then
            self:SetData('HasBattery', true);
            self:SetData('Battery', itemTable:GetData('ArmorCapacity'));
            player:TakeItem(itemTable);
        end;
    elseif extraData == "batteryTake" then
        if self:GetData('HasBattery') then
            player:GiveItem(Clockwork.item:CreateInstance("item_battery_charger", nil, {ArmorCapacity = self:GetData('Battery')}), true);
            self:SetData('HasBattery', false);
            self:SetData('Battery', 0);
        end;
    end;

end;

function ITEM:OnUse(player, itemEntity)
    local slot = player:GetCharacterData("ClothesSlot", {});
    local isCombine = Schema:PlayerIsCombine(player);

    if self:GetSlot(player) == "" then
        if (isCombine && self.combineOnly == false) || (!isCombine && self.combineOnly == true) then
            Clockwork.player:Notify(player, "Эта одежда не надевается на вас.");
            return false;
        end;
        self:SetPlayerBGroup(player);
        self:SetSlot(player);
        self:SetData("Used", true);
        player:AddCharClothesInfo('decreaseSpeed', self:GetData('SpeedDecrease'));
        player:AddCharClothesInfo('incWeight', self:GetData('AddWeight'));
        player:AddCharClothesInfo('incSpace', self:GetData('AddSpace'));

        if self.MetrocopGasmask then
            player:SetCharacterData("GasMaskInfo", self.MetrocopGasmask)
        end;
    else
        Clockwork.player:Notify(player, "Этот слот уже чем-то занят.");
        return false;
    end;

    return true;

end;

function ITEM:OnDrop(player, position) end;

-- // FUNCTIONS // --
function ITEM:SetPlayerBGroup(player)
	local bodygroups = player:GetCharacterData("toggle_bodygroup", {}) || {};
    local model = player:GetModel();
    local id = self("bid");
    local state = self("bstate");
    local bnum = player:GetNumBodyGroups();

	if id < bnum then
        bodygroups[model] = bodygroups[model] || {}
        if !self.isCostume then
    		bodygroups[model][tostring(id)] = state;
            player:SetBodygroup(id, state);
        elseif self.isCostume then
            for a, b in pairs(self.costumeTable) do
                bodygroups[model][tostring(a)] = b;
                player:SetBodygroup(a, b);
            end;
        end;
        player:SetCharacterData("toggle_bodygroup", bodygroups);
	end;
end;
function ITEM:RemPlayerBGroup(player)
    local bodygroups = player:GetCharacterData("toggle_bodygroup", {}) || {};
    local model = player:GetModel();
    local id = self("bid");
    local bnum = player:GetNumBodyGroups();

	if id < bnum then
		if !self.isCostume then
    		bodygroups[model][tostring(id)] = nil;
            player:SetBodygroup(id, 0);
        elseif self.isCostume then
            for a, b in pairs(self.costumeTable) do
                bodygroups[model][tostring(a)] = nil;
                player:SetBodygroup(a, 0);
            end;
        end;
		player:SetCharacterData("toggle_bodygroup", bodygroups);
	end;
end;
function ITEM:SetPlayerSkin(player)
    local skin = player:GetCharacterData("skin", {}) || {};
    local avskin = self("Setskin");
    local countSkin = player:SkinCount();
    local skin = player:GetSkin();

    if countSkin > 0 && skin != avskin then
        player:SetSkin(avskin);
        player:SetCharacterData("skin", avskin);
    end;
end;
function ITEM:RemPlayerSkin(player)
    local skin = player:GetCharacterData("skin", {}) || {};
    local avskin = self("Setskin");
    local countSkin = player:SkinCount();
    local skin = player:GetSkin();
    
    if countSkin > 0 && skin != avskin then
        player:SetSkin(0);
        player:SetCharacterData("skin", 0);
    end;
end;
function ITEM:GetSlot(player)
    local slot = player:GetCharacterData("ClothesSlot", {});
    local slot1 = self("clothesslot");
    
    if type(slot1) == "table" then
        for k, v in pairs(slot1) do
            return slot[v]
        end;
    else
        return slot[slot1];
    end;

end;
function ITEM:SetSlot(player)
    local slot = player:GetCharacterData("ClothesSlot", {});
    local slot1 = self("clothesslot");

    if type(slot1) == "table" then
        for k, v in pairs(slot1) do
            slot[v] = self("uniqueID");
        end;
    else
        slot[slot1] = self("uniqueID");
    end;

end;
function ITEM:RemSlot(player)
    local slot = player:GetCharacterData("ClothesSlot", {});
    local slot1 = self("clothesslot");

    if type(slot1) == "table" then
        for k, v in pairs(slot1) do
            slot[v] = ""
        end;
    else
        slot[slot1] = "";
    end;

end;
function ITEM:IsUsed()
    return self:GetData("Used");
end;
function ITEM:CanHolsterWeapon(player, forceHolster, bNoMsg)
	return true;
end;
function ITEM:HasPlayerEquipped(player, bIsValidWeapon)
	return self:IsUsed()
end
function ITEM:CanGiveStorage(player, storageTable)
	if (self:IsUsed()) then
		Clockwork.player:Notify(player, "Вы не можете положить предмет в хранилище, нося его!");
		return false;
	end;
end;
function ITEM:CanTakeStorage(player, storageTable)
	local target = Clockwork.entity:GetPlayer(storageTable.entity);
	if (target) then
		if (target:GetInventoryWeight() > (target:GetMaxWeight() - self("additionalWeight"))) then
			return false;
		end;
	end;
end;
-- // FUNCTIONS // --

if SERVER then
    function ITEM:OnInstantiated()
        local armor = self:GetData("Armor");
        local quality = self:GetData("Quality");
        local warming = self:GetData('ClothesWarm');
        local speed = self:GetData('SpeedDecrease');
        local weight = self:GetData('AddWeight');
        local space = self:GetData('AddSpace');
        local hasGasmaskData = self:GetData('HasGasmask');
        local hasRespiratorData = self:GetData('HasRespirator');
        
        if (armor == -1) then
            self:SetData("Armor", self("armor"));
        end;
        if (quality == -1) then
            self:SetData("Quality", self("quality"));
        end;
        if (warming == -1) then
            self:SetData("ClothesWarm", self("warm"));
        end;
        if (speed == -1) then
            self:SetData("SpeedDecrease", self("reduceSpeed"));
        end;
        if (weight == -1) then
            self:SetData("AddWeight", self("addInventoryWeight"));
        end;
        if (space == -1) then
            self:SetData("AddSpace", self("addInventorySpace"));
        end;
        if (hasGasmaskData == -1) then
            self:SetData("HasGasmask", self("hasGasmask"));
        end;
        if hasRespiratorData == -1 then
            self:SetData('HasRespirator', self('isRespirator'));
        end;
    end;

    function ITEM:EntityHandleMenuOption(player, entity, option, argument)
        local sewingKit = player:FindItemByID('ross_sewing_kit')
        if (option == "Подшить" && sewingKit && sewingKit:GetData('Webs') > 0 && player:HasItemByID('material_cloth')) then
            Clockwork.player:SetAction(player, "SEWING_KIT_CLOTHES", 7);
			Clockwork.player:EntityConditionTimer(player, entity, entity, 7, 192, function()
				return player:Alive() and !player:IsRagdolled()
			end, function(success)
				if (success) then
                    player:TakeItemByID('material_cloth')
                    sewingKit:SetData('Webs', math.Clamp(sewingKit:GetData('Webs') - 10, 0, 100));
                    self:SetData('ClothesWarm', math.Clamp(self:GetData('ClothesWarm') + 10, 0, 100));
                    self:SetData('Quality', math.Clamp(self:GetData('Quality') + 10, 0, 100));    
				end;

				Clockwork.player:SetAction(player, "SEWING_KIT_CLOTHES", false);
			end);
        end;
        if (option == "Заменить бронепластину" && player:TakeItemByID('armor_plate_refiller') && self.clothesslot == 'armorKevlar') then
            self:SetData('Armor', math.Clamp(self:GetData('Armor') + 50, 0, 100));
        end;
    end;

else
    function ITEM:GetEntityMenuOptions(entity, options)
	    if (!IsValid(entity)) then
    		return;
        end;
        local inv = Clockwork.inventory:GetClient();
        local sewingKit = Clockwork.inventory:FindItemByID(inv, 'ross_sewing_kit');
        if sewingKit && sewingKit:GetData('Webs') > 0 then
            options["Подшить"] = function()
                Clockwork.entity:ForceMenuOption(entity, "Подшить");
            end;
        end;
        if self.clothesslot == 'armorKevlar' then
            if (self:GetData('Armor') > 0) then
                options["Заменить бронепластину"] = function()
                    Clockwork.entity:ForceMenuOption(entity, "Заменить бронепластину");
                end;
            end;
        end;
    end;

    function ITEM:GetQuality()
        local text = '';
        local itemQuality = self:GetData('Quality');
        if itemQuality <= 10 then
            text = 'Ужасное качество'
            color = Color(255, 10, 10)
        elseif itemQuality <= 50 then
            text = 'Порвано'
            color = Color(217, 126, 17);
        elseif itemQuality <= 80 then
            text = 'Слегка потрепано'
            color = Color(218, 213, 16)
        elseif itemQuality <= 100 then
            text = 'В порядке'
            color = Color(71, 218, 16);
        end;
        return text, color;
    end;

    function ITEM:GetArmor()
        local text = '';
        local itemArmor = self:GetData('Armor');
        if itemArmor <= 10 then
            text = 'Плохое состояние' color = Color(255, 10, 10)
        elseif itemArmor <= 50 then
            text = 'Среднее состояние' color = Color(217, 126, 17);
        elseif itemArmor <= 80 then
            text = "Высокое состояние" color = Color(218, 213, 16)
        elseif itemArmor > 80 then
            text = 'Отличное состояние' color = Color(71, 218, 16);
        end;
        return text, color;
    end;

    function ITEM:IsWarming()
        local text = '';
        local warm = self:GetData('ClothesWarm');
        if warm <= 10 then
            text = 'Не греет' color = Color(255, 10, 10)
        elseif warm <= 50 then
            text = 'Плохо греет' color = Color(217, 126, 17);
        elseif warm <= 80 then
            text = 'Нормально греет' color = Color(218, 213, 16)
        elseif warm > 80 then
            text = 'Греет' color = Color(71, 218, 16);
        end;
        return text, color;
    end;

    function ITEM:GetClientSideInfo()
        if (!self:IsInstance()) then return; end;
        local clientSideInfo = "";
        local one_text, one_color = self:GetQuality();
        local two_text, two_color = self:GetArmor();
        local three_text, three_color = self:IsWarming();

        clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, "Качество одежды: "..tostring(one_text), one_color);
        if (self:GetData('Armor') > 0) then
            clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, "Качество брони: "..tostring(two_text), two_color);
        end;
        clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, "Качество обогревания: "..tostring(three_text), three_color);
        if self.allowBattery then
            clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, "Индикатор батареи: "..tostring( self:GetData('Battery') ), Color(100, 100, 255));
        end;
        
        return (clientSideInfo != "" and clientSideInfo);
    end;
end;

Clockwork.item:Register(ITEM);