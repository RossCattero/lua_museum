
local PLUGIN = PLUGIN;

cable.receive('EditNotepadInfo', function(player, ent, tbl)
    local pages = tbl[1];
    local info = tbl[2]
    for k, v in pairs(pages) do
        pages[k]['info'] = pages[k]['info']:gsub('<', "&lt;" ):gsub('>', '&gt;')
        pages[k]['info'] = pages[k]['info']:gsub("%[(/?)([bius])%]", "<%1%2>"):gsub("%[(/?)(h[r1-3])%]", "<%1%2>")
        pages[k]['info'] = pages[k]['info']:gsub('%[color="(#?[0-9a-zA-Z]+)"%]', '<font color="%1">' ):gsub("%[/color%]","</font>")
        pages[k]['info'] = pages[k]['info']:gsub('\n', "<br />")
    end; -- [HTML] :1: Uncaught SyntaxError: Unexpected identifier

    
    if IsEntity( ent ) && ent:GetClass() == 'cw_item' then
        local notepadItem = ent:GetItemTable();
        notepadItem:SetData('Pages', pages)
        notepadItem:SetData('NoteInfo', info)
    elseif istable( ent ) then
        local notepadItem = player:FindItemByID(ent['unique'], ent['itemid'])
        if notepadItem && notepadItem:IsBasedFrom('ross_notepad_base') then
            notepadItem:SetData('Pages', pages)
            notepadItem:SetData('NoteInfo', info)
        end;
    end;

end);

--[[
    Идея:
    Сделать теги основных цветов и просто в css на странице задавать им цвет.
]]