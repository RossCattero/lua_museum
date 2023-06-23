--[[
	© 2012 Iron-Wall.org do not share, re-distribute or modify
	without permission of its author (ext@iam1337.ru).
--]]

local PLUGIN = PLUGIN

local COMMAND = Clockwork.command:New("MusicAreaRemove");
COMMAND.tip = "Deletes music sector in which you stand.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";
COMMAND.arguments = 0;

function COMMAND:OnRun(player, arguments)
	local position = player:GetEyeTraceNoCursor().HitPos;
	local removed = 0;
	
	for k, v in pairs(PLUGIN.musicAreas) do
		if (Clockwork.entity:IsInBox(player, v.minimum, v.maximum)) then
			Clockwork.datastream:Start(nil, "MusicAreaRemove", {
				minimum = v.minimum,
				maximum = v.maximum
			});
				
			PLUGIN.musicAreas[k] = nil;
			removed = removed + 1;
		end;
	end;
	
	if (removed > 0) then
		if (removed == 1) then
			Clockwork.player:Notify(player, "You have removed "..removed.." music area.");
		else
			Clockwork.player:Notify(player, "You have removed "..removed.." music areas.");
		end;
	else
		Clockwork.player:Notify(player, "There were no music area found.");
	end;
	
	PLUGIN:SaveMusicAreaDisplays();
end;

COMMAND:Register();