function TERMINAL:Init()
	for k, v in pairs(self.CMDLIST) do
		if !self:IsCommand(k) then
			self.CMDLIST[self.PREFIX .. k] = v;
			self.CMDLIST[k] = nil;
		end
	end
end

function TERMINAL:AddCmd(name, cmdArray)
	if !name or !cmdArray then return end;
	name = name:lower()
	local description = cmdArray.description or "No description";
	self.CMDLIST[self.PREFIX .. name] = {
		description = description,
		argument = tobool(cmdArray.argument),
		auth = tobool(cmdArray.auth),
		login = tobool(cmdArray.login),
		noEcho = tobool(cmdArray.noEcho),
		Log = tobool(cmdArray.Log),
		argAmount = cmdArray.argAmount or 0,		// argument amount or 0;
		format = cmdArray.format or false,			// format of false;
		permission = cmdArray.permission or false, // massive or false;
		OnUse = cmdArray.OnUse
	}
end;

function TERMINAL:CmdFind(name)
	name = name:lower()
	return self.CMDLIST[name];
end;

function TERMINAL:IsCommand(str)
	return str:StartWith(self.PREFIX);
end;

function TERMINAL:GetCMDName(cmd)
	for name, array in pairs(self.CMDLIST) do
		if ( cmd:gmatch('[%'..self.PREFIX..'%w]+')() ) == name then
			return name;
		end
	end
	return cmd:gmatch('[%'..self.PREFIX..'%w]+')();
end;

function TERMINAL:exec(cmd, panel, auth, id)
	if cmd:len() == 0 then return end;
	local cmdName = self:GetCMDName(cmd);
	local command = self:CmdFind(cmdName);
	local t = LocalPlayer():Team();
	
	if self:IsCommand(cmd) && command && ( !command.permission || (command.permission && table.HasValue(command.permission, t)) ) then
		if (auth || ((!auth && command.auth) or (!auth && command.login))) then
			local argument = command.argument && cmd:gmatch(cmdName..'[%s]*([%g%s]+)')();
			command.OnUse(argument, command.argAmount, panel, id);

			netstream.Start('terminal::updateHistory', cmd, id)

			return true, cmdName, command.noEcho, command.Log
		end;
	end

	return false, cmdName, false, false
end;

function TERMINAL:Validate(client)
	if !client:IsPlayer() then return false end;
	local trace = client:GetEyeTraceNoCursor();
	local entity = trace.Entity;

	if 
	entity 
	&& IsValid(entity) 
	&& string.lower(entity:GetClass()) == 'terminal' 
	&& entity:GetIndex() 
	&& client:GetPos():Distance( entity:GetPos() ) < 84
	&& (client:GetNWEntity("Terminal") == entity)
	then
		return entity;
	end

	return false
end;

--[[
Usage example: 
TERMINAL:AddCmd("name", { 				// name of command
	description = "Description", 		// description for help
	argument = true, 					// argument after command.
	format	=	false					// format of the argument. You can not provide it and this will be replaced to <argument>
	auth = false, 						// Command allowed without -login(auth)
	login = true, 						// <important> Command for login or not. Should be only one!
	noEcho = true, 						// Don't send error on command mistake.
	Log = true,							// Log this?
	permission = {},					// Professions, that's allowed to use this command.
	OnUse = function(argument, argAmount, panel, id) 	// function, called on cmd use		
	end
})
--]]

TERMINAL:AddCmd("help", {
	description = "Help command.",
	Log = true,
	auth = true,
	OnUse = function(argument, argAmount, panel)
		local term = TERMINAL:Validate(LocalPlayer());
		if panel.addCMD then
			for k, v in pairs(TERMINAL.CMDLIST) do
				if !v.login && (term:GetLogin() || (v.auth && !term:GetLogin() or !v.auth && term:GetLogin())) then
					local arg = 		(v.argument && v.format && " "..v.format || v.argument && " <argument>") or (!v.argument && "")
					local permissions = (v.permission && "<needs permission>") or (!v.permission && "")
					panel:addCMD(k .. arg .. " " .. permissions .. " - " .. v.description, nil, "", true);
				end;
			end
		end
	end
})

TERMINAL:AddCmd("id", {
	description = "Get the computer id.",
	Log = true,
	auth = true,
	OnUse = function(argument, argAmount, panel, id)
		SetClipboardText(id);
		panel:addCMD("Identificator #"..id.." is saved to clipboard.", Color(100, 255, 100), nil, true);
	end
})

TERMINAL:AddCmd("login", {
	description = "Auth command.",
	argument = true,
	login = true,
	noEcho = true,
	argAmount = 2,
	OnUse = function(argument, argAmount)
		netstream.Start("terminal:checkAccess", argument, argAmount)				
	end
})

TERMINAL:AddCmd("chpass", {
	description = "Change password of the current terminal.",
	argument = true,
	format = "<old new>",
	argAmount = 2,
	Log = false,
	OnUse = function(argument, argAmount, panel, id)
		netstream.Start("terminal:changePassword", argument, argAmount, id)
	end
})

TERMINAL:AddCmd("exit", {
	description = "Exit the current terminal.",
	auth = true,
	Log = true,
	OnUse = function()
		if (TERMINAL.interface && TERMINAL.interface:IsValid()) then
			TERMINAL.interface:CloseMe()
		end;
	end
})

TERMINAL:AddCmd("pm", { 				
	description = "Send the personal message to computer.",
	format = "<ID message>",
	argAmount = 2,
	argument = true,
	Log = true,
	OnUse = function(argument, argAmount, panel, id)
		netstream.Start("terminal::MESSAGES", "pm", argument, argAmount, id)
	end
})

TERMINAL:AddCmd("transmit", { 				
	description = "Send messages to all computers.",
	argument = true,
	argAmount = 1,
	Log = true,
	OnUse = function(argument, argAmount, panel, id)
		netstream.Start("terminal::MESSAGES", "transmit", argument, argAmount, id)
	end
})

TERMINAL:AddCmd("report", { 				
	description = "Report suspect to the police.",
	argument = true,
	argAmount = 1,
	Log = true,
	OnUse = function(argument, argAmount, panel, id)
		netstream.Start("terminal::reportSuspect", argument, argAmount, id)
	end
})

TERMINAL:AddCmd("checkreport", { 				
	description = "Get the last report.",
	permission = {TEAM_CITIZEN},
	Log = true,
	OnUse = function(argument, argAmount, panel, id)
		netstream.Start("terminal::checkSuspect", id)
	end
})

TERMINAL:AddCmd("onlineid", { 				
	description = "List all active players.",
	Log = true,
	auth = true,
	OnUse = function(argument, argAmount, panel, id)
		for k, v in ipairs(player.GetAll()) do
			if v:IsValid() then
				panel:addCMD("** PLAYER LIST: **", nil, "", true)
				panel:addCMD(v:GetName() .. "[Ping: " .. v:Ping() .. "]" .. " ****", nil, "****", true);
			end;
		end
	end
})

TERMINAL:AddCmd("regSensor", { 				
	description = "Connect the sensor with this terminal. The ID of the sensor is needed.",
	argument = true,
	Log = true,
	argAmount = 1,
	format = "<ID>",
	OnUse = function(argument, argAmount, panel, id)
		netstream.Start("terminal:registerSensor", argument, argAmount, id)
	end
})

TERMINAL:AddCmd("logsSensor", { 				
	description = "Get the connected sensor/sensor group logs.",
	Log = true,
	OnUse = function(argument, argAmount, panel, id)
		netstream.Start("terminal:getSensorLogs", id)
	end
})

TERMINAL:AddCmd("memActive", { 				
	description = "Activate the memory card and load all logs if memory is acceptable.",
	Log = true,
	OnUse = function(argument, argAmount, panel, id)
		netstream.Start('terminal::Memory', "active", id)
	end
})

TERMINAL:AddCmd("memClean", { 				
	description = "Activate the memory card and clean all memory from it.",
	Log = true,
	OnUse = function(argument, argAmount, panel, id)
		netstream.Start('terminal::Memory', "clean", id)
	end
})

TERMINAL:AddCmd("memUnload", { 				
	description = "Unload the memory card from terminal.",
	Log = true,
	OnUse = function(argument, argAmount, panel, id)
		netstream.Start('terminal::Memory', "take", id)
	end
})

TERMINAL:AddCmd("memRead", { 				
	description = "Activate the memory card and read all memory from it to terminal.",
	Log = true,
	OnUse = function(argument, argAmount, panel, id)
		netstream.Start('terminal::Memory', "read", id)
	end
})

TERMINAL:AddCmd("memReadSensors", { 				
	description = "Activate the memory card and read all sensors logs from it to card. ALERT: ALL DATA WILL BE EASED!",
	Log = true,
	OnUse = function(argument, argAmount, panel, id)
		netstream.Start('terminal::Memory', "readSensors", id)
	end
})

TERMINAL:AddCmd("checkid", { 				
	description = "Check the id of online user.",
	argument = true,
	Log = true,
	argAmount = 1,
	format = "<ID>",
	OnUse = function(argument, argAmount, panel, id)
		netstream.Start('terminal::CheckID', argument, argAmount, id)
	end
})

TERMINAL:AddCmd("delarrestid", { 				
	description = "Delete the player id from wanted list.",
	argument = true,
	permission = {TEAM_CITIZEN},
	Log = true,
	argAmount = 1,
	format = "<ID>",
	OnUse = function(argument, argAmount, panel, id)
		netstream.Start('terminal::WantedList', argument, argAmount, "delete", id)
	end
})

TERMINAL:AddCmd("addarrestid", { 				
	description = "Add the player id to the wanted list.",
	argument = true,
	permission = {TEAM_CITIZEN},
	Log = true,
	argAmount = 2,
	format = "<ID Reason>",
	OnUse = function(argument, argAmount, panel, id)
		netstream.Start('terminal::WantedList', argument, argAmount, "add", id)
	end
})

TERMINAL:AddCmd("wantedlist", { 				
	description = "Check the wanted list.",
	permission = {TEAM_CITIZEN},
	Log = true,
	OnUse = function(argument, argAmount, panel, id)
		netstream.Start('terminal::WantedList', argument, argAmount, "check", id)
	end
})

TERMINAL:Init();