local PLUGIN = PLUGIN;

function PLUGIN:PlayerLoadedCharacter(client, character, prev)
	timer.Simple(.25, function()
		ix.medical.CreateInstance(character:GetID(), client:FormBones())
	end)
end