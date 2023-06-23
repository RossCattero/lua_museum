local PLUGIN = PLUGIN;

function MakeHashID(length)
		if !length then length = 10 end;
		local str = ""
		math.randomseed(os.time())

		local buffer = {
			[1] = {65, 90},
			[2] = {97, 122},
			[3] = {48, 57}
		}

		local i = length;
		while (i > 0) do
				local fromBuffer = buffer[math.random(1, 3)]
				str = str .. string.char(math.random(fromBuffer[1], fromBuffer[2]));
				i = i - 1;
		end
				
		return str;
end;

function GetAmericanTime()
		local time = os.time();
		local hour, minute, mortum = "%I", "%M", "%p"

		return os.date(hour..":"..minute.." "..mortum, time)
end;

function MetricSystem(pos1, pos2)
		return math.Round( pos1:Distance( pos2 ) / 28 ) .. " m";
end;