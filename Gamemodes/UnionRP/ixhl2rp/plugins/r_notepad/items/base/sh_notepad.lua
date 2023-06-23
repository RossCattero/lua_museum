ITEM.name = "База книжек и блокнотов";
ITEM.model = "models/props_office/notepad_office.mdl";
ITEM.weight = 1000;
ITEM.category = "Книги";
ITEM.pages = 1;

function ITEM:OnDrop(player, position) end;

ITEM.functions.Read = {
    name = "Посмотреть",
    OnRun = function(item)
        local player = item.player;
        local pages, infom = item:GetData('Pages'), item:GetData('NoteInfo')

        if item.entity then
            netstream.Start( player, 'LookNotepad', item.entity:GetNetVar('data')['Pages'] );
        else
            netstream.Start( player, 'LookNotepad', pages );
        end;

        return false;
    end
}
ITEM.functions.Edit = {
    name = "Редактировать",
    OnRun = function(item)
        local player = item.player;
        local pages, infom = item:GetData('Pages'), item:GetData('NoteInfo')
        local u = tostring(item.uniqueID);
        local i = tostring(item.id)
        if item.entity then
            netstream.Start( player, 'EditNotepad', item.entity, item.entity:GetNetVar('data')['Pages'], item.entity:GetNetVar('data')['NoteInfo'] );
        else
            netstream.Start( player, 'EditNotepad', {unique = u, id = i}, pages, infom );
        end;
        return false;
    end,
    OnCanRun = function(item)
        local player = item.player; local pages, infom = item:GetData('Pages'), item:GetData('NoteInfo')
        return infom['owners'][player:SteamID()] || table.Count(infom['owners']) == 0 || player:GetCharacter():HasFlags('9') || player:IsSuperAdmin()
    end
}

function ITEM:CanTransfer(curInv, inventory)
    local itemData = self:GetData('NoteInfo');
    
    return itemData['canpickup'];
end;

if SERVER then
    function ITEM:OnInstanced()
        if !self:GetData('Pages') then
            self:SetData('Pages', {})
            for i = 1, self.pages do
                self:GetData('Pages')[i] = {info = ''}
            end;
        end;
        if !self:GetData('NoteInfo') then
            self:SetData('NoteInfo', {
                canpickup = true,
                owners = {}
            })
        end;
    end;
end;