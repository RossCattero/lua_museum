--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).

	Clockwork was created by Conna Wiles (also known as kurozael.)
	http://cloudsixteen.com/license/clockwork.html
--]]

--[[
	You don't have to do this, but I think it's nicer.
	Alternatively, you can simply use the PLUGIN variable.
--]]
PLUGIN:SetGlobalAlias("cwStorage");

--[[ You don't have to do this either, but I prefer to separate the functions. --]]
Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");
Clockwork.kernel:IncludePrefixed("cl_hooks.lua");

cwStorage.containerList = {
	["models/props_wasteland/controlroom_storagecloset001a.mdl"] = {8, "Железный шкаф"},
	["models/props_wasteland/controlroom_storagecloset001b.mdl"] = {15, "Железный шкаф"},
	["models/props_wasteland/controlroom_filecabinet001a.mdl"] = {4, "Железный ящик"},
	["models/props_wasteland/controlroom_filecabinet002a.mdl"] = {8, "Картотека"},
	["models/props_c17/suitcase_passenger_physics.mdl"] = {5, "Чемодан"},
	["models/props_junk/wood_crate001a_damagedmax.mdl"] = {8, "Деревянный ящик"},
	["models/props_junk/wood_crate001a_damaged.mdl"] = {8, "Деревянный ящик"},
	["models/props_interiors/furniture_desk01a.mdl"] = {4, "Стол"},
	["models/props_c17/furnituredresser001a.mdl"] = {10, "Шкаф"},
	["models/props_c17/furnituredrawer001a.mdl"] = {8, "Комод"},
	["models/props_c17/furnituredrawer002a.mdl"] = {4, "Комод"},
	["models/props_c17/furniturefridge001a.mdl"] = {8, "Холодильник"},
	["models/props_c17/furnituredrawer003a.mdl"] = {8, "Компактный комод"},
	["models/weapons/w_suitcase_passenger.mdl"] = {5, "Чемодан"},
	["models/props_junk/trashdumpster01a.mdl"] = {15, "Мусорный бак"},
	["models/props_junk/wood_crate001a.mdl"] = {8, "Деревянный ящик"},
	["models/props_junk/wood_crate002a.mdl"] = {10, "Деревянный ящик"},
	["models/items/ammocrate_rockets.mdl"] = {15, "Оружейниый ящик"},
	["models/props_lab/filecabinet02.mdl"] = {8, "Железный ящик"},
	["models/items/ammocrate_grenade.mdl"] = {15, "Оружейниый ящик"},
	["models/props_junk/trashbin01a.mdl"] = {10, "Мусорное ведро"},
	["models/props_c17/suitcase001a.mdl"] = {8, "Чемодан"},
	["models/items/item_item_crate.mdl"] = {4, "Ящик"},
	["models/props_c17/oildrum001.mdl"] = {8, "Бочка"},
	["models/items/ammocrate_smg1.mdl"] = {15, "Оружейниый ящик"},
	["models/items/ammocrate_ar2.mdl"] = {15, "Оружейниый ящик"},
	["models/props_c17/FurnitureFireplace001a.mdl"] = {5, "Печь"},
	["models/props_office/pictureframe04.mdl"] = {6, "Тайник"},
	["models/props/cs_office/trash_can_p.mdl"] = {3, "Мусорное ведро"},
	["models/props/cs_office/cardboard_box02.mdl"] = {4, "Коробка"},
	["models/props_office/metalbin01.mdl"] = {4, "Мусорное ведро"},
	["models/props_generic/trashbin002.mdl"] = {4, "Мусорное ведро"}
};