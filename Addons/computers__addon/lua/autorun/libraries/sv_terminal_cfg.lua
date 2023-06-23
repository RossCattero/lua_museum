// =======================VARS==================================
PREFIX 		= "-" 		// GLOBAL: prefix of the commands.
CMDPREFIX 	= "CMD:>" 	// GLOBAL: prefix of CMD;
CMDLIST 	= {
	["help"] = {
		name = "Help",
		description = "Shows the list of all commands",
		action = function(panel)
			if panel.addCommand then
				for k, v in pairs(CMDLIST) do
					panel:addCommand(PREFIX .. k .. " - " .. v.description)
				end
			end;
		end
	},
	["clear"] = {
		name = "Clear",
		description = "Clears the screen of cmd[debug only]",
		action = function(panel)
			if panel.history.Clear then
				panel.history:Clear();
			end;
		end
	},
	["argument"] = {
		name = 'Command with an argument',
		descritpion = "test",
		action = function (panel)
			
		end
	}
} 	// GLOBAL: commands list.
// =======================VARS==================================

function cmdInit()
	local buffCMDs = {}
	for k, v in pairs(CMDLIST) do
		if !k:StartWith(PREFIX) then
			CMDLIST[PREFIX .. k] = v;
			CMDLIST[k] = nil;
		end
		buffCMDs[PREFIX .. k] = {
			name = v.name,
			description = v.description
		}
	end
end;
cmdInit()

hook.Add("ClientSignOnStateChanged", "TerminalHook1", function( userID, oldState, newState )
	-- local client = Entity(userID)
	if newState == 6 then
		print(Player(userID))
	end
	netstream.Start(client, 'cmdInit', PREFIX, CMDPREFIX, buffCMDs)
end)