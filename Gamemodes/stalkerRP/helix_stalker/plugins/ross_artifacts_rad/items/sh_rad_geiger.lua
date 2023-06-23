ITEM.name = "Счетчик гейгера"
ITEM.description = "Счетчик, предназначенный для выявления радиационного излучения."
ITEM.model = "models/kek1ch/dev_datchik1.mdl"
ITEM.weight = 0.2
ITEM.category = 'Прочее'

ITEM.functions.CheckRad = {
    name = "Проверить себя",
    OnRun = function(item)
     local player = item.player;
    player:EmitSound('stalker/interface/inv_slot.mp3')
    player:Notify('Ваш радиационный фон: '..player:GetLocalVar('radiation').." МзВ")
     return false;
    end
}