function PLUGIN:PlayerLoadedCharacter(client, character)
	timer.Simple(.25, function()
        character:SetCID(character:GetCID())
	end);
end;

-- function PLUGIN:CharacterDeleted(client, id, isCurrentChar)

-- end;

function PLUGIN:LoadData()
    ix.cdata.Load()
end;