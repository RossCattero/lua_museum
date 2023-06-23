local PLUGIN = PLUGIN

function PLUGIN:PlayerLoadedCharacter(client, character, prev)
    timer.Simple(0.25, function()
		// Points - база для хранения баффов и дебаффов;
		character:SetData("Points", character:GetData("Points", {}))
		client:SetLocalVar("Points", character:GetData("Points", {}))
    end)
end
function PLUGIN:CharacterPreSave(character)
    local client = character:GetPlayer()
    if (IsValid(client)) then
        character:SetData("Points", character:GetData("Points"))
    end
end
