// ======================= VARS ==================================
TERMINAL 				= TERMINAL or {};					// SHARED: terminal object;
TERMINAL.PREFIX 		= TERMINAL.PREFIX or "-" 			// GLOBAL: prefix of the commands.
TERMINAL.CMDPREFIX 		= TERMINAL.CMDPREFIX or "CMD:>" 	// GLOBAL: prefix of CMD;
TERMINAL.CMDLIST 		= TERMINAL.CMDLIST or {} 			// GLOBAL: commands list.
// ======================= VARS ==================================

//	SHARED: Terminal methods

function TERMINAL:Init()
	for k, v in pairs(self.CMDLIST) do
		if !self:IsCommand(k) then
			self.CMDLIST[self.PREFIX .. k] = v;
			self.CMDLIST[k] = nil;
		end
	end
end

function TERMINAL:AddCmd(name, cmdArray)
	if !name or !cmdArray or self:CmdFind(name) then return end;
	local description = cmdArray.description or "No description";
	local argument = cmdArray.argument or false;
	self.CMDLIST[name] = { 
		description = description,
		argument = argument,
		OnUse = cmdArray.OnUse
	}
end;

function TERMINAL:CmdFind(name)
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
	return 'unknown';
end;

function TERMINAL:exec(cmd, ...)
	local cmdName = self:GetCMDName(cmd);
	local command = self:CmdFind(cmdName);
	if self:IsCommand(cmd) && command then
		local argument = command.argument && cmd:gmatch(cmdName..'[%s]*([%g%s]+)')();
		command.OnUse(argument, ...);
	end
end;

TERMINAL:AddCmd("help", {
	description = "Help command",
	argument = true,
	OnUse = function(argument, ...)
		print(argument) // Нужно реализовать выполнение скрипта.
	end
})

TERMINAL:Init();