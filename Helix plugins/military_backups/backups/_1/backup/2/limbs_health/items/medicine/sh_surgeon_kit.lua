ITEM.name = "Набор для зашивания ран"
ITEM.description = ""
ITEM.model = "models/kek1ch/dev_med_bag.mdl"

ITEM.parameters = {
	category = "surgeon",
	blood = 0,
	pain = -50, 
	painMin = -50,
	shock = 0,
	inf = 100,
	sick = {},
	amount = 10,
	bonuses = {},
	canHeal = {
		[DMG_SLASH] = 1,
	},
	healTime = 1,
	healAmount = 100,
	useTime = 12,
	stopBleeding = true,
}