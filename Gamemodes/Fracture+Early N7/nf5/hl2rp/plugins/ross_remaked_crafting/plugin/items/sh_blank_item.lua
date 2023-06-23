local ITEM = Clockwork.item:New();
ITEM.name = "Пустой предмет";
ITEM.model = "models/props_junk/garbage_newspaper001a.mdl";
ITEM.weight = 0.1;
ITEM.uniqueID = "blank_item_roleplay";
ITEM.category = "Прочее";

ITEM:AddData("name", ITEM.name, true);
ITEM:AddData("weight", ITEM.weight, true);
ITEM:AddData("model", ITEM.model, true);

function ITEM:OnDrop(player, position) end;

if SERVER then
    function ITEM:OnInstantiated()

        self.name = self:GetData("name");
        self.weight = self:GetData("weight");
        self.model = self:GetData("model");

    end;
end;

function ITEM:EntityHandleMenuOption(player, entity, option, argument)

    if !player:IsAdmin() then
        return;
    end;

    if (option == "Изменить(только администрация)") then
        self:SetData("name", tostring(argument.name));
        self.name = self:GetData("name");

        self:SetData("model", tostring(argument.model));
        self.model = self:GetData("model");

        entity:SetModel( self:GetData("model") )

        self:SetData("weight", tonumber(argument.weight));
        self.weight = self:GetData("weight");
    end;
    
end;

if CLIENT then
    function ITEM:GetEntityMenuOptions(entity, options)
	    if (!IsValid(entity)) then
    		return;
        end;
        
        options["Изменить(только администрация)"] = function()
            local table = {};
            if Clockwork.player:IsAdmin(Clockwork.Client) then
                Derma_StringRequest("Название", "Новое имя: "..self("name", ""), "", function(text)
                    table.name = tostring(text);
                    
                Derma_StringRequest("Модель", "Новая модель: "..self("model", "models/error.mdl"), "", function(text)
                    table.model = tostring(text);
        
                Derma_StringRequest("Вес", "Новый вес: "..self("weight", "0"), "", function(text)
                    table.weight = tonumber(text);
                    
                    Clockwork.entity:ForceMenuOption(entity, "Изменить(только администрация)", table);
        
                end); end); end);
            else
                Clockwork.chatBox:SendColored(player, Color(255, 100, 100), "Вы не имеете права редактировать предмет!");
            end;
        end;

    end;

    function ITEM:GetClientSideModel()
        local model = self:GetData("model");

        return model;
    end;

    function ITEM:GetClientSideName()
        local name = self:GetData("name");

        return name;
	end;
end;

ITEM:Register();