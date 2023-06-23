local mc = math.Clamp;
local ITEM = Clockwork.item:New(nil, true);
ITEM.name = "База еды";
ITEM.uniqueID = "food_base";
ITEM.model = "models/props_junk/cardboard_box001a.mdl";
ITEM.weight = 5;
ITEM.useText = "Употребить";
ITEM.category = "Пища";

ITEM.hasgarbage = false;
ITEM.foodtype = 0;
ITEM.portions = 5;
ITEM.dhunger = 0;
ITEM.dthirst = 0;
ITEM.dsleep = 0;
ITEM.addDirt = 0;
ITEM.addDamage = 0;
ITEM.canPickup = true;
ITEM.needSalt = false;

ITEM:AddData("Garbage", false, true);
ITEM:AddData("NeedSalt", -1, true);
ITEM:AddData("CanPickUp", -1, true);

ITEM:AddData("IsCrafted", false, true)

ITEM:AddData("FoodQuality", 0, true);
ITEM:AddData("Portions", -1, true);
ITEM:AddData("Damage", -1, true);
ITEM:AddData("DHunger", -1, true);
ITEM:AddData("DThirst", -1, true);
ITEM:AddData("DSleep", -1, true);
ITEM:AddData("AddDirt", -1, true);

ITEM:AddData("Model", "", true);

ITEM:AddData("ExpirationDate", 0, true);

function ITEM:EmitFoodSound()
    if self("foodtype") == 1 then -- Food
        return "npc/barnacle/barnacle_crunch2.wav";
    elseif self("foodtype") == 2 then -- Drink
        return "npc/barnacle/barnacle_gulp1.wav"
    elseif self("foodtype") != 1 && self("foodtype") != 2 then
        return "npc/barnacle/neck_snap1.wav"
    end;
end;

function ITEM:OnUse(player, itemEntity)
    local hunger = player:GetNeed("hunger");
    local thirst = player:GetNeed("thirst");
    local sleep = player:GetNeed("sleep");
    local portions = self:GetData("Portions");
    local garbage = self:GetData("Garbage");
    local quality = self:GetData("FoodQuality");
    local damage = self:GetData("Damage");
    local datahunger = self:GetData("DHunger");
    local datathirst = self:GetData("DThirst");
    local datasleep = self:GetData("DSleep");
    local datadirt = self:GetData("AddDirt");    

    if self("foodtype") == 1 then -- Food
        self.useSound = "npc/barnacle/barnacle_crunch2.wav";
    elseif self("foodtype") == 2 then -- Drink
        self.useSound = "npc/barnacle/barnacle_gulp1.wav"
    elseif self("foodtype") != 1 && self("foodtype") != 2 then
        self.useSound = "npc/barnacle/neck_snap1.wav"
    end;

    if garbage == false then
        if portions > 0 then
            if datahunger && datahunger > 0 then
                player:SetNeed("hunger", mc(hunger - datahunger - quality/10, 0, 100));
            end;
            if datathirst && datathirst > 0 then
                player:SetNeed("thirst", mc(thirst - datathirst - quality/10, 0, 100));
            end;
            if datasleep && datasleep > 0 then
                player:SetNeed("sleep", mc(sleep - datasleep - quality/10, 0, 100));
            end;
            if damage && damage > 0 then
                player:SetHealth( mc(player:Health() - damage, 0, player:GetMaxHealth()));
            end;
            if self:GetData("ExpirationDate") > 35 then 
                if math.random(1, 100) < self:GetData("ExpirationDate") then 
                    player:AddSympthom("vomit");
                end;
            end;
            self:SetData("Portions", mc(portions - 1, 0, self("portions")));
            player:EmitSound(self:EmitFoodSound());
            return false;

        elseif portions == 0 && (self("hasgarbage")) then
            self:SetData("Garbage", true);
            return false;
        elseif portions == 0 && (!self("hasgarbage") || (self("hasgarbage") == nil)) then
            player:EmitSound(self:EmitFoodSound());
            return nil;
        end;
    end;

    return false;
end;

function ITEM:OnDrop(player, position) end;

function ITEM:GetEntityMenuOptions(entity, options)
	if (!IsValid(entity)) then
		return;
    end;
    
    if self:GetData("NeedSalt") == true then
	    options["Посолить"] = function()
	    	Clockwork.entity:ForceMenuOption(entity, "Посолить", nil);
        end;
    end;

end;

function ITEM:EntityHandleMenuOption(player, entity, option, argument)

    if (option == "Посолить" && self:GetData("NeedSalt") == true) then
        for k, v in ipairs( ents.FindInSphere(entity:GetPos(), 15) ) do
			if v:IsValid() && v:GetClass() == "cw_item" && v("uniqueID") == "ross_salt" && v:GetData("Uses") != 0 then
                self:SetData("FoodQuality", math.Clamp(self:GetData("FoodQuality") + 5, 0, 15));
                v:SetData("Uses", math.Clamp(v:GetData("Uses") - 1, 0, 12));
            else
                Clockwork.chatBox:SendColored(player, Color(230, 230, 72), "**Вы замечаете, что рядом с предметом нет соли.");
			end;
        end;
    end;
    
end;

function ITEM:OnPickup(player, quickUse, entity)
    local clean = player:GetNeed("clean");
    if self:GetData("AddDirt") > 0 then 
        player:SetNeed("clean", mc(clean + self:GetData("AddDirt"), 0, 100))
    end;
end;

function ITEM:CanPickup(player, quickUse, entity)
    if self:GetData("CanPickUp") == false then
        Clockwork.chatBox:SendColored(player, Color(230, 230, 72), "**Вы не можете поднять этот предмет, так как он является пищей.");
        return false;
    end;
end;

if (SERVER) then
	function ITEM:OnInstantiated()
        local portions = self:GetData("Portions");
        local damage = self:GetData("Damage");
        local hunger = self:GetData("DHunger");
        local thirst = self:GetData("DThirst");
        local sleep = self:GetData("DSleep");
        local dirt = self:GetData("AddDirt");
        local pickup = self:GetData("CanPickUp");
        local salt = self:GetData("NeedSalt");
        local mdl = self:GetData("Model");
        
        if hunger == -1 then
            self:SetData("DHunger", self("dhunger"))
        end;
        if thirst == -1 then
            self:SetData("DThirst", self("dthirst"));
        end;
        if sleep == -1 then
            self:SetData("DSleep", self("dsleep"));
        end;
        if dirt == -1 then
            self:SetData("AddDirt", self("addDirt"));
        end;
		if (portions == -1) then
			self:SetData("Portions", self("portions"));
        end;
        if (damage == -1) then
            self:SetData("Damage", self("addDamage"));
        end;
        if (pickup == -1) then
            self:SetData("CanPickUp", self("canPickup"))
        end;
        if (salt == -1) then
            self:SetData("NeedSalt", self("needSalt"));
        end;
        if (mdl == "") then
            self:SetData("Model", self("model"));
        elseif mdl != "" then 
            self.model = mdl;
        end;
	
    end;
else
    function ITEM:GetClientSideInfo()
        if (!self:IsInstance()) then return; end;
        local garbage = self:GetData("Garbage");
        local potions = self:GetData("Portions");
        local clientSideInfo = "";

        if potions > 0 then
            clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, "Количество порций: "..potions, Color(190, 150, 150));
        end;
        if garbage == true then
            clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, "Мусор.", Color(150, 180, 150));
        end;

        clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, self.dhunger, Color(150, 180, 150));

        return (clientSideInfo != "" and clientSideInfo);
    end;
    
    function ITEM:GetClientSideModel()
        local model = self:GetData("Model");
        return model;
    end;
end;

Clockwork.item:Register(ITEM);