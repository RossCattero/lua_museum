
ITEM.name = "СЕВА долга"
ITEM.description = "Тяжелый скафандр долга. Пригодится, если нужна средняя защита и хорошая защита от разных воздействий."
ITEM.category = "Одежда"
ITEM.model = "models/kek1ch/dolg_scientific_outfit.mdl"
ITEM.weight = 0.9;
ITEM.width = 2
ITEM.height = 2
ITEM.outfitCategory = 'Torso'
ITEM.OnGetReplacement = function(self, client)
    if client:IsFemale() then
        return "models/stalker_roleplay/seva/seva_duty_f.mdl"
    end;
    return "models/stalker_roleplay/seva/seva_duty.mdl"
end;
ITEM.armorType = 'medium'
ITEM.additionalWeight = 8;
ITEM.outfitInformation = {
    ["Радиация"] = 70,
    ["Токсины"] = 60,
    ["Электричество"] = 60,
    ["Температура"] = 60,
    ['Пси-защита'] = 50,
    ['Порез'] = 60,
    ['Гашение урона'] = 60,
    ['Повышение выносливости'] = 20
}
ITEM.maskOverlay = true;