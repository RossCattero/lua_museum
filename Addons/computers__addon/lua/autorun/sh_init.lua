AddCSLuaFile()

function BetterInclude(fileName)
	if (fileName:find("sv_") && SERVER) then
		return include(fileName)
	elseif (fileName:find("shared.lua") or fileName:find("sh_")) then
		if (SERVER) then
			AddCSLuaFile(fileName)
		end
		return include(fileName)
	elseif (fileName:find("cl_")) then
		if (SERVER) then
			AddCSLuaFile(fileName)
		else
			return include(fileName)
		end
	end
end

function validateTerminal(client)
	local trace = client:GetEyeTraceNoCursor();
	local entity = trace.Entity;
	
	if entity && IsValid(entity) && entity:GetClass() == 'terminal' && entity.GetTerminalIndex && client:GetPos():Distance( entity:GetPos() ) < 512 then
		return entity;
	end
end;

for k, v in ipairs(file.Find("autorun/libraries/*.lua", "LUA")) do BetterInclude("autorun/libraries/"..v) end
for k, v in ipairs(file.Find("autorun/derma/*.lua", "LUA")) do BetterInclude("autorun/derma/"..v) end

BetterInclude("autorun/sv_init.lua")
BetterInclude("autorun/cl_init.lua")