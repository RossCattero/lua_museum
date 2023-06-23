--[[
	© 2012 Iron-Wall.org do not share, re-distribute or modify
	without permission of its author (ext@iam1337.ru).
--]]

local PLUGIN = PLUGIN

local COMMAND = Clockwork.command:New("MusicList");
COMMAND.tip = "List the background music.";
COMMAND.access = "s";
COMMAND.arguments = 0;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	Clockwork.datastream:Start(player, "cwMusicList", true);
	Clockwork.player:Notify(player, "The music list have been printed to the console.");
end;

COMMAND:Register();