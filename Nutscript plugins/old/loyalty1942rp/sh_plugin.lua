local PLUGIN = PLUGIN
PLUGIN.name = "Loyalty system"
PLUGIN.author = "Ross Cattero"
PLUGIN.desc = "Loyalty plugin for 1942rp."

nut.util.include("cl_plugin.lua")
nut.util.include("sh_config.lua")
nut.util.include("sv_plugin.lua")

nut.command.add("addPoints", {
	adminOnly = true,
	syntax = "<string target> <number points>",
	onRun = function(client, arguments)
			local target = nut.command.findPlayer(client, arguments[1])
			local points = tonumber(arguments[2]) or 0;

			if target:IsValid() then
					
					target:AddGPoints(points)
					target:notify(
						points >= 0 && "You received " .. points .. " loyalty points from " .. client:GetName()
						||
						client:GetName() .. " taken " .. points .. " loyalty points from you"
					);

					client:notify(
						points >= 0 && "You given " .. points .. " loyalty points to " .. target:GetName()
						||
						"You taken " .. points .. " loyalty points from " .. target:GetName()
					)
			else
				client:notify("You've provided invalid target")
			end
	end
})