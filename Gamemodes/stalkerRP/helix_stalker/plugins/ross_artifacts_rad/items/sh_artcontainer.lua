ITEM.name = "Контейнер для артефактов"
ITEM.description = "Старенький контейнер для артефактов, предположительно, из свинца."
ITEM.model = "models/kek1ch/lead_box_open.mdl"
ITEM.weight = 1 
ITEM.height = 2 
ITEM.width = 1
ITEM.uniqueID = 'artcontainer'

ITEM.functions.TakeArtefact = {
    name = "Достать артефакт",
    OnRun = function(item)
        local player = item.player; local character = player:GetCharacter();
        local inv = character:GetInventory();
        inv:Add(item:GetData('Artefact'))
        item:SetData('Artefact', "")
        item.name = "Контейнер для артефактов"
        item.model = "models/kek1ch/lead_box_open.mdl"
        return false;
    end,
    OnCanRun = function(item)
        return item:GetData('Artefact') != nil && item:GetData('Artefact') != "" && !IsValid(item.entity)
    end
}

function ITEM:OnInstantized()
    if !self:GetData('Artefact') then
        self:SetData('Artefact', "")
    end;
end;


if CLIENT then
    function ITEM:GetModel()
        if self:GetData('Artefact') != nil && self:GetData('Artefact') != "" then
            return "models/kek1ch/lead_box_closed.mdl"
        end;
        return "models/kek1ch/lead_box_open.mdl"
    end;    
    function ITEM:GetName()
        if self:GetData('Artefact') != nil && self:GetData('Artefact') != "" then
            return "Закрытый контейнер"
        end;
        return "Контейнер для артефактов"
    end;
end;