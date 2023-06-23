
local PLUGIN = PLUGIN;

function PLUGIN:PlayerSaveCharacterData(player, data)
	if (data["stamina"]) then data["stamina"] = data["stamina"]; end;
end;

-- Called when a player's character data should be restored.
function PLUGIN:PlayerRestoreCharacterData(player, data)
	if (!data["stamina"]) then data["stamina"] = 100 end;
end;

-- Called just after a player spawns.
function PLUGIN:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)
	if (!firstSpawn && !lightSpawn) then
		player:SetCharacterData("stamina", 100);
	end;
end;

function PLUGIN:PlayerThink(player, curTime, infoTable)
    local jumpPower = Clockwork.config:Get("jump_power"):Get();
    local hunger = player:GetNeed("hunger");
    local thirst = player:GetNeed("thirst");
    local sleep = player:GetNeed("sleep");
    local stam = player:GetCharacterData('stamina');
    player:SetJumpPower( math.Clamp( stam + sleep, 1, jumpPower) )
end;

function PLUGIN:SetupMove(player, mv, cmd)
    if !player:HasInitialized() or player:GetMoveType() == MOVETYPE_NOCLIP or player:GetFaction() == FACTION_SCANNER then
        return;
    end;
    local stam, sleep = player:GetCharacterData('stamina'), player:GetNeed("sleep");
    local walkbutton = cmd:KeyDown(IN_MOVELEFT) or cmd:KeyDown(IN_MOVERIGHT) or cmd:KeyDown(IN_FORWARD) or cmd:KeyDown(IN_BACK);
    local jumpbutton = mv:KeyPressed(IN_JUMP);
    local crouchbutton = cmd:KeyDown(IN_DUCK)
    local keybuttons = walkbutton and cmd:KeyDown(IN_SPEED)
    local chest = Clockwork.limb:GetHealth(player, HITGROUP_CHEST);
    local number = player:GetCharacterData("GasMaskInfo") || 0
    local invw = player:GetInventoryWeight();
    local maxWeight = player:GetMaxWeight();

    if invw > maxWeight+2 then
        mv:SetMaxClientSpeed( 1 )
        mv:SetMaxSpeed( 1 )
        return;
    end;
    if player:GetFaction() == FACTION_CREMATOR then
        mv:SetMaxClientSpeed( 70 )
        mv:SetMaxSpeed( 70 )
        return;
    end;

    if keybuttons then
        player:SetCharacterData('stamina', math.Clamp(stam - ((math.random(5, 11)/100) + (100-sleep)/1000) + ((100-chest)/1000) - number/1000, 0, 100))
    elseif !keybuttons then
        player:SetCharacterData('stamina', math.Clamp(stam + ( (math.random(1, 5)/1000) ) + sleep/1000 + chest/1000 + number/1000, 0, 100) )
    end;
    if crouchbutton && walkbutton then
        player:SetCharacterData('stamina', math.Clamp(stam - (math.random(1, 5)/100), 0, 100))
    end;
    if jumpbutton then
        player:SetCharacterData('stamina', math.Clamp(stam - 35, 0, 100))
    end;

    if keybuttons then
        mv:SetMaxClientSpeed( 25 + (stam*2) )
        mv:SetMaxSpeed( 25 + (stam*2) )
    end;
    if crouchbutton && walkbutton then
        mv:SetMaxClientSpeed( 30 + (stam/10) )
        mv:SetMaxSpeed( 30 + (stam/10) )
    end;
    if walkbutton and !cmd:KeyDown(IN_SPEED) then
        mv:SetMaxClientSpeed( 10 + stam )
        mv:SetMaxSpeed( 10 + stam)
    end;
    
    if (stam < 15) then
        playBreathSound = true;
    elseif stam > 15 then
        playBreathSound = false;
	end;
	
	if (!player.nextBreathingSound or CurTime() >= player.nextBreathingSound) then
		if (!Clockwork.player:IsNoClipping(player)) then
			player.nextBreathingSound = CurTime() + 1;
			
            if (playBreathSound) then
				Clockwork.player:StartSound(player, "LowStamina", "player/breathe1.wav", 100);
			else
				Clockwork.player:StopSound(player, "LowStamina", 4);
			end;
		end;
    end;
    
end;

function PLUGIN:PlayerSetSharedVars(player, curTime)
	player:SetSharedVar("stamina", player:GetCharacterData("stamina"));
end;