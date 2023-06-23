local PLUGIN = PLUGIN

PLUGIN.recipeList = {
	--[[
	recipe def:
	["uniqueID"] = {
		name = the name,
		desc = the desc,
		category = the category to file it under,
		model = model to display,
		skin = skin of model (not required),
		workbench = table of workbench ids ({["basic"] = true,},)
		attribs = { --attrib requirements
			["id"] = min needed,
		},
		traits = { --traits requirements
			["id"] = min level needed or true for no level ones,
		},
		requirements = { --require for items that will not be taken
			["requireuniqueid"] = true, --or # of needed,
		},
		ingredients = { --items that will be taken
			["ingreduniqueid"] = true, --or # of needed,
		},
		result = "result", --can also be table for multiple results
		flag = "", --optional can be left out, flag to check for
		handpick = function(items)
			--return an item id from the list of items and that id will get passed into beforeCraft
		end,
		beforeCraft = function(ply, items, handpick)
			--items are the items that will be taken, 
			--handpick is the item id gotten from handpick, it will be nil if this wasnt done
			--return a table and it will reappear in oncreate as data
		end,
		adddata = true, --this will set the data returned in beforeCraft on the result item
		onCreate = function(ply, item, data) 
			--to do something when created such as transfer data
		end,
		timed = {
			action = "the action to display during timed action",
			time = 0, --length of the action
		},
		--jobRequire = true, --special thing for crafting job keeping
	},
	]]
	--basic stuff
	["test_craftableitem"] = {
		name = "Test Item",
		desc = [[A test item]],
		category = "Carbonite Armor",
		model = "models/modified/mask6.mdl",
		workbench = {["basic"]=true,},
		requirements = { --require for items that will not be taken
			["test_blueprint"] = true, --or # of needed,
		},
		ingredients = { --items that will be taken
			["test_ingre1"] = 1, --or # of needed,
		},
		result = "test_craftableitem", --can also be table for multiple results
	},
}