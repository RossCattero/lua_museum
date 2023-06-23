local PLUGIN = PLUGIN

PLUGIN.name = "CCA data > Main"
PLUGIN.author = "Ross Cattero"
PLUGIN.description = "Main data processing plugin for CCA datapad ecosystem."

for _, v in pairs(file.Find(PLUGIN.folder.."/meta/*", "LUA")) do
	ix.util.Include( "meta/" .. v )
end

ix.util.Include("sv_plugin.lua")