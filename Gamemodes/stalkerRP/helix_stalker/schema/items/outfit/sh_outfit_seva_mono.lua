
ITEM.name = "СЕВА монолита"
ITEM.description = "Тяжелый скафандр монолита. Пригодится, если нужна средняя защита и хорошая защита от разных воздействий."
ITEM.category = "Одежда"
ITEM.model = "models/kek1ch/monolith_scientific_outfit.mdl"
ITEM.weight = 0.9;
ITEM.width = 2
ITEM.height = 2
ITEM.outfitCategory = 'Torso'
ITEM.OnGetReplacement = function(self, client)
    if client:IsFemale() then
        return "models/stalker_roleplay/seva/seva_mono_f.mdl"
    end;
    return "models/stalker_roleplay/seva/seva_mono.mdl"
end;
ITEM.armorType = 'seva'
ITEM.additionalWeight = 10;
ITEM.outfitInformation = {
    ["Радиация"] = 100,
    ["Токсины"] = 80,
    ["Электричество"] = 80,
    ["Температура"] = 80,
    ['Пси-защита'] = 80,
    ['Порез'] = 60,
    ['Гашение урона'] = 60,
    ['Повышение выносливости'] = 30
}
ITEM.maskOverlay = true;