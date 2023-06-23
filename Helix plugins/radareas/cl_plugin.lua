local PLUGIN = PLUGIN;

netstream.Hook('rad::syncTimer', function(time)
		local user = LocalPlayer()
		local char = user:GetCharacter()
		local uniqueID = 'RadXTimer'

		if !time then time = 0 end;

		if timer.Exists(uniqueID) then
				if time == 0 then
						timer.Remove(uniqueID)
				end

				return;
		end
		timer.Create(uniqueID, 1, time, function()
			if !timer.Exists(uniqueID) || !user:IsValid() || !user:Alive() then 
				timer.Remove(uniqueID) 
				return; 
			end;
		end);
end);