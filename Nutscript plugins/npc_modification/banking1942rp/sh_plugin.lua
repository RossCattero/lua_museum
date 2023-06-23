local PLUGIN = PLUGIN
PLUGIN.name = "Banking > Main > 1942rp"
PLUGIN.author = "Ross Cattero"
PLUGIN.desc = "Banking plugin for 1942rp style"

nut.util.include("cl_plugin.lua")
nut.util.include("sv_plugin.lua")
nut.util.include("sh_load.lua")
nut.util.include("sh_config.lua")
nut.util.include("sv_cmds.lua")
nut.util.include("sv_access_rules.lua")
nut.util.include("sv_meta.lua")

function PLUGIN:MakeHashID(length)
		if !length then length = 10 end;
		local str = ""
		math.randomseed(os.time())

		local buffer = {
			[1] = {65, 90},
			[2] = {97, 122},
			[3] = {48, 57}
		}

		local i = length;
		while (i > 0) do
				local fromBuffer = buffer[math.random(1, 3)]
				str = str .. string.char(math.random(fromBuffer[1], fromBuffer[2]));
				i = i - 1;
		end
				
		return str;
end;

nut.command.add("setFunds", {
	adminOnly = true,
	syntax = "<string amount>",
	onRun = function(client, arguments)
			local value = tonumber(arguments[1]) or 0;

			PLUGIN.moneyFunds = value;
			client:notify("The amount of general fund is set to: "..value .. BANKING_REICHMARK)

			BANKING_LOGS:AddLog(client:GetName(), "Funds set to " .. PLUGIN.moneyFunds, 1)
	end
})

nut.command.add("bank", {
	adminOnly = true,
	onCheckAccess = function(client)
			return client:getChar():hasFlags("B")
	end,
	syntax = "",
	onRun = function(client, arguments)
			if client:getChar():hasFlags("B") then
				netstream.Start(client, 'Banking::OpenBook')
			end
	end
})

// Create bank account for admin;
// For debuging only!
nut.command.add("createBankForAdmin", {
	adminOnly = true,
	syntax = "",
	onRun = function(client, arguments)
			client:CreateHash()
			PLUGIN:MakeBankingAccount(client, "Default")
	end
})

local user = FindMetaTable("Player")

function user:HasAcc()
		return self:getLocalVar("Hash")
end;
