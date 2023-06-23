local PLUGIN = PLUGIN;

function PLUGIN:PlayerLoadedCharacter(client, character, prev)
    timer.Simple(0.25, function()
        character:SetData("Medals", character:GetData("Medals", {}));

        client:SetNetVar( "Medals", character:GetData("Medals", {}) )
    end)
end

function PLUGIN:CharacterPreSave(character)
    local client = character:GetPlayer()
    if (IsValid(client)) then
        character:SetData("Medals", character:GetData("Medals", {}))
    end
end
