local PLUGIN = PLUGIN

PLUGIN.name = "Stamina plugin"
PLUGIN.author = "Ross"
PLUGIN.description = ""

ix.util.Include("sv_plugin.lua")
ix.util.Include("cl_plugin.lua")

function StartSound(player, uniqueID, sound, fVolume)
	if (!player.ixSoundsPlaying) then
		player.ixSoundsPlaying = {};
	end;
	
	if (!player.ixSoundsPlaying[uniqueID]
	or player.ixSoundsPlaying[uniqueID] != sound) then
		player.ixSoundsPlaying[uniqueID] = sound;
		
		netstream.Start(player, "StartSound", {
			uniqueID = uniqueID, sound = sound, volume = (fVolume or 0.75)
		});
	end;
end;

function StopSound(player, uniqueID, iFadeOut)
	if (!player.ixSoundsPlaying) then
		player.ixSoundsPlaying = {};
	end;
	
	if (player.ixSoundsPlaying[uniqueID]) then
		player.ixSoundsPlaying[uniqueID] = nil;
		
		netstream.Start(player, "StopSound", {
			uniqueID = uniqueID, fadeOut = (iFadeOut or 0)
		});
	end;
end;