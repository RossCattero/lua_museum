--[[
	© 2012 Iron-Wall.org do not share, re-distribute or modify
	without permission of its author (ext@iam1337.ru).
--]]

local PLUGIN = PLUGIN;

function PLUGIN:LoadMusicAreaDisplays()
	self.musicAreas = Clockwork.kernel:RestoreSchemaData("plugins/musicareas/"..game.GetMap());
end;

function PLUGIN:SaveMusicAreaDisplays()
	Clockwork.kernel:SaveSchemaData("plugins/musicareas/"..game.GetMap(), self.musicAreas);
end;