local PLUGIN = PLUGIN
PLUGIN.name = "Loyalty system"
PLUGIN.author = "Ross Cattero"
PLUGIN.desc = "Loyalty system based on ranks above heads"

for k, v in pairs(file.Find(PLUGIN.folder.."/meta/*", "LUA")) do
	nut.util.include( "meta/" .. v )
end

nut.util.include("sv_plugin.lua")
nut.util.include("cl_plugin.lua")

nut.loyalty.tier.LoadFromDir(PLUGIN.folder .. "/tiers")

nut.command.add("addPoints", {
	adminOnly = true,
	syntax = "<string target> <number points>",
	onRun = function(client, arguments)
		local target = nut.command.findPlayer(client, arguments[1])
		local points = tonumber(arguments[2]) or 0;

		if target && target:IsValid() then
			local loyalty = nut.loyalty.instances[target:getChar():getID()];
			loyalty:AddPoints( points )
			target:notify(
				points >= 0 && "You received " .. points .. " loyalty points from " .. client:GetName()
				||
				client:GetName() .. " took " .. points .. " your loyalty points."
			);
			client:notify(
				points >= 0 && "You added " .. points .. " loyalty points to " .. target:GetName()
				||
				"You took " .. points .. " loyalty points from " .. target:GetName()
			)
		else
			client:notify("You've provided invalid target")
		end
	end
})