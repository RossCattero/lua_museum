local PLUGIN = PLUGIN
PLUGIN.name = "Character list"
PLUGIN.author = "Ross Cattero"
PLUGIN.desc = "The list of characters for admins"

nut.util.include("cl_plugin.lua")
nut.util.include("sv_plugin.lua")
nut.util.include("sh_character.lua")

nut.command.add("charList", {
	adminOnly = true,
	onRun = function(client)
			netstream.Start(client, 'charList::show', PLUGIN:CollectCharacterData())
	end
})

// For some reason nutscript still un-supported the unability to choose character if his whitelist not available :/
function PLUGIN:CanPlayerUseChar(client, char)
		local white = client:getNutData("whitelists")
		local facName = nut.faction.indices[char:getFaction()].uniqueID
		if nut.faction.indices[char:getFaction()].isDefault then
				return true;
		end

		print(white)

		if !white then return false end;
		
		return tobool(white[SCHEMA.folder][facName]), "You're not whitelisted to use this character!"
end;