local defaultTbl = {
    ["Радиация"] = 0,
    ["Токсины"] = 0,
    ["Электричество"] = 0,
    ["Температура"] = 0,
    ["Пси-защита"] = 0,
    ["Порез"] = 0,
    ["Гашение урона"] = 0,
    ["Повышение выносливости"] = 0
}

function Schema:OnCharacterCreated(client, character)
    character:SetData("ProtectionTable", defaultTbl)
    character:SetData("Mask_overlay", "")
end

function Schema:PlayerLoadedCharacter(client, character)
    timer.Simple(0.25, function()
        client:SetLocalVar("ProtectionTable", character:GetData("ProtectionTable", defaultTbl))
        client:SetLocalVar("Mask_overlay", character:GetData("Mask_overlay", ""))
    end)
end

function Schema:CharacterPreSave(character)
    local client = character:GetPlayer()
    if (IsValid(client)) then
        character:SetData("ProtectionTable", client:GetLocalVar("ProtectionTable", defaultTbl))
        character:SetData("Mask_overlay", client:GetLocalVar("Mask_overlay", ""))
    end
end