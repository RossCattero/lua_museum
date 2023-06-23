PLUGIN.name = "Limbs: UI"
PLUGIN.author = Schema.author
PLUGIN.description = "Module for limbs system"

ix.util.Include("cl_plugin.lua")
ix.util.Include("cl_fonts.lua")
ix.util.Include("meta/sv_player.lua")

netstream.Hook("LIMBS_DERMA_REMOVE", function(client)
	client:SetLocalVar("inspChar", nil)
end);