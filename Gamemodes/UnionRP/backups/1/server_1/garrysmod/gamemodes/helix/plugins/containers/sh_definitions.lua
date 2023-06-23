--[[
	ix.container.Register(model, {
		name = "Crate",
		description = "A simple wooden create.",
		width = 4,
		height = 4,
		locksound = "",
		opensound = ""
	})
]]--

ix.container.Register("models/props_junk/wood_crate001a.mdl", {
	name = "Crate",
	description = "A simple wooden crate.",
	width = 4,
	height = 4,
})

ix.container.Register("models/props_c17/lockers001a.mdl", {
	name = "Locker",
	description = "A white locker.",
	width = 3,
	height = 5,
})

ix.container.Register("models/props_wasteland/controlroom_storagecloset001a.mdl", {
	name = "Metal Cabinet",
	description = "A green metal cabinet.",
	width = 4,
	height = 5,
})

ix.container.Register("models/props_wasteland/controlroom_storagecloset001b.mdl", {
	name = "Metal Cabinet",
	description = "A green metal cabinet.",
	width = 4,
	height = 5,
})

ix.container.Register("models/props_wasteland/controlroom_filecabinet001a.mdl", {
	name = "File Cabinet",
	description = "A metal filing cabinet.",
	width = 5,
	height = 3
})

ix.container.Register("models/props_wasteland/controlroom_filecabinet002a.mdl", {
	name = "File Cabinet",
	description = "A metal filing cabinet.",
	width = 3,
	height = 6,
})

ix.container.Register("models/props_lab/filecabinet02.mdl", {
	name = "File Cabinet",
	description = "A metal filing cabinet.",
	width = 5,
	height = 3
})

ix.container.Register("models/props_c17/furniturefridge001a.mdl", {
	name = "Refrigerator",
	description = "A metal box for keeping food in.",
	width = 2,
	height = 3,
})

ix.container.Register("models/props_wasteland/kitchen_fridge001a.mdl", {
	name = "Large Refrigerator",
	description = "A large metal box for storing even more food in.",
	width = 4,
	height = 5,
})

ix.container.Register("models/props_junk/trashbin01a.mdl", {
	name = "Trash Bin",
	description = "What do you expect to find in here?",
	width = 2,
	height = 2,
})

ix.container.Register("models/props_junk/trashdumpster01a.mdl", {
	name = "Dumpster",
	description = "A dumpster meant to stow away trash. It emanates an unpleasant smell.",
	width = 6,
	height = 3
})

ix.container.Register("models/items/ammocrate_smg1.mdl", {
	name = "Ammo Crate",
	description = "A heavy crate that stores ammo.",
	width = 5,
	height = 3,
	OnOpen = function(entity, activator)
		local closeSeq = entity:LookupSequence("Close")
		entity:ResetSequence(closeSeq)

		timer.Simple(2, function()
			if (entity and IsValid(entity)) then
				local openSeq = entity:LookupSequence("Open")
				entity:ResetSequence(openSeq)
			end
		end)
	end
})

ix.container.Register("models/props_forest/footlocker01_closed.mdl", {
	name = "Footlocker",
	description = "A small chest to store belongings in.",
	width = 5,
	height = 3
})

ix.container.Register("models/Items/item_item_crate.mdl", {
	name = "Item Crate",
	description = "A crate to store some belongings in.",
	width = 5,
	height = 3
})

ix.container.Register("models/props_c17/cashregister01a.mdl", {
	name = "Cash Register",
	description = "A register with some buttons and a drawer.",
	width = 2,
	height = 1
})

--[[
	models/props/rpd/metal_cabinet.mdl – для оружия, размер - большой
models/props/hospital/largecabinet.mdl – для медикаментов, размер - большой
models/props/hospital/smallcabinet.mdl – для медикаментов, размер - небольшой
models/mark2580/gtav/garage_stuff/tools_cabinet_02.mdl – для инструментов, размер - большой
models/mark2580/gtav/garage_stuff/tools_cabinet_01.mdl  – для инструментов, размер - большой
models/mark2580/gtav/garage_stuff/tool_cabinet_01b.mdl – для инструментов, размер -маленький
models/props_junk/cardboard_box001a.mdl – коробка картонная, размер -средняя
models/props_junk/cardboard_box004a.mdl – коробочка картонная, размер - маленькая
models/props_junk/cardboard_box003a.mdl – коробка картонная, размер - средняя
models/props_junk/cardboard_box003b.mdl – коробка картонная, размер -  средняя
models/props_junk/cardboard_box002a.mdl – коробка картонная, размер - большая
models/props_office/file_cabinet_03.mdl – архив, размер - средний
models/props_interiors/refrigerator03.mdl – холодильник, размер - средний
]]

ix.container.Register("models/props/rpd/metal_cabinet.mdl", {
	name = "Оружейный ящик",
	description = "",
	width = 10,
	height = 10
})

ix.container.Register("models/props/hospital/largecabinet.mdl", {
	name = "Медицинский ящик",
	description = "",
	width = 8,
	height = 8
})

ix.container.Register("models/props/hospital/smallcabinet.mdl", {
	name = "Медицинский ящик",
	description = "",
	width = 5,
	height = 5
})

ix.container.Register("models/mark2580/gtav/garage_stuff/tools_cabinet_02.mdl", {
	name = "Ящик для инструментов",
	description = "",
	width = 2,
	height = 1
})

ix.container.Register("models/mark2580/gtav/garage_stuff/tools_cabinet_01.mdl", {
	name = "Ящик для инструментов",
	description = "",
	width = 2,
	height = 1
})

ix.container.Register("models/mark2580/gtav/garage_stuff/tool_cabinet_01b.mdl", {
	name = "Ящик для инструментов",
	description = "",
	width = 2,
	height = 1
})

ix.container.Register("models/props_junk/cardboard_box001a.md", {
	name = "Картонная коробка",
	description = "",
	width = 8,
	height = 8
})

ix.container.Register("models/props_junk/cardboard_box004a.mdl", {
	name = "Картонная коробка",
	description = "",
	width = 4,
	height = 4
})

ix.container.Register("models/props_junk/cardboard_box003a.mdl", {
	name = "Картонная коробка",
	description = "",
	width = 8,
	height = 8
})

ix.container.Register("models/props_junk/cardboard_box003b.mdl", {
	name = "Картонная коробка",
	description = "",
	width = 8,
	height = 8
})

ix.container.Register("models/props_junk/cardboard_box002a.mdl", {
	name = "Картонная коробка",
	description = "",
	width = 12,
	height = 12
})

ix.container.Register("models/props_office/file_cabinet_03.mdl", {
	name = "Архив",
	description = "",
	width = 8,
	height = 8
})

ix.container.Register("models/props_interiors/refrigerator03.mdl", {
	name = "Холодильник",
	description = "",
	width = 5,
	height = 5
})