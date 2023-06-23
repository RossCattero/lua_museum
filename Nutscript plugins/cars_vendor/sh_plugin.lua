local PLUGIN = PLUGIN
PLUGIN.name = "Cars vendor"
PLUGIN.author = "Ross Cattero"
PLUGIN.desc = "Cars vendor system. Working only with symfphys cars."

for k, v in pairs(file.Find(PLUGIN.folder.."/meta/*", "LUA")) do
	nut.util.include( "meta/" .. v )
end
nut.car_vendor.Load(PLUGIN.folder .. "/cars")

nut.util.include("sv_access_rules.lua")
nut.util.include( "sv_plugin.lua" )