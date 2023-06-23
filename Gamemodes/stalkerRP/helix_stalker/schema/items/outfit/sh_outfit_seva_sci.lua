
ITEM.name = "СЕВА ученых"
ITEM.description = "Тяжелый скафандр ученых. Пригодится, если нужна средняя защита и хорошая защита от разных воздействий."
ITEM.category = "Одежда"
ITEM.model = "models/kek1ch/scientific_outfit.mdl"
ITEM.weight = 0.9;
ITEM.width = 2
ITEM.height = 2
ITEM.outfitCategory = 'Torso'
ITEM.OnGetReplacement = function(self, client)
    if client:IsFemale() then
        return "models/stalker_roleplay/seva/seva_sci_f.mdl"
    end;
    return "models/stalker_roleplay/seva/seva_sci.mdl"
end;
ITEM.armorType = 'medium'
ITEM.additionalWeight = 8;
ITEM.outfitInformation = {
    ["Радиация"] = 80,
    ["Токсины"] = 80,
    ["Электричество"] = 80,
    ["Температура"] = 80,
    ['Пси-защита'] = 80,
    ['Порез'] = 50,
    ['Гашение урона'] = 50,
    ['Повышение выносливости'] = 50
}
ITEM.maskOverlay = true;