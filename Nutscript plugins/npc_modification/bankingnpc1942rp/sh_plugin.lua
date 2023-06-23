local PLUGIN = PLUGIN
PLUGIN.name = "Banking > NPC > 1942rp"
PLUGIN.author = "Ross Cattero"
PLUGIN.desc = "NPC banking plugin for 1942rp style"

nut.util.include("cl_plugin.lua")
nut.util.include("sh_msgs.lua")
nut.util.include("sv_plugin.lua")

// Model list for banking NPCs
PLUGIN.modelList = {}
for i = 1, 9 do
		PLUGIN.modelList[i] = "models/Humans/Group01/Male_0"..i..".mdl"
end