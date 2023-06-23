ITEM.name = "Yummy skull"
ITEM.model = "models/Gibs/HGIBS.mdl"
ITEM.description = "You can eat it!"
ITEM.width = 1
ITEM.height = 1
ITEM.price = 0
ITEM.category = "Food"

ITEM.functions._eat = {
	name = "Eat",
	onRun = function(item)
			item.player:EmitSound("vo/sandwicheat09.mp3")			
	end,
}