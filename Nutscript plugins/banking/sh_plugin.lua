local PLUGIN = PLUGIN
PLUGIN.name = "Banking NPC"
PLUGIN.author = "Ross Cattero"
PLUGIN.desc = "NPC banking plugin for 1942rp style"

for k, v in pairs(file.Find(PLUGIN.folder.."/meta/*", "LUA")) do
	nut.util.include( "meta/" .. v )
end

nut.currency.set("ℛℳ", "reichmark", "reichmarks")

nut.banking.option.LoadFromDir(PLUGIN.folder .. "/banking_options")
nut.banking.status.LoadFromDir(PLUGIN.folder .. "/banking_statuses")

nut.util.include("sv_plugin.lua")
nut.util.include("sv_access_rules.lua")

nut.flag.add("B", "Access to banking book")

nut.command.add("setFunds", {
	adminOnly = true,
	syntax = "<string amount>",
	onRun = function(client, arguments)
		local value = tonumber(arguments[1]) or 0;

		nut.banking.funds = value;
		client:notify("The amount of general fund is set to: "..value)
	end
})

nut.command.add("bank", {
	onCheckAccess = function(client)
		return client:getChar():hasFlags("B")
	end,
	syntax = "",
	onRun = function(client, arguments)
		if client:getChar():hasFlags("B") then
			nut.banking.sendData(client,
			function()
				net.Start("nut.banking.bankeer.open")
				net.Send(client)
			end)
		end
	end
})