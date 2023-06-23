
ITEM.name = "СЕВА наемников"
ITEM.description = "Тяжелый скафандр наемников. Пригодится, если нужна средняя защита и хорошая защита от разных воздействий."
ITEM.category = "Одежда"
ITEM.model = "models/kek1ch/scientific_outfit_merc.mdl"
ITEM.weight = 0.9;
ITEM.width = 2
ITEM.height = 2
ITEM.outfitCategory = 'Torso'
ITEM.OnGetReplacement = function(self, client)
    if client:IsFemale() then
        return "models/stalker_roleplay/seva/seva_killer_f.mdl"
    end;
    return "models/stalker_roleplay/seva/seva_killer.mdl"
end;
ITEM.armorType = 'seva'
ITEM.additionalWeight = 7;
ITEM.outfitInformation = {
    ["Радиация"] = 55,
    ["Токсины"] = 55,
    ["Электричество"] = 55,
    ["Температура"] = 55,
    ['Пси-защита'] = 60,
    ['Порез'] = 60,
    ['Гашение урона'] = 65,
    ['Повышение выносливости'] = 30
}
ITEM.maskOverlay = true;