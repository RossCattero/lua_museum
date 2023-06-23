local PLUGIN = PLUGIN;

function PLUGIN:PlayerLoadedCharacter(client, character, prev)
    timer.Simple(0.25, function()
        client:FormLimbsData()
        client:FormBonesData()
    end)
end

function PLUGIN:CharacterPreSave(character)
    local client = character:GetPlayer()
    if (IsValid(client)) then
        character:SetData("Limbs", character:GetData("Limbs"))
        character:SetData("LimbsCopy", character:GetData("LimbsCopy"))
    end
end

function PLUGIN:PlayerSetHandsModel( ply, ent )
   ply:FormLimbsData()
end