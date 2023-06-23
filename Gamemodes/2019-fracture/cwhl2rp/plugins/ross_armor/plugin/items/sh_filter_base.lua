local mc = math.Clamp;
local ITEM = Clockwork.item:New(nil, true);
ITEM.name = "Filter Base";
ITEM.uniqueID = "filter_base";
ITEM.model = "models/teebeutel/metro/objects/gasmask_filter.mdl";
ITEM.weight = 5;
ITEM.category = "Одежда";
ITEM.itemrefiller = "";

ITEM:AddData("FilterIdeal", 100, true);

function ITEM:GetEntityMenuOptions(entity, options)
	if (!IsValid(entity)) then
		return;
    end;

	options["Наполнить"] = function()
	    Clockwork.entity:ForceMenuOption(entity, "Наполнить", nil);
    end;

end;

function ITEM:EntityHandleMenuOption(player, entity, option, argument)

    if (option == "Наполнить" && self:GetData("FilterIdeal") < 100) then
        if player:HasItemByID(self("itemrefiller")) then
            player:TakeItemByID(self("itemrefiller"));
            self:SetData("FilterIdeal", 100);
        end;
    end;
    
end;

function ITEM:OnDrop(player, position) end;

Clockwork.item:Register(ITEM);