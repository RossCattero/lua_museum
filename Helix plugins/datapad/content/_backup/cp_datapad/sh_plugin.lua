local PLUGIN = PLUGIN

PLUGIN.name = "CCA data > datapad"
PLUGIN.author = "Ross Cattero"
PLUGIN.description = "CCA datapad for viewing citizen and CCA data."

ix.util.Include("cl_fonts.lua")
ix.util.Include("sh_commands.lua")
ix.util.Include("sv_plugin.lua")

if SERVER then
    resource.AddFile( "resource/fonts/ibmfont.ttf" )
end;