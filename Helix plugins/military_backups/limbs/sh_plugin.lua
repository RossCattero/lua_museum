local PLUGIN = PLUGIN

PLUGIN.name = "LIMBS: Core"
PLUGIN.author = "Ross Cattero"
PLUGIN.description = "Основная база повреждений, где происходят вычисления."

ix.util.Include("cl_plugin.lua")
ix.util.Include("cl_hooks.lua")
ix.util.Include("sv_plugin.lua")
ix.util.Include("sv_hooks.lua")

ix.util.Include("timers/cl_timers.lua")
ix.util.Include("timers/sv_timers.lua")

ix.util.Include("meta/sh_meta.lua")
ix.util.Include("meta/sv_meta.lua")

ix.util.Include("sv_actions.lua")

function PLUGIN:UpdateAnimation(client, moveData)
	local angle = client:GetNetVar("actEnterAngle")
	if (angle) then client:SetRenderAngles(angle) end
end