local PLUGIN = PLUGIN
PLUGIN.name = "Missions"
PLUGIN.author = "Ross Cattero"
PLUGIN.desc = "A missions system."

for k, v in pairs(file.Find(PLUGIN.folder.."/meta/*", "LUA")) do
	nut.util.include( "meta/" .. v )
end
nut.mission.Load(PLUGIN.folder .. "/missions")

nut.util.include("cl_plugin.lua")
nut.util.include("sv_plugin.lua")