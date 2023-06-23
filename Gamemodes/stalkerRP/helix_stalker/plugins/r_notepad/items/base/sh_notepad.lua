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
        netstream.Start( player, 'LookNotepad', pages );

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
            netstream.Start( player, 'EditNotepad', item.entity, pages, infom );
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