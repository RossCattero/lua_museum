--[[
	© 2012 Iron-Wall.org do not share, re-distribute or modify
	without permission of its author (ext@iam1337.ru).
--]]

local PLUGIN = PLUGIN;

function PLUGIN:ClockworkInitPostEntity() self:LoadMusicAreaDisplays(); end;

function PLUGIN:PlayerSendDataStreamInfo(player)
	Clockwork.datastream:Start(player, "MusicAreas", self.musicAreas);
end;