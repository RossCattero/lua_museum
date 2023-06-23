--[[
	© 2012 Iron-Wall.org do not share, re-distribute or modify
	without permission of its author (ext@iam1337.ru).
--]]

local PLUGIN = PLUGIN;

function PLUGIN:PlayerEnteredMusicArea(musicArea)
	Clockwork.backgroundmusic:Play(musicArea.musicID);
end;

function PLUGIN:PlayerExitedMusicArea(musicID)
	self.currentMusicID = false;
	Clockwork.backgroundmusic:Stop();
end;

function PLUGIN:Tick()
	local curTime = UnPredictedCurTime();
	local lastMusicID = self.currentMusicID;

	MusicAreaLeave = false;
	
	if (!IsValid(Clockwork.Client) or !Clockwork.Client:HasInitialized()) then
		return;
	end;

	if (self.nextMusicArea and curTime < self.nextMusicArea) then
		return;
	end;
	
	self.nextMusicArea = curTime + 1;
	
	for k, v in pairs(self.musicAreas) do
		if (Clockwork.entity:IsInBox(Clockwork.Client, v.minimum, v.maximum)) then
			
			if (!self.currentMusicID or self.currentMusicID != v.musicID) then
				self.currentMusicID = v.musicID;
				Clockwork.plugin:Call("PlayerEnteredMusicArea", v);
			else
				
			end;
		elseif (lastMusicID == v.musicID) then
			MusicAreaLeave = v.musicID;
		end;
	end;	
	
	if (MusicAreaLeave) then
		Clockwork.plugin:Call("PlayerExitedMusicArea", MusicAreaLeave);
	end;
end;