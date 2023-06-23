
local PLUGIN = PLUGIN;
PLUGIN.notifyTicks = 3;
local math = math;

function PLUGIN:PlayerRestoreCharacterData(player, data)
	if ( !data["Toxins"] ) then
		data["Toxins"] = 0;
    end;
end;

function PLUGIN.OnGasTick(player, id, gasScale)
	if (gasScale > 0) then

		if (player.gasNotified != 0 and player.gasNotified < PLUGIN.notifyTicks) then
			player.gasNotified = player.gasNotified + 1;
			return;
		elseif (player.gasNotified == PLUGIN.notifyTicks) then
			if (player:GetFilterQuality() == 0) then
				if Schema:PlayerIsCombine(player) && player:GetSharedVar("GasMaskInfo") > 0 then
					player:EmitSound("player/geiger3.wav")
				end;
			end;
			player.gasNotified = player.gasNotified + 1;
		end;

		local playerGasDamageScale = 1;
		local filterQuality = player:GetFilterQuality();
		local filterDecrease = gasScale * 0.02;

      if ( player:KeyDown( IN_SPEED ) and filterQuality > 0 ) then
      	if (filterQuality > filterDecrease) then	
      		  player:UpdateFilterQuality(-filterDecrease * 10);
					  playerGasDamageScale = 0;
				end;
      end;

		if (filterQuality > 0) then
			if (filterQuality > filterDecrease) then
				player:UpdateFilterQuality(-filterDecrease);
				playerGasDamageScale = 0;
				Clockwork.attributes:Update(player, ATB_TOX, 0.001);
			else
				player:SetFilterQuality(0);
				playerGasDamageScale = math.Clamp(1 - (filterQuality / filterDecrease), 0, 1);
        Clockwork.chatBox:SendColored(player, Color(101, 45, 18), "Вы ощущаете, как ваш фильтр перестает обновлять воздух в противогазе.");
        player:EmitSound("npc/turret_floor/click1.wav")
			end;
		end;
		if (playerGasDamageScale > 0) then
			if (!player.nexttox or CurTime() >= player.nexttox) then
				if (tonumber(player:GetCharacterData("Toxins")) != -1 and filterQuality == 0) then
						if Schema:PlayerIsCombine(player) && player:GetSharedVar("GasMaskInfo") > 0 then
							Schema:AddCombineDisplayLine( "Изменение в показателях жизнедеятельности! Токсины: +"..(player:GetCharacterData("Toxins")/100).."%", Color(100, 100, 255), player );
							player:EmitSound("player/geiger3.wav")
						end;
					player:SetCharacterData( "Toxins", math.Clamp(player:GetCharacterData("Toxins") + (gasScale * PLUGIN.gasTickTime + 1 - GetSkillValue(player, ATB_TOX)), 0, 1000) );
					Clockwork.attributes:Update(player, ATB_TOX, 0.04);
				end;
				player.nexttox = CurTime() + 2;
	    	end;
		end;
		
   end;
end;

function PLUGIN:PlayerThink(player, curTime, infoTable)

if (!player.nextHeal or CurTime() >= player.nextHeal) then
  	if (player:GetCharacterData("Toxins") >= 200) then
		player:EmitSound("usesound/cough_2.mp3");
		if !player:HasSym("bloodcough") then
			if math.random(0, 100) - (player:GetCharacterData("Toxins")/10) > player:Health() then
				player:AddSympthom("bloodcough")
			end;
		end;
	end;
	if (player:GetCharacterData("Toxins") >= 900) then
		player:SetHealth(math.Clamp(player:Health() - 2, 1, 100));
	end;
  player.nextHeal = CurTime() + 25;
end;
	if (player:Alive()) then
		if (!player.nexttoxd or CurTime() >= player.nexttoxd) then
			
			player:SetCharacterData( "Toxins", math.Clamp(player:GetCharacterData("Toxins") - math.floor(1.5 * 0.5), 0, 1000) );
			player.nexttoxd = CurTime() + 10;
	  	end;
	  	if (player:Health() == 1 and player:GetCharacterData("Toxins") >= 950) then
  	  		Clockwork.player:SetRagdollState(player, RAGDOLL_KNOCKEDOUT, 630);
		end;
	end;

end;

function PLUGIN.OnGasChange(player, id, oldScale, newScale)

	if (newScale > 0 and (!player.gasNotified or player.gasNotified == 0)) then
		player.gasNotified = 1;

		if (player:GetFilterQuality() > 0) then
    		if Schema:PlayerIsCombine(player) && player:GetSharedVar("GasMaskInfo") > 0 then
				player:EmitSound("player/geiger"..math.random(1, 3)..".wav")
			end;
		elseif (player:GetFilterQuality() < 0) then
			if Schema:PlayerIsCombine(player) && player:GetSharedVar("GasMaskInfo") > 0 then
				player:EmitSound("player/geiger3.wav")
			end;
		end;
		
	elseif (newScale == 0 and player.gasNotified != 0) then                            
		player.gasNotified = 0;
	end;
	
end;

