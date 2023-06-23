--[[
	© 2012 Iron-Wall.org do not share, re-distribute or modify
	without permission of its author (ext@iam1337.ru).
--]]

local PLUGIN = PLUGIN;

Clockwork.datastream:Hook("MusicAreas", function(data)
	local PLUGIN = Clockwork.plugin:FindByID("Atmospheric Background Music");

	PLUGIN.musicAreas = data;
end);

Clockwork.datastream:Hook("MusicAreaAdd", function(data)
	local PLUGIN = Clockwork.plugin:FindByID("Atmospheric Background Music");
	
	PLUGIN.musicAreas[#PLUGIN.musicAreas + 1] = data;
end);

Clockwork.datastream:Hook("MusicAreaRemove", function(data)
	local PLUGIN = Clockwork.plugin:FindByID("Atmospheric Background Music");
	
	for k, v in pairs(PLUGIN.musicAreas) do
		if (v.minimum == data.minimum and v.maximum == data.maximum) then
			PLUGIN.musicAreas[k] = nil;
		end;
	end;
end);