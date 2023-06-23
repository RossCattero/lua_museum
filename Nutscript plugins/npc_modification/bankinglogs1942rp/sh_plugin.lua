local PLUGIN = PLUGIN
PLUGIN.name = "Banking > Logs > 1942rp"
PLUGIN.author = "Ross Cattero"
PLUGIN.desc = "Banking logs for banking plugin"

BANKING_LOGS = BANKING_LOGS || {}

nut.util.include("cl_plugin.lua")
nut.util.include("sv_plugin.lua")
nut.util.include("sv_meta.lua")

BANKING_LOGS.logs = BANKING_LOGS.logs || {}
BANKING_LOGS.colors = {
	Color(180, 100, 100),
	Color(100, 150, 100)
}

nut.command.add("banklogs", {
	adminOnly = true,
	onCheckAccess = function(client)
			return client:getChar():hasFlags("B")
	end,
	syntax = "",
	onRun = function(client, arguments)
			if client:getChar():hasFlags("B") then
				client:SyncBankLogs()
				netstream.Start(client, 'Banking::OpenLogs')
			end
	end
})