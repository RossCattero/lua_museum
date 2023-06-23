--[[
	© 2012 Iron-Wall.org do not share, re-distribute or modify
	without permission of its author (ext@iam1337.ru).
--]]

local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("MusicAreaAdd");
COMMAND.tip = "Add an music area.";
COMMAND.text = "<string Name> <string MusicID>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";
COMMAND.arguments = 2;

function COMMAND:OnRun(player, arguments)
	local musicAreaPointData = player.cwMusicAreaData;
	local trace = player:GetEyeTraceNoCursor();
	local name = arguments[1];
	local musicID = arguments[2]
	
	if (!musicAreaPointData or musicAreaPointData.name != name) then
		player.cwMusicAreaData = {
			name = name,
			musicID = musicID,
			minimum = trace.HitPos
		};
		
		Clockwork.player:Notify(player, "You have added the minimum point. Now add the maximum point.");
		return;
	elseif (!musicAreaPointData.maximum) then
		musicAreaPointData.maximum = trace.HitPos;
	end;
	
	local data = {
		name = musicAreaPointData.name,
		musicID = musicAreaPointData.musicID,
		angles = trace.HitNormal:Angle(),
		minimum = musicAreaPointData.minimum,
		maximum = musicAreaPointData.maximum,
		position = trace.HitPos + (trace.HitNormal * 1.25)
	};
	
	data.angles:RotateAroundAxis(data.angles:Forward(), 90);
	data.angles:RotateAroundAxis(data.angles:Right(), 270);
	
	Clockwork.datastream:Start(nil, "MusicAreaAdd", data);
		PLUGIN.musicAreas[#PLUGIN.musicAreas + 1] = data;
		PLUGIN:SaveMusicAreaDisplays();
	Clockwork.player:Notify(player, "You have added the '"..data.name.."' music area.");
	
	player.cwMusicAreaData = nil;
end;

COMMAND:Register();