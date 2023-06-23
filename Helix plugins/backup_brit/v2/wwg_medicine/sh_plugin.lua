PLUGIN.name = 'WWG - Medical'
PLUGIN.author = 'Werwolf Contrator: Ross'
PLUGIN.description = ''

ix.util.Include("cl_plugin.lua")
ix.util.Include("sv_plugin.lua")
ix.util.Include("sv_data.lua")

for k, v in pairs(file.Find(PLUGIN.folder.."/meta/*", "LUA")) do
	ix.util.Include( "meta/" .. v )
end
ix.medical.LoadFromDir(PLUGIN.folder .. "/wounds")