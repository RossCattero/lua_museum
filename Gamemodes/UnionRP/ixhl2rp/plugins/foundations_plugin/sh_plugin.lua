local PLUGIN = PLUGIN

PLUGIN.name = "Система производств"
PLUGIN.author = "Ross"
PLUGIN.description = ""

ix.util.Include("sv_plugin.lua")
ix.util.Include("cl_plugin.lua")

ix.container.Register("models/container_m.mdl", {
	name = "Мусорный контейнер",
	description = "",
	width = 10,
	height = 10,
})