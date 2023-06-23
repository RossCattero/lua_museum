--[[
	© 2012 Iron-Wall.org do not share, re-distribute or modify
	without permission of its author (ext@iam1337.ru).
--]]

Clockwork.backgroundmusic = Clockwork.kernel:NewLibrary("BackgroundMusic");
Clockwork.backgroundmusic.stored = {};

function Clockwork.backgroundmusic:Add(id, name, music, addFile)
	self.stored[id] = {
		name = name,
		music = music
	};
	
	if (SERVER) then
		if (addFile) then
			Clockwork.kernel:AddFile("sound/"..music);
		end;
	end;
end;

function Clockwork.backgroundmusic:FindByID(id)
	return self.stored[id];
end;

function Clockwork.backgroundmusic:FindByName(name)
	for k,v in pairs(self.stored) do
		if (string.lower(v.name) == string.lower(v.name)) then return v; end;
	end;
end;

if (CLIENT) then
	function Clockwork.backgroundmusic:Play(id)
		if (!self.sound and self:FindByID(tostring(id))) then
			self.sound = CreateSound(Clockwork.Client, self:FindByID(tostring(id)).music);
			self.sound:PlayEx(0.75,100);		
			
			return;
		else
			self:Stop();
			
			timer.Simple(5, function()
			Clockwork.backgroundmusic:Play(id);
		end)
		end;
	end;
	
	function Clockwork.backgroundmusic:Stop()
		self.sound:FadeOut(3);
		self.sound = false;
	end;
	
	Clockwork.datastream:Hook("cwMusicList", function(data)
		Clockwork.Client:PrintMessage(2, "######## [Clockwork] Music List ########\n");
		for k,v in pairs(Clockwork.backgroundmusic.stored) do
			Clockwork.Client:PrintMessage(2,k..") Name: "..v.name.." | Music patch: "..v.music.."\n");
		end;
	end);
end;

Clockwork.backgroundmusic:Add("1", "Half-Life 2: Song 19", 		"music/hl2_song19.mp3");
Clockwork.backgroundmusic:Add("2", "Half-Life 2: Ravenholm", 		"music/Ravenholm_1.mp3");
Clockwork.backgroundmusic:Add("3", "Half-Life 2: Song 13", 		"music/hl2_song13.mp3");
Clockwork.backgroundmusic:Add("4", "Half-Life 2: Song 26", 		"music/hl2_song26.mp3");
Clockwork.backgroundmusic:Add("5", "Half-Life 2: Song 17", 		"music/hl2_song17.mp3");
Clockwork.backgroundmusic:Add("6", "Half-Life 2: Song 26", 		"music/hl2_song26.mp3");
Clockwork.backgroundmusic:Add("7", "Half-Life 2: Song 27 Train", 	"music/HL2_song27_trainstation2.mp3");
Clockwork.backgroundmusic:Add("8", "Half-Life 2: Song 31", 		"music/HL2_song31.mp3");
Clockwork.backgroundmusic:Add("9", "Half-Life 2: Radio", 		"music/radio1.mp3");
Clockwork.backgroundmusic:Add("10", "Half-Life 2: Song 16", 		"music/hl2_song16.mp3");
Clockwork.backgroundmusic:Add("11", "Great Music", 		"music/hl2_song20.mp3");
Clockwork.backgroundmusic:Add("12", "Slow-paced kaef music", 		"music/hl2_song23.mp3");