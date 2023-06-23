
ITEM.name = "Налобный фонарик"
ITEM.model = Model("models/kek1ch/dev_torch_light.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "Налобный фонарик, необходимый для освещения темных пространств."
ITEM.category = "Прочее"

ITEM:Hook("drop", function(item)
	item.player:Flashlight(false)
end)
