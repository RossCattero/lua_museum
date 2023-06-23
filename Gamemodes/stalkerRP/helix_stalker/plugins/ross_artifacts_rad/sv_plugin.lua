local ply = FindMetaTable("Player")

function ply:CheckGeiger()
    local char = self:GetCharacter()
    if char:GetInventory():HasItem('rad_geiger') then
        self:EmitSound('stalker/detectors/geiger_'..math.random(1, 8)..'.mp3')
    end;
end;

function ply:SetRadiation(number)
    local char = self:GetCharacter()
    self:SetLocalVar('radiation', number);
    char:SetData('radiation', number);
end;

function PLUGIN:OnCharacterCreated(client, character)
    character:SetData("radiation", 0)
end

function PLUGIN:PlayerLoadedCharacter(client, character)
    timer.Simple(0.25, function()
        client:SetLocalVar("radiation", character:GetData("radiation", 0))
    end)
end

function PLUGIN:CharacterPreSave(character)
    local client = character:GetPlayer()

    if (IsValid(client)) then
        character:SetData("radiation", client:GetLocalVar("radiation", 0))
    end
end

function PLUGIN:PlayerPostThink( player )
    local char = player:GetCharacter()
    local plyArea = (ix.area.stored[player:GetArea()] or {});
    
    if char && player:Alive() then
        if !player.RadiationTick or CurTime() >= player.RadiationTick then
            player.RadiationTick = CurTime() + 2;
            local rad = player:GetLocalVar('radiation', 0)
            local protTable = player:GetLocalVar('ProtectionTable')
            local addRad = 0;
            for k, v in pairs(char:GetInventory():GetItemsByBase("base_afterfacts")) do
                addRad = addRad + v.radSec
            end;
            player:SetRadiation(math.Clamp( rad + addRad, 0, 1000 ))
            if plyArea && plyArea.type == 'Радиация' then
                local numberInfo = math.Clamp(plyArea.properties.level - math.Round(protTable["Радиация"]/10), 0, 100)
                player:SetRadiation(math.Clamp( rad + numberInfo, 0, 1000 ))
            end;

            if math.random(100) < rad/10 then
                player:SetHealth( player:Health() - 1, 0, player:GetMaxHealth() )
                if player:Health() == 0 then
                    player:Kill()
                end;
            end;
            
            if rad > 0 then
                player:CheckGeiger()
            end;
        end;
    end;
end;