local PLUGIN = PLUGIN

PLUGIN.name = "Medal plugin"
PLUGIN.author = "Ross Cattero"
PLUGIN.description = "Adds medals for characters."

ix.util.Include("cl_plugin.lua")
ix.util.Include("sh_commands.lua")
ix.util.Include("sv_plugin.lua")

ix.flag.Add("Z", "Flag for permitting a medals to certan characters")