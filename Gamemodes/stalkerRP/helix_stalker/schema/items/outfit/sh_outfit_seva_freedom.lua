
ITEM.name = "СЕВА свободы"
ITEM.description = "Тяжелый скафандр свободы. Пригодится, если нужна средняя защита и хорошая защита от разных воздействий."
ITEM.category = "Одежда"
ITEM.model = "models/kek1ch/svoboda_scientific_outfit.mdl"
ITEM.weight = 0.9;
ITEM.width = 2
ITEM.height = 2
ITEM.outfitCategory = 'Torso'
ITEM.OnGetReplacement = function(self, client)
    if client:IsFemale() then
        return "models/stalker_roleplay/seva/seva_freedom_f.mdl"
    end;
    return "models/stalker_roleplay/seva/seva_freedom.mdl"
end;
ITEM.armorType = 'medium'
ITEM.additionalWeight = 8;
ITEM.outfitInformation = {
    ["Радиация"] = 70,
    ["Токсины"] = 60,
    ["Электричество"] = 60,
    ["Температура"] = 60,
    ['Пси-защита'] = 50,
    ['Порез'] = 50,
    ['Гашение урона'] = 50,
    ['Повышение выносливости'] = 20
}
ITEM.maskOverlay = true;