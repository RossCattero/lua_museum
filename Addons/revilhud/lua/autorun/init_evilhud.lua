if SERVER then
	resource.AddFile('materials/umbrella.png')
	AddCSLuaFile("autorun/init_evilhud.lua")
else
	include('evilhud/sh_revli_hud.lua')
end
