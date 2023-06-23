local mc = math.Clamp;
local ITEM = Clockwork.item:New(nil, true);
ITEM.name = "Clothes_base";
ITEM.uniqueID = "clothes_base";
ITEM.model = "models/props_junk/cardboard_box001a.mdl";
ITEM.weight = 5;
ITEM.useText = "Надеть";
ITEM.category = "Одежда";

ITEM.protection = 0;
ITEM.armor = 0;
ITEM.bid = 0;
ITEM.bstate = 0;
ITEM.type = 0;
ITEM.skin = 0;
ITEM.clothesslot = "body";

ITEM.additionalWeight = 0;

ITEM.kevlarplate = {};
ITEM.isGasmasked = false;
ITEM.reduceSpeed = 0;
ITEM.warmeing = 0;

ITEM.MetrocopGasmask = 0;

ITEM.combineOnly = false;

ITEM:AddData("Used", false, true);
ITEM:AddData("Protection", -1, true);
ITEM:AddData("Armor", -1, true);
ITEM:AddData("MaxProtection", -1, true);
ITEM:AddData("Type", -1, true); -- 1(легкая), 2(Тяжелая)
ITEM:AddData("Pockets", 0, true);
ITEM:AddData("ReduceSpeed", -1, true);
ITEM:AddData("Cleaning", 0, true);
ITEM:AddData("Warming", -1, true);

-- Gasmask --
ITEM:AddData("HasGasmask", -1, true);
ITEM:AddData("HasFilter", false, true);
ITEM:AddData("FilterQuality", 0, true);
-- Gasmask --

-- /// -- 
function ITEM:SetPlayerBGroup(player)
	local bodygroups = player:GetCharacterData("bodygroups", {}) || {};
    local model = player:GetModel();
    local id = self("bid");
    local state = self("bstate");

	if id < player:GetNumBodyGroups() then
		bodygroups[model] = bodygroups[model] || {}
		bodygroups[model][tostring(id)] = state;
		player:SetBodygroup(id, state);
		player:SetCharacterData("bodygroups", bodygroups);
	end;
end;
function ITEM:RemPlayerBGroup(player)
    local bodygroups = player:GetCharacterData("bodygroups", {}) || {};
    local model = player:GetModel();
    local id = self("bid");

	if id < player:GetNumBodyGroups() then
		bodygroups[model] = bodygroups[model] || {};
		bodygroups[model][tostring(id)] = nil;
		player:SetBodygroup(id, 0);
		player:SetCharacterData("bodygroups", bodygroups);
	end;
end;
function ITEM:SetPlayerSkin(player)
    local skin = player:GetCharacterData("skin", {}) || {};
    local avskin = self("skin");
    
    if player:SkinCount() > 0 && player:GetSkin() != avskin then
        player:SetSkin(avskin);
        player:SetCharacterData("skin", avskin);
    end;
end;
function ITEM:RemPlayerSkin(player)
    local skin = player:GetCharacterData("skin", {}) || {};
    local avskin = self("skin");
    
    if player:SkinCount() > 0 && player:GetSkin() != avskin then
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
    return;

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

    return;

end;
function ITEM:IsUsed()
    return self:GetData("Used");
end;
-- /// --

function ITEM:CanHolsterWeapon(player, forceHolster, bNoMsg)
	return true;
end;

function ITEM:HasPlayerEquipped(player, bIsValidWeapon)
	return self:IsUsed()
end

function ITEM:OnHandleUnequip(Callback)
	if (self.OnDrop) then
		local menu = DermaMenu();
			menu:SetMinimumWidth(100);
			menu:AddOption("Снять", function()
				Callback("takedown");
			end);
			menu:AddOption("Выбросить", function()
				Callback("drop");
            end);
            if self("clothesslot") == "gasmask" then
                if !self:GetData("HasFilter") && self:GetData("HasGasmask") then
                    menu:AddOption("Добавить фильтр", function()
                        Callback("Filter");
                    end);
                elseif self:GetData("HasFilter") && self:GetData("HasGasmask") then
                    menu:AddOption("Снять фильтр", function()
                        Callback("RemFilter");
                    end);
                end;
            end;
		menu:Open();
	end;
end;

function ITEM:OnPlayerUnequipped(player, extraData)
    local trace = player:GetEyeTraceNoCursor();
    local items = Clockwork.inventory:GetAsItemsList(player:GetInventory());

	if player:FindItemByID("gasmask_filter") && !self:GetData("HasFilter") && self:GetData("HasGasmask") && extraData == "Filter" then 
        self:SetData("FilterQuality", player:FindItemByID("gasmask_filter"):GetData("FilterIdeal"));
        self:SetData("HasFilter", true);
        player:TakeItemByID("gasmask_filter");
    elseif extraData == "RemFilter" && self:GetData("HasFilter") && self:GetData("HasGasmask") then
        player:GiveItem(Clockwork.item:CreateInstance("gasmask_filter", nil, {FilterIdeal = self:GetData("FilterQuality")} ));
        self:SetData("FilterQuality", 0);
        self:SetData("HasFilter", false);
    elseif extraData == "drop" && (player:GetShootPos():Distance(trace.HitPos) <= 192) then
		local entity = Clockwork.entity:CreateItem(player, self, trace.HitPos);
		if (IsValid(entity)) then
			Clockwork.entity:MakeFlushToGround(entity, trace.HitPos, trace.HitNormal);
            player:TakeItem(self, true);
            self:RemSlot(player);
            self:SetData("Used", false);
            self:RemPlayerBGroup(player)
            player:SetCharacterData("AddInvSpaceCode", mc(player:GetCharacterData("AddInvSpaceCode") - self("additionalWeight"), 0, 1000))
            if self.MetrocopGasmask then
                player:SetCharacterData("GasMaskInfo", 0)
            end;
        end;    
    elseif extraData == "takedown" then
        if player:GiveItem(self) then
            self:RemSlot(player);
            self:RemPlayerBGroup(player)
            self:SetData("Used", false)
            player:SetCharacterData("AddInvSpaceCode", mc(player:GetCharacterData("AddInvSpaceCode") - self("additionalWeight"), 0, 1000))
            if self.MetrocopGasmask then
                player:SetCharacterData("GasMaskInfo", 0)
            end;
        end;
    else
        Clockwork.player:Notify(player, "Вы не можете выбросить одежду так далеко!");
        return;
    end;

end;

function ITEM:OnUse(player, itemEntity)
    local slot = player:GetCharacterData("ClothesSlot", {});
    local clean = player:GetNeed("clean");

    if self:GetSlot(player) == "" then
        if !Schema:PlayerIsCombine(player) && self.combineOnly == true then
            Clockwork.player:Notify(player, "Эту одежда не надевается на вас.");
            return false;
        end;
        if Schema:PlayerIsCombine(player) && self.combineOnly == false then
            Clockwork.player:Notify(player, "Эту одежда не надевается на вас.");
            return false;
        end;
        self:SetPlayerBGroup(player);
        self:SetSlot(player);
        self:SetData("Cleaning", mc(self:GetData("Cleaning") + (clean/10), 0, 100));
        self:SetData("Used", true);
        player:SetCharacterData("AddInvSpaceCode", mc(player:GetCharacterData("AddInvSpaceCode") + self("additionalWeight"), 0, 1000))
        if self.MetrocopGasmask then
            player:SetCharacterData("GasMaskInfo", self.MetrocopGasmask)
        end;
    else
        Clockwork.player:Notify(player, "Этот слот уже чем-то занят.");
        return false;
    end;
    return true;

end;

function ITEM:OnHolster(player, bForced)
end;

function ITEM:OnDrop(player, position) 

end;

function ITEM:EntityHandleMenuOption(player, entity, option, argument)
    local soap = player:FindItemByID("analog_soap");
    local bleach = player:FindItemByID("analog_bleach");

    if (self:GetData("Type") == 1 && !self:GetData("HasGasmask")) then
	    if (option == "Пододеть бронежилет") then
		    self:Kevlar(player);
        end;
    end;
    
    if (self:GetData("Type") == 2 && self:GetData("Armor") == 0 && !self:GetData("HasGasmask")) then
	    if (option == "Использовать пластину") then
		    self:Plate(player);
        end;
    end;

    if (self:GetData("Pockets") ~= 3 && !self:GetData("HasGasmask")) then
	    if (option == "Пришить карман") then
            self:AddPocket(entity, player);
            print(self:GetData("HasGasmask"))
        end;
    end;

    if (soap || bleach) && !self:GetData("HasGasmask") then
        if (option == "Постирать предмет") then
            self:CleanSelfUp(entity, player)
        end;
    end;
    
end;

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

if SERVER then
    function ITEM:OnInstantiated()
        local prot = self:GetData("Protection");
        local max = self:GetData("MaxProtection");
        local type = self:GetData("Type");
        local armor = self:GetData("Armor");
        local hasgas = self:GetData("HasGasmask");
        local reduceSpeed = self:GetData("ReduceSpeed");
        local warm = self:GetData("Warming");
    
        if (prot == -1) then
            self:SetData("Protection", self("protection"));
        end;
        if (max == -1) then
            self:SetData("MaxProtection", self("protection"));
        end;
        if (armor == -1) then
            self:SetData("Armor", self("armor"));
        end;
        if (type == -1) then
            self:SetData("Type", self("type"));
        end;
        if (hasgas == -1) then
            self:SetData("HasGasmask", self.isGasmasked);
        end;
        if (reduceSpeed == -1) then
            self:SetData("ReduceSpeed", self("reduceSpeed"));
        end;
        if (warm == -1) then
            self:SetData("Warming", self("warmeing"));
        end;

    end;
	function ITEM:Kevlar(player)

        if player:HasItemByID("armor_vest_clothes") && self:GetData("Type") == 1 then
            player:TakeItemByID("armor_vest_clothes");
            self:SetData("Type", 2);
        end;

    end;
    function ITEM:AddPocket(entity, player)
        for k, v in ipairs( ents.FindInSphere(entity:GetPos(), 35)) do
            if v:IsValid() && v:GetClass() == "cw_item" && player:HasItemByID("clothes_pockets") then
                self.additionalWeight = mc(self.additionalWeight + 1.5, 0, 5);
                self:SetData("Pockets", mc(self:GetData("Pockets") + 1, 0, 3));
                player:TakeItemByID("clothes_pockets");
            end;
        end;
    end;
    function ITEM:Plate(player)
        if self:GetData("Type") == 2 && self:GetData("Armor") == 0 && player:HasItemByID("bigplate") then

            player:TakeItemByID("bigplate")
            self:SetData("Armor", mc(self:GetData("Armor") + 100, 0, 100));

        end;
    end;
    function ITEM:CleanSelfUp(entity, player)
        local soap = player:FindItemByID("analog_soap");
        local bleach = player:FindItemByID("analog_bleach");
        
        Clockwork.player:SetAction(player, "clean", 10);
        Clockwork.player:EntityConditionTimer(player, entity, entity, 10, 192, function()
            return player:Alive() 
        end, function(success)
            if (success) then
                if soap then
                    soap:SetData("Clean", math.Clamp(soap:GetData("Clean") - 1, 0, 7));
                    self:SetData("Cleaning", mc(self:GetData("Cleaning") - 20, 0, 100));
                elseif bleach then
                    bleach:SetData("Clean", math.Clamp(bleach:GetData("Clean") - 1, 0, 7));
                    self:SetData("Cleaning", mc(self:GetData("Cleaning") - 40, 0, 100))
                end;
            end;
            

            Clockwork.player:SetAction(player, "clean", false);
        end);

    end;
else
    function ITEM:GetType()
        local type = self:GetData("Type");
        local text, color;

        if type == 1 then
            text = "Обыкновенная одежда";
            color = Color(158, 250, 170);
        elseif type == 2 then
            text = "Улучшенная одежда";
            color = Color(247, 244, 162);
        end;

        return text, color;
    end;

    function ITEM:GetQuality()
        local prot = self:GetData("Protection");
        local text, color;
        
        if prot == 100 then
            color = Color(112, 195, 112);
            text = "Идеальное качество.";
        elseif prot >= 50.5 then
            color = Color(211, 140, 20);
            text = "Среднее качество.";
        elseif prot >= 20.5 then
            color = Color(214, 72, 18);
            text = "Плохое качество.";
        elseif prot >= 0 then
            color = Color(198, 34, 34);
            text = "Ужасное качество.";
        end;

        return text, color;
    end;

    function ITEM:GetCleaning()
        local clean = self:GetData("Cleaning");
        local text, color;
        
        if clean == 100 then
            color = Color(40, 66, 40);
            text = "Эта одежда гниет.";
        elseif clean >= 50.5 then
            color = Color(88, 73, 58);
            text = "Грязная одежда.";
        elseif clean >= 20.5 then
            color = Color(121, 115, 125);
            text = "Грязноватая одежда.";
        elseif clean >= 0 then
            color = Color(255, 255, 255);
            text = "Чистая одежда.";
        end;

        return text, color;
    end;

    function ITEM:GetClientSideInfo()
        if (!self:IsInstance()) then return; end;
        local clientSideInfo = "";
        local text, color = self:GetType();
        local text1, color1 = self:GetQuality();
        local text2, color2 = self:GetCleaning();

        clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, tostring(text), color);
        clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, tostring(text1), color1);
        clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, "Грязность: "..self:GetData("Cleaning"), Color(255, 120, 120));
        clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, "Тип: "..self:GetData("Type"), Color(255, 120, 120));
        clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, "Армор: "..math.Round(self:GetData("Armor"), 1), Color(255, 120, 120));
        clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, "Протекшн: "..math.Round(self:GetData("Protection")), Color(255, 120, 120));
        clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, "Количество фильтра: "..math.Round(self:GetData("FilterQuality")), Color(255, 120, 120));
        
        return (clientSideInfo != "" and clientSideInfo);
    end;
    function ITEM:OnHUDPaintTargetID(entity, x, y, alpha)
        local text1, color1 = self:GetQuality();

        y = Clockwork.kernel:DrawInfo(tostring(text1), x, y, color1, alpha);

		return y;
    end;
    function ITEM:GetEntityMenuOptions(entity, options)
		if (!IsValid(entity)) then
			return;
        end;
        
        if self("clothesslot") == "body" && self:GetData("Armor") == 0 && self:GetData("Type") == 1 then
		    options["Пододеть бронежилет"] = function()
			    Clockwork.entity:ForceMenuOption(entity, "Пододеть бронежилет", nil);
            end;
        end;
        if self("clothesslot") == "body" && self:GetData("Armor") == 0 && self:GetData("Type") == 2 then
		    options["Использовать пластину"] = function()
			    Clockwork.entity:ForceMenuOption(entity, "Использовать пластину", nil);
            end;
        end;
        if self("clothesslot") == "body" || self("clothesslot") == "legs" && self:GetData("Pockets") ~= 3 then
		    options["Пришить карман"] = function()
			    Clockwork.entity:ForceMenuOption(entity, "Пришить карман", nil);
            end;
        end;
        if entity:WaterLevel() ~= 0 then
            options["Постирать предмет"] = function()
			    Clockwork.entity:ForceMenuOption(entity, "Постирать предмет", nil);
            end;
        end;

	end;
end;

Clockwork.item:Register(ITEM);