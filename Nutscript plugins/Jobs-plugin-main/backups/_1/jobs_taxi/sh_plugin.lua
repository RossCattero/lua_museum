local PLUGIN = PLUGIN

PLUGIN.name = "TAXI"
PLUGIN.author = "Ross Cattero"
PLUGIN.desc = "Adds TAXI."

PLUGIN.debug = true;

nut.util.include("cl_plugin.lua")
nut.util.include("sv_plugin.lua")
nut.util.include("sh_meta.lua")
nut.util.include("sv_meta.lua")

nut.command.add("taxi", {
	onRun = function(client)
			netstream.Start(client, 'taxi::phone')
	end
})
nut.command.add("changeTaxiPoint", {
	adminOnly = true,
	onRun = function(client, arguments)
			TAXI_DATA.taxiSpawnPos = client:GetPos()
			client:notify("Sucessfully changed the taxi spawnpoint")
	end
})