--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).

	Clockwork was created by Conna Wiles (also known as kurozael.)
	http://cloudsixteen.com/license/clockwork.html
--]]

-- Called when a player's character data should be saved.
function cwStamina:PlayerSaveCharacterData(player, data)
	if (data["Stamina"]) then
		data["Stamina"] = math.Round(data["Stamina"]);
	end;
end;

-- Called when a player's character data should be restored.
function cwStamina:PlayerRestoreCharacterData(player, data)
	if (!data["Stamina"]) then
		data["Stamina"] = 100;
	end;
	if (!data["MaxStamina"]) then
		data["MaxStamina"] = 100;
	end;
end;

-- Called just after a player spawns.
function cwStamina:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)
	if (!firstSpawn and !lightSpawn) then
		player:SetCharacterData("Stamina", 100);
	end;
end;

-- Called when a player attempts to throw a punch.
function cwStamina:PlayerCanThrowPunch(player)
	if (player:GetCharacterData("Stamina") <= 10) then
		return false;
	end;
end;

-- Called when a player throws a punch.
function cwStamina:PlayerPunchThrown(player)
	local decrease = 5 / (player:GetCharacterData("GasMaskInfo") + 5);
	local maxStamina = player:GetCharacterData("MaxStamina") - (player:GetNeed("thirst")*0.5)
	
	player:SetCharacterData("Stamina", math.Clamp(player:GetCharacterData("Stamina") - decrease, 0, maxStamina));
end;

-- Called when a player's shared variables should be set.
function cwStamina:PlayerSetSharedVars(player, curTime)
	player:SetSharedVar("Stamina", math.floor(player:GetCharacterData("Stamina")));
end;

-- Called when a player's stamina should regenerate.
function cwStamina:PlayerShouldStaminaRegenerate(player)
	return true;
end;

-- Called when a player's stamina should drain.
function cwStamina:PlayerShouldStaminaDrain(player)
	return true;
end;

-- Called at an interval while a player is connected.
function cwStamina:PlayerThink(player, curTime, infoTable)
	local maxStamina = player:GetCharacterData("MaxStamina") - (player:GetNeed("thirst")*0.5)
	local regenScale = Clockwork.config:Get("stam_regen_scale"):Get();
	local drainScale = Clockwork.config:Get("stam_drain_scale"):Get();
	local regeneration = 0;
	local maxHealth = player:GetMaxHealth();
	local healthScale = (drainScale * (math.Clamp(player:Health(), maxHealth * 0.1, maxHealth) / maxHealth));
	local chestDamage = Clockwork.limb:GetHealth(player, HITGROUP_CHEST);
	local decrease = (drainScale + (drainScale - healthScale)) - ((drainScale * 0.5) - (100/chestDamage*0.5) + (tonumber(player:GetCharacterData("GasMaskInfo")) * 0.15) );
	
	if (!player:IsNoClipping() and player:IsOnGround()) then
		local playerVelocityLength = player:GetVelocity():Length();
		if ((infoTable.isRunning or infoTable.isJogging) and playerVelocityLength != 0) then
			if (Clockwork.plugin:Call("PlayerShouldStaminaDrain", player)) then
				player:SetCharacterData("Stamina", math.Clamp(player:GetCharacterData("Stamina") - decrease, 0, maxStamina));
			end;
		elseif (playerVelocityLength == 0) then
			if (player:Crouching()) then
				regeneration = (regenScale + 1) * 2;
			else
				regeneration = (regenScale + 1);
			end;
		else
			regeneration = regenScale / 3;
		end;
	end;

	if (regeneration > 0 and Clockwork.plugin:Call("PlayerShouldStaminaRegenerate", player)) then
		player:SetCharacterData("Stamina", math.Clamp(player:GetCharacterData("Stamina") + regeneration, 0, maxStamina));
	end;
	
	local newRunSpeed = infoTable.runSpeed * 2;
	local diffRunSpeed = newRunSpeed - infoTable.walkSpeed;
	local maxRunSpeed = Clockwork.config:Get("run_speed"):Get();

	infoTable.runSpeed = math.Clamp(newRunSpeed - (diffRunSpeed - ((diffRunSpeed / 100) * player:GetCharacterData("Stamina"))), infoTable.walkSpeed, maxRunSpeed);
	
	if (infoTable.isJogging) then
		local walkSpeed = Clockwork.config:Get("walk_speed"):Get();
		local newWalkSpeed = walkSpeed * 1.75;
		local diffWalkSpeed = newWalkSpeed - walkSpeed;

		infoTable.walkSpeed = newWalkSpeed - (diffWalkSpeed - ((diffWalkSpeed / 100) * player:GetCharacterData("Stamina")));
		
		if (player:GetCharacterData("Stamina") < 1) then
			player:SetSharedVar("IsJogMode", false);
		end;
	end;
	
	local stamina = player:GetCharacterData("Stamina");
	
	if (stamina < 30 and Clockwork.event:CanRun("sounds", "breathing")) then
		playBreathSound = true;
	end;
	
	if (!player.nextBreathingSound or curTime >= player.nextBreathingSound) then
		if (!Clockwork.player:IsNoClipping(player)) then
			player.nextBreathingSound = curTime + 1;
			
			if (playBreathSound) then
				local volume = Clockwork.config:Get("breathing_volume"):Get() - stamina;

				Clockwork.player:StartSound(player, "LowStamina", "player/breathe1.wav", volume / 100);
			else
				Clockwork.player:StopSound(player, "LowStamina", 4);
			end;
		end;
	end;
end;
