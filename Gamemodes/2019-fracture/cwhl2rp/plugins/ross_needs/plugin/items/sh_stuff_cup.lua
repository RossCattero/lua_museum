local ITEM = Clockwork.item:New();
ITEM.name = "Чашка";
ITEM.model = "models/props_junk/garbage_coffeemug001a.mdl";
ITEM.weight = 0.1;
ITEM.uniqueID = "stuff_cup";
ITEM.category = "Прочее";

ITEM:AddData("IsDrink", false, true);
ITEM:AddData("DrinkType", 0, true);
ITEM:AddData("Water", false, true);
ITEM:AddData("DrinkQuality", 0, true);

function ITEM:OnDrop(player, position) end;

function ITEM:EntityHandleMenuOption(player, entity, option, argument)

    if (option == "Сделать кофе") then
        for k, v in ipairs( ents.FindInSphere(entity:GetPos(), 15) ) do
			if v:IsValid() && v:GetClass() == "cw_item" && (v("coffee") == true) && self:GetData("DrinkType") == 3 && self:GetData("Water") == true then
                self:SetData("DrinkType", 1);
                self:SetData("IsDrink", true);
                v:Remove();
			end;
        end;
    end;

    if (option == "Сделать чай") then
        for k, v in ipairs( ents.FindInSphere(entity:GetPos(), 15) ) do
			if v:IsValid() && v:GetClass() == "cw_item" && (v("teabag") == true) && self:GetData("DrinkType") == 3 && self:GetData("Water") == true then
                self:SetData("DrinkType", 2);
                self:SetData("IsDrink", true);
                v:Remove();
			end;
		end;
    end;

    if (option == "Налить воды") then
        for k, v in ipairs( ents.FindInSphere(entity:GetPos(), 15) ) do
            if v:IsValid() && v:GetClass() == "cw_item" && (v("uniqueID") == "ross_gasplita_kettle" && git(v, "data")["Water"] > 0) then
                git(v, "data")["Water"] = math.Clamp(git(v, "data")["Water"] - 10, 0, 100);
                if git(v, "data")["Heat"] == true then
                    self:SetData("DrinkQuality", 10);
                end;
                self:SetData("DrinkType", 3);
                self:SetData("Water", true);
                self:SetData("IsDrink", true);
            end;
        end;
    end;

    if (option == "Употребить") then
        if self:GetData("DrinkType") == 1 then
            player:SetNeed("sleep", math.Clamp(player:GetNeed("sleep") - 45 - self:GetData("DrinkQuality"), 0, 100));
            player:SetNeed("thirst", math.Clamp(player:GetNeed("thirst") - 35 - self:GetData("DrinkQuality"), 0, 100));
            player:EmitSound("npc/barnacle/barnacle_gulp1.wav");
            self:SetData("DrinkType", 0);
            self:SetData("Water", false);
            self:SetData("IsDrink", false);
        elseif self:GetData("DrinkType") == 2 then
            player:SetNeed("sleep", math.Clamp(player:GetNeed("sleep") - 10 - self:GetData("DrinkQuality"), 0, 100));
            player:SetNeed("thirst", math.Clamp(player:GetNeed("thirst") - 40 - self:GetData("DrinkQuality"), 0, 100));
            player:EmitSound("npc/barnacle/barnacle_gulp1.wav");
            self:SetData("DrinkType", 0);
            self:SetData("Water", false);
            self:SetData("IsDrink", false);
        elseif self:GetData("DrinkType") == 3 then
            player:SetNeed("thirst", math.Clamp(player:GetNeed("thirst") - 25, 0, 100));
            player:EmitSound("npc/barnacle/barnacle_gulp1.wav");
            self:SetData("DrinkType", 0);
            self:SetData("Water", false);
            self:SetData("IsDrink", false);
        end;
    end;

    if (option == "Добавить сахара") then
        for k, v in ipairs( ents.FindInSphere(entity:GetPos(), 15) ) do
            if v:IsValid() && v:GetClass() == "cw_item" && git(v, "uniqueID") == "ross_sugar" && git(v, "data")["Uses"] ~= 0 && self:GetData("DrinkQuality") < 6 then
                git(v, "data")["Uses"] = git(v, "data")["Uses"] - 1
                self:SetData("DrinkQuality", math.Clamp(self:GetData("DrinkQuality") + 3, 0, 6));
            end;
        end;
    end;
    
end;

function ITEM:GetEntityMenuOptions(entity, options)
	if (!IsValid(entity)) then
		return;
	end;

    if self:GetData("DrinkType") == 3 then
	    options["Сделать чай"] = function()
		    Clockwork.entity:ForceMenuOption(entity, "Сделать чай", nil);
        end;
        options["Сделать кофе"] = function()
		    Clockwork.entity:ForceMenuOption(entity, "Сделать кофе", nil);
        end;
    end;

    if self:GetData("Water") == false then
        options["Налить воды"] = function()
		    Clockwork.entity:ForceMenuOption(entity, "Налить воды", nil);
        end;
    end;

    if self:GetData("DrinkQuality") < 15 && self:GetData("DrinkType") == 1 || self:GetData("DrinkType") == 2 then
        options["Добавить сахара"] = function()
            Clockwork.entity:ForceMenuOption(entity, "Добавить сахара", nil);
        end;
    end;

    if self:GetData("IsDrink") == true then
        options["Употребить"] = function()
            Clockwork.entity:ForceMenuOption(entity, "Употребить", nil);
        end;
    end;

end;

function ITEM:CanPickup(player, quickUse, entity)
    if self:GetData("IsDrink") == true then
        return false;
    end;
end;

ITEM:Register();