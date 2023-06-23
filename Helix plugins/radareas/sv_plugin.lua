local PLUGIN = PLUGIN;

function PLUGIN:PlayerLoadedCharacter(client, character, prev)
    timer.Simple(0.25, function()

				character:SetData("Radiation", 
					character:GetData("Radiation", 0)
				)
        client:SetLocalVar("Radiation", 
					character:GetData("Radiation", 0)
				)
			
			if prev && timer.Exists('RadXTimer ' .. prev:GetID()) then 
					local uniqueID = 'RadXTimer ' .. prev:GetID();
					local time = timer.TimeLeft(uniqueID);
					prev:SetData("RadXTimeleft", time)
					prev:SetData("RadXPercentage", prev.RadDecrease)
					netstream.Start(client, 'rad::syncTimer')
				end
				local time, percent = character:GetData("RadXTimeleft", 0), character:GetData("RadXPercentage", 0)
				if character && time != 0 && percent != 0 then
						local uniqueID = 'RadXTimer ' .. character:GetID();
						character.RadDecrease = math.Clamp(percent, 0, 100);
						netstream.Start(client, 'rad::syncTimer', time)

						timer.Create(uniqueID, time, 1, function()
							if !timer.Exists(uniqueID) || !client:IsValid() || !client:Alive() || client:GetCharacter() != character then 
								timer.Remove(uniqueID) 
								return; 
							end;
							
							character.RadDecrease = 0;
						end);
				end
    end)
end

function PLUGIN:CharacterPreSave(character)
    local client = character:GetPlayer()
    if (IsValid(client)) then
        character:SetData("Radiation", 
					client:GetLocalVar("Radiation", 0)
				)
    end
end

// There's already a default timer for initializing the areas in timer;
// But you should change the tick for all areas in once in config;
// Using think hook is not good, but there's no other optimized ways to do it;
function PLUGIN:PlayerPostThink( player )
    local char = player:GetCharacter()
		if (!player:IsValid() || !player:Alive() || !char) then return end;

		local currArea = player:GetArea();
		local inArea = player.ixInArea
    local plyArea = (ix.area.stored[currArea] || nil);
		if !inArea || !plyArea then return end;
		
		local tox = plyArea.properties.toxicity;
		tox = math.Clamp(tox || 1, PLUGIN.rMin, PLUGIN.rMax)
		
    if !player.rThink || CurTime() >= player.rThink then
				player.rThink = CurTime() + 1;
				if inArea && plyArea.type == "Radiation" then
						local rad = player:GetRad();
						local amount = math.Round( tox * (1 - ((char.RadDecrease or 0) / 100)), 2 );

						player:IncRad( math.Clamp(rad + amount, 0, PLUGIN.maxRadiation) )
						self:TriggerRadiationCheck(player)

						if rad >= PLUGIN.maxRadiation then
								player:Notify(PLUGIN.maxRadMSG);
								player:Kill()
								player:IncRad( 0 ) // Reset the radiation on kill;
						end

						player:EmitGeiger( tox )
				end
    end;

end;

-- print(Entity(1):GetCharacter():GetID())
-- timer.Remove('RadXTimer ' .. Entity(1):GetCharacter():GetID())