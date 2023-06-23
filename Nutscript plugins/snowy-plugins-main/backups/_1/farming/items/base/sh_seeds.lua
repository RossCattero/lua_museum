ITEM.name = "Default seeds"
ITEM.model = "models/props_lab/box01a.mdl"
ITEM.description = "Default seeds"
ITEM.width = 1
ITEM.height = 1
ITEM.price = 0
ITEM.category = "Farming"
ITEM.plantTime = 10 // Time in seconds to grow a plant.
ITEM.seedResult = {
	["yummy"] = 1
} // Result after the plant is grown
ITEM.seedGrow = {
	["20"] = "models/nater/weedplant_pot_growing1.mdl",
	["40"] = "models/nater/weedplant_pot_growing3.mdl",
	["60"] = "models/nater/weedplant_pot_growing4.mdl",
	["80"] = "models/nater/weedplant_pot_growing5.mdl",
	["100"] = "models/nater/weedplant_pot_growing7.mdl",
} 
// Model change on each stage.
// The ["20"] - number is percent of growing.
// The = "" - model string.