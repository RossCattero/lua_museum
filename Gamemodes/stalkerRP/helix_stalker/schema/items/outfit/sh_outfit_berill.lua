
ITEM.name = "Бронежилет 'Берилл'"
ITEM.description = "Военный бронежилет, обеспечивающий своего носителя сопротивлению к некоторым видам урона."
ITEM.category = "Одежда"
ITEM.model = "models/kek1ch/spec_sold_outfit.mdl"
ITEM.weight = 0.9;
ITEM.width = 2
ITEM.height = 2
ITEM.outfitCategory = 'Torso'
ITEM.additionalWeight = 4;
ITEM.bodyGroups = {
	["Torso"] = 7
}
ITEM.armorType = 'medium'
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