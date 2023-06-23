if !SERVER then return end;

Terminals = {};

// -- net-s --
netstream.Hook('storeTerminalMessage', function(client, message, id) 
	local ent = validateTerminal(client);
	if ent && ent:GetTerminalIndex() == id then
		Terminals[tonumber(id)]['logs']
		[#Terminals[tonumber(id)]['logs'] + 1] = message;
	end;
end)
netstream.Hook('closeTerminal', function(client, id) 
	local ent = validateTerminal(client);
	if ent && ent:GetTerminalIndex() == id then
		ent.isUsed = false;
		ent.isLoggedIn = false; // Остановился тут
	end;
end)
// -- net-s --