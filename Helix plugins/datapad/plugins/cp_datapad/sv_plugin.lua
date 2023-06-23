-- Add font for download
resource.AddFile( "resource/fonts/ibmfont.ttf" )

-- Hook name change to update it on serverside;
ix.char.HookVar("name", "ix.datapad.hook.var.name", function(targetCharacter, prevName, newName)
    if prevName == newName then
        return;
    end;

    local characterID = targetCharacter:GetID();
    local archived = ix.archive.Get(characterID)
    if archived then
        archived:SetName(newName)
    end;
end)