local PLUGIN = PLUGIN;

function PLUGIN:PlayerLoadedCharacter(client, character, prev)
    timer.Simple(0.25, function()
        client:FormLimbsData()
        client:FormBonesData()
        client:SetLocalVar("_model", client:GetModel())
    end)
end

function PLUGIN:CharacterPreSave(character)
    local client = character:GetPlayer()
    if (IsValid(client)) then
        character:SetData("Limbs", character:GetData("Limbs"))
    end
end

function PLUGIN:PlayerSetHandsModel( ply, ent )
    local character = ply:GetCharacter();
    local model = ply:GetModel()
    if model != ply:GetLocalVar("_model", "") then
        ply:FormLimbsData()
        ply:FormBonesData()
		ply:ResetInjuries(true, true)

        ply:SetLocalVar("_model", ply:GetModel())
    end
end