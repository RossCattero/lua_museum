
ITEM.name = "Артефакт"
ITEM.description = "Артефакт"
ITEM.category = "Артефакты"
ITEM.model = "models/Gibs/HGIBS.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.radSec = 1
ITEM.weight = 0.5

ITEM.functions.InsertArtefact = {
    name = "Положить артефакт в контейнер",
    OnRun = function(item)
        local player = item.player; local character = player:GetCharacter();
        local inv = character:GetInventory();
        local container = inv:HasItem('artcontainer')

        container:SetData('Artefact', item.uniqueID)
        container.name = "Закрытый контейнер"
        container.model = "models/kek1ch/lead_box_closed.mdl"
        player:GetCharacter():RemoveCarry(item)
        return true;
    end,
    OnCanRun = function(item)
        local containter = item.player:GetCharacter():GetInventory():HasItem('artcontainer');
        return containter && (containter:GetData('Artefact') == nil or containter:GetData('Artefact') == "");
    end
}