Gambling = Gambling or {}

-- From helix;
function Gambling.Include(fileName, realm)
	print(fileName)
	-- Only include server-side if we're on the server.
	if ((realm == "server" or fileName:find("sv_")) and SERVER) then
		return include(fileName)
	-- Shared is included by both server and client.
	elseif (realm == "shared" or fileName:find("shared.lua") or fileName:find("sh_")) then
		if (SERVER) then
			-- Send the file to the client if shared so they can run it.
			AddCSLuaFile(fileName)
		end

		return include(fileName)
	-- File is sent to client, included on client.
	elseif (realm == "client" or fileName:find("cl_")) then
		print("HERE")
		if (SERVER) then
			AddCSLuaFile(fileName)
		else
			return include(fileName)
		end
	end
end

function Gambling.IncludeDir(directory)
	-- Find all of the files within the directory.
	for _, v in ipairs(file.Find(""..directory.."/*.lua", "LUA")) do
		-- Include the file from the prefix.
		Gambling.Include(directory.."/"..v)
	end
end

Gambling.IncludeDir("autorun/client/ui")

if SERVER then
    resource.AddFile("materials/close.png")
    resource.AddFile("materials/coins.png")
    resource.AddFile("materials/pie-chart.png")
    resource.AddFile("resource/fonts/Segoe UI.ttf")
end;