
local PLUGIN = PLUGIN;

netstream.Hook('EditNotepadInfo', function(player, ent, tbl)
    local pages = tbl[1];
    local info = tbl[2]
    local char = player:GetCharacter();
    local inv = char:GetInventory()

    for k, v in pairs(pages) do
        pages[k]['info'] = pages[k]['info']:gsub('<', "&lt;" ):gsub('>', '&gt;')
        pages[k]['info'] = pages[k]['info']:gsub("%[(/?)([bius])%]", "<%1%2>"):gsub("%[(/?)(h[r1-3])%]", "<%1%2>")
        pages[k]['info'] = pages[k]['info']:gsub('\n', "<br />")
        pages[k]['info'] = pages[k]['info']:gsub('%[color="(#?[0-9a-zA-Z]+)"%]', '<font color=\\\"%1\\\">' ):gsub("%[/color%]", "</font>")
    end;
    
    print(ent.id)

    if IsEntity( ent ) && ent:GetClass() == 'ix_item' then
        ent:GetNetVar('data')['Pages'] = pages;
        ent:GetNetVar('data')['NoteInfo'] = info;
    elseif istable( ent ) then
        local notepadItem = inv:GetItemByID(tonumber(ent.id))
        if notepadItem && notepadItem.base == "base_notepad" then
            notepadItem:SetData('Pages', pages)
            notepadItem:SetData('NoteInfo', info)
        end;
    end;

end);


function PLUGIN:CanPlayerTakeItem(client, item)
    if item.base == "base_notepad" then
        return item:GetData('NoteInfo')['canpickup'];
    end;
end