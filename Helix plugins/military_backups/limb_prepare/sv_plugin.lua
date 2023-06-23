local PLUGIN = PLUGIN;

function PLUGIN:PlayerLoadedCharacter(client, character, prev)
    timer.Simple(0.25, function()
        client:FormLimbsData()
        client:FormBonesData()

        character:SetData("_model", client:GetModel())
    end)
end

function PLUGIN:CharacterPreSave(character)
    local client = character:GetPlayer()
    if (IsValid(client)) then
        character:SetData("Limbs", character:GetData("Limbs"))
        character:SetData("Limbs_med", character:GetData("Limbs_med"))
    end
end

function PLUGIN:PlayerSetHandsModel( ply, ent )
    local character = ply:GetCharacter();
    local model = ply:GetModel()
    if model != character:GetData("_model", "") then
        ply:FormLimbsData()
        character:SetData("_model", ply:GetModel())
    end
end