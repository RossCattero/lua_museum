local PLUGIN = PLUGIN

PLUGIN.name = "CCA data > Misc"
PLUGIN.author = "Ross Cattero"
PLUGIN.description = "Ranks and certifications for cp data ecosystem."

for _, v in pairs(file.Find(PLUGIN.folder.."/meta/*", "LUA")) do
	ix.util.Include( "meta/" .. v )
end

ix.ranks.LoadFromDir(PLUGIN.folder .. "/ranks")
ix.certifications.LoadFromDir(PLUGIN.folder .. "/certifications")

ix.util.Include("sh_commands.lua")
ix.util.Include("sv_plugin.lua")