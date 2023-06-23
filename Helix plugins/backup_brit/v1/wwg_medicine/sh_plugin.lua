PLUGIN.name = 'WWG - Medical'
PLUGIN.author = 'Werwolf Contrator: Ross'
PLUGIN.description = ''

ix.util.Include("sv_plugin.lua")

local modPath = PLUGIN.folder.."/modules";
local _, modules = file.Find(modPath.."/*", "LUA")

for k, v in pairs(modules) do
	ix.plugin.LoadFromDir(modPath.."/"..v)
end

ix.util.Include("meta/sh_wound.lua")
ix.util.Include("meta/sv_entity.lua")