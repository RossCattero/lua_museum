local ITEM = Clockwork.item:New(nil, true);
ITEM.name = "База книжек и блокнотов";
ITEM.model = "models/props_office/notepad_office.mdl";
ITEM.weight = 1000;
ITEM.uniqueID = "ross_notepad_base";
ITEM.category = "Книги";
ITEM.pages = 1;
ITEM.customFunctions = {"Посмотреть", "Редактировать"};

ITEM:AddData("Pages", {}, true)
ITEM:AddData("NoteInfo", {
    canpickup = true,
    owners = {}
}, true)

function ITEM:OnDrop(player, position) end;

function ITEM:CanPickup(player, quickUse, entity)
    return self:GetData('NoteInfo')['canpickup'];
end;

function ITEM:EntityHandleMenuOption(player, entity, option, argument)
    local pages = self:GetData('Pages');
    local infom = self:GetData('NoteInfo');
    local allowed = infom['owners'][player:SteamID()] || table.Count(infom['owners']) == 0 || Clockwork.player:HasFlags(player, "9") || player:IsSuperAdmin()

    if (option == "Посмотреть") then
        cable.send( player, 'LookNotepad', pages );
    
    elseif (option == "Редактировать" ) then
        if allowed then
            cable.send( player, 'EditNotepad', entity, pages, infom );
        else
            Clockwork.player:Notify(player, "Вы не можете этого делать!")
        end;
    end;
end;

if SERVER then
    function ITEM:OnInstantiated()
        if next(self:GetData('Pages')) == nil then
            for i = 1, self('pages') do
                self:GetData('Pages')[i] = {
                    info = '';
                }
            end;
        end;
    end;

    function ITEM:OnCustomFunction(player, f)
        local pages = self:GetData('Pages');
        local infom = self:GetData('NoteInfo');
        local allowed = infom['owners'][player:SteamID()] || table.Count(infom['owners']) == 0 || Clockwork.player:HasFlags(player, "9") || player:IsSuperAdmin()
        if f == 'Посмотреть' then
            cable.send( player, 'LookNotepad', pages );

        elseif f == "Редактировать" then
            if allowed then
                cable.send( player, 'EditNotepad', {unique = tostring(self('uniqueID')), itemid = tostring(self('itemID'))}, pages, infom );
            else
                Clockwork.player:Notify(player, "Вы не можете этого делать!")
            end;
        end;
	end;
else
    function ITEM:GetEntityMenuOptions(entity, options)
		if (!IsValid(entity)) then
			return;
        end;
        local infom = self:GetData('NoteInfo');
        local allowed = infom['owners'][Clockwork.Client:SteamID()] || table.Count(infom['owners']) == 0 || Clockwork.player:HasFlags(Clockwork.Client, "9") || Clockwork.Client:IsUserGroup('superadmin')
        
		options["Посмотреть"] = function()
			Clockwork.entity:ForceMenuOption(entity, "Посмотреть", nil);
        end;
        if allowed then
            options["Редактировать"] = function()
    			Clockwork.entity:ForceMenuOption(entity, "Редактировать", nil);
            end;
        end;

	end;
end;

Clockwork.item:Register(ITEM);