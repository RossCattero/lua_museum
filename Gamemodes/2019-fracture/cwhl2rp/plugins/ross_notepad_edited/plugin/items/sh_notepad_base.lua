local ITEM = Clockwork.item:New(nil, true);
ITEM.name = "База книжек и блокнотов";
ITEM.model = "models/props_lab/clipboard.mdl";
ITEM.weight = 1000;
ITEM.uniqueID = "ross_notepad_base";
ITEM.category = "Книги";
ITEM.customFunctions = {"Посмотреть"};
ITEM.pages = 1;

ITEM:AddData("NotepadTableForMe", {
    title = "Без заголовка",
    owner = "",
    pickup = 1,
    information = {},
    pages = 0,
    additionalInfo = {
        uniqueID = "",
        ItemID = 0
    }
}, true)

function ITEM:OnDrop(player, position) end;

function ITEM:CanPickup(player, quickUse, entity)
    local tbl = self:GetData("NotepadTableForMe");

    if tbl["pickup"] == 0 || entity.IsUsedNow == true then
        return false;
    end;
end;

function ITEM:EntityHandleMenuOption(player, entity, option, argument)
    local picking = self:GetData("CanBePickenUp")
    local tbl = self:GetData("NotepadTableForMe");
    tbl["pages"] = self.pages
    tbl["additionalInfo"]["uniqueID"] = self.uniqueID;
    tbl["additionalInfo"]["ItemID"] = self.ItemID

    if tbl["information"][1] == "" || tbl["information"][1] == nil then
        for i = 1, tbl["pages"] do
            table.insert(tbl["information"], i, "")
        end;
    end;

    if (option == "Посмотреть") then
        if (IsValid(entity) && (!entity.IsUsedNow || entity.IsUsedNow == nil)) then
            if entity:GetVelocity():Length() == 0 then
                Clockwork.entity:MakeSafe(entity, true, true, true);
            end;
            entity.IsUsedNow = true;
            cable.send(player, 'NotepadOpen', tbl)
        end;

    end;
    
end;

if SERVER then
    function ITEM:OnCustomFunction(player, funcName)
        local picking = self:GetData("CanBePickenUp")
        local tbl = self:GetData("NotepadTableForMe");
        tbl["pages"] = self.pages
        tbl["additionalInfo"]["uniqueID"] = self.uniqueID;
        tbl["additionalInfo"]["ItemID"] = self.ItemID

        if tbl["information"][1] == "" || tbl["information"][1] == nil then
            for i = 1, self.pages do
                table.insert(tbl["information"], i, "")
            end;
        end;

        if (funcName == "Посмотреть") then
            cable.send(player, 'NotepadOpen', tbl)
		end;
	end;
else
    function ITEM:GetEntityMenuOptions(entity, options)
		if (!IsValid(entity)) then
			return;
        end;
        
		options["Посмотреть"] = function()
			Clockwork.entity:ForceMenuOption(entity, "Посмотреть", nil);
        end;

	end;
end;

ITEM:Register();