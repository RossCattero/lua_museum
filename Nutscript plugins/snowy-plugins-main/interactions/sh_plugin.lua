local PLUGIN = PLUGIN
PLUGIN.name = "Interactions"
PLUGIN.author = "Ross Cattero"
PLUGIN.desc = "More interactions"

function PLUGIN:DrawCharInfo(client, char, info)
	local cuff = client:getNetVar("cuffed")

	if (cuff) then
		info[#info + 1] = {"This character is cuffed", Color(255, 100, 100)}
	end
end

function PLUGIN:InitializedPlugins() // Disabling the tying plugin to remove any problems related to it
		if nut.plugin.list["tying"] then
				nut.plugin.setDisabled("tying", true)
		end
end;

nut.util.include("sv_plugin.lua")
nut.util.include("sh_charsearch.lua")
nut.util.include("cl_plugin.lua")
nut.util.include("cl_hooks.lua")
nut.util.include("sv_meta.lua")