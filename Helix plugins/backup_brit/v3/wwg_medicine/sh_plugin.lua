/*
	The Medical System.
	Developer Discord: 902070942342189116
	Design Document: https://docs.google.com/document/d/1BHSQTCWlbcHjuRZEcp1BfEuHC4uZE5L8zcVAFkQThMg/edit?usp=sharing
	GitHub Issue: https://github.com/wg-gh-dev/hlrp/issues/10
*/
-- @medical !Overview

// Plugin information.
PLUGIN.name = 'WWG - Medical'
PLUGIN.author = 'Werwolf Contrator: Ross'
PLUGIN.description = ''

// Medical namespace.
ix.medical = ix.medical || {}

// Multiply configuration for body damage.
ix.medical.multiply = {
	head = 1.5,
	torso = 1.2
}

// Medical debug function.
function ix.medical.Debug()
	if ix.body then
		MsgC(Color(200, 10, 10), "===== BODY =====\n")
		PrintTable(ix.body)
	end;
	if ix.wound then
		MsgC(Color(200, 10, 10), "===== WOUNDS =====\n")
		PrintTable(ix.wound)
	end;

	MsgC(Color(255, 10, 10), os.date("%X", os.time()), "\n")
end;

// File includes.
ix.util.Include("sv_plugin.lua")
ix.util.Include("sv_hooks.lua")
ix.util.Include("sv_timers.lua")

// Include all meta
for k, v in pairs(file.Find(PLUGIN.folder.."/meta/*", "LUA")) do
	ix.util.Include( "meta/" .. v )
end

// Modules includes.
ix.body.CreateTemplate()
ix.injury.LoadFromDir(PLUGIN.folder .. "/injuries")
ix.wound.LoadFromDir(PLUGIN.folder .. "/wounds")