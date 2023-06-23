
ITEM.name = "Бронекостюм 'СКАТ'"
ITEM.description = "Тяжелый военный бронежилет с дополнительной защитой от разных типов урона."
ITEM.category = "Одежда"
ITEM.model = "models/kek1ch/stalker_comander_suit.mdl"
ITEM.weight = 1.4;
ITEM.width = 2
ITEM.height = 2
ITEM.outfitCategory = 'Torso'
ITEM.armorType = 'hard'
ITEM.additionalWeight = 6;
ITEM.bodyGroups = {
	["Torso"] = 8
}
ITEM.outfitInformation = {
    ["Радиация"] = 50, -- Защита от радиации
    ["Токсины"] = 25, -- Защита от токсинов
    ["Электричество"] = 50, -- Электроизоляция
    ["Температура"] = 35, -- Термоизоляция
    ['Пси-защита'] = 0, -- Пси защита
    ['Порез'] = 80, -- Защита от пореза
    ['Гашение урона'] = 80, -- Гашение урона(от пуль, ударов похоже)
    ['Повышение выносливости'] = 10 -- Выносливость
}