ITEM.name = "Тряпка"
ITEM.description = ""
ITEM.model = "models/illusion/eftcontainers/bandage.mdl"

ITEM.parameters = {
	category = "ban",
	blood = 0,
	pain = -50, 
	painMin = -50,
	shock = 50,
	inf = 100,
	sick = {},
	amount = 1,
	bonuses = {},
	canHeal = {
		[DMG_SLASH] = 1,
		[DMG_BULLET] = 1
	},
	healTime = 60,
	healAmount = 5,
	useTime = 1,
	stopBleeding = true,
}