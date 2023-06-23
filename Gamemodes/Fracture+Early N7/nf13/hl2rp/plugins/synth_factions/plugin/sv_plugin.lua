local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

-- Called at an interval while a player is connected.
function PLUGIN:PlayerThink(player, curTime, infoTable)
	local CrematorSound = "npc/cremator/amb_loop.wav"
	local sound = CreateSound(player, "npc/cremator/amb_loop.wav");
	local randomNumber = math.random(1, 3);
	local faction = player:GetFaction()
	if player:Alive() and !player:IsRagdolled() && (faction == FACTION_CREMATOR or faction == FACTION_GUARDER) then
		if player:GetVelocity():Length() > 0 then
			if !player.CremFootStep or curTime >= player.CremFootStep then
				player:EmitSound("npc/cremator/foot"..randomNumber..".wav");
				player.CremFootStep = curTime + 1
			end;
		end;
		sound:Play();
	else
		sound:Stop();
	end;
end;

-- Called when a player's footstep sound should be played.
function PLUGIN:PlayerFootstep(player, position, foot, sound, volume, recipientFilter)
	if player:GetFaction() == FACTION_STALKER then
		if foot == 1 then
			sound = 'npc/cstalker/stalker_footstep_left'..math.random(1, 2)..'.wav'
		end;
	end;
	
	player:EmitSound(sound);
	return true
end;

function PLUGIN:EntityTakeDamage(entity, damageInfo)

	if entity:IsPlayer() then
		if entity:GetFaction() == FACTION_CREMATOR then
			if damageInfo:IsDamageType( 8 ) then
				damageInfo:ScaleDamage( 0 )
			elseif damageInfo:IsDamageType( 2 ) then
				damageInfo:ScaleDamage( 0.4 )
			end;
		end;
		if entity:GetFaction() == FACTION_ASSASIN && damageInfo:IsDamageType( 32 ) then
			damageInfo:ScaleDamage( 0 )
		end;
	end;
end;

-- Called when a player's typing display has started.
function PLUGIN:PlayerStartTypingDisplay(player, code)
	local faction = player:GetFaction();
	if ( faction == FACTION_CREMATOR ) then
		if (code == "n" or code == "y" or code == "w" or code == "r") then
			if (!player.typingBeep) then
				player.typingBeep = true;
				
				player:EmitSound("npc/overwatch/radiovoice/on3.wav");
			end;
		end;
	end;
end;

-- Called when a player's typing display has finished.
function PLUGIN:PlayerFinishTypingDisplay(player, textTyped)
	local faction = player:GetFaction();
	if ( faction == FACTION_CREMATOR and textTyped ) then
		if (player.typingBeep) then
			player:EmitSound("npc/overwatch/radiovoice/off4.wav");
		end;
	end;
	
	player.typingBeep = nil;
end;

-- Called when a player's character has initialized.
function PLUGIN:PlayerCharacterInitialized(player)
	local faction = player:GetFaction();
	
	if (faction == FACTION_CREMATOR) then
		Schema:AddCombineDisplayLine( "Обнаружен крематор!", Color(255, 165, 0, 255) );
	end;
end;

-- Called when a player's death sound should be played.
function PLUGIN:PlayerPlayDeathSound(player, gender)
	if ( faction == FACTION_CREMATOR ) then
		for k, v in ipairs( cwPlayer.GetAll() ) do
			if (v:HasInitialized()) then
				 if	( Schema:PlayerIsCombine(v) ) then
					cable.send(v, 'CreateWaypoint', player:GetPos(), player:Name(), 221, 'loss');
					Clockwork.player:PlaySound(v, "npc/cremator/crem_die.wav")
				end;
			end;
		end;
		Schema:AddCombineDisplayLine( "КРЕМАТОР УНИЧТОЖЕН!", Color(255, 100, 100, 255) );
		return "npc/cremator/crem_die.wav";
	end;
end;

--A Function to check if the player can open a Combine Door.
function PLUGIN:PlayerCanUseDoor(player, door)
    if player:GetFaction() == FACTION_CREMATOR then
        return true;
    end;
end;

-- Called when a player's pain sound should be played.
function PLUGIN:PlayerPlayPainSound(player, gender, damageInfo, hitGroup)
	local faction = player:GetFaction();
	if ( faction == FACTION_CREMATOR ) then
		return "npc/combine_soldier/pain"..math.random(1, 3)..".wav";
	end;
end;