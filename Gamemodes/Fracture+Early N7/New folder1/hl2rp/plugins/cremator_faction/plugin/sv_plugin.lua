local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

-- Adds the "HL2 Beta SNPCs" workshop file to the server's FastDL.
resource.AddWorkshop("471331755");
resource.AddWorkshop("254077907");


-- Called when a player's weapons should be given.
function PLUGIN:PlayerGiveWeapons(player)
	if (player:GetFaction() == FACTION_CREMATOR) then
		Clockwork.player:GiveSpawnWeapon(player, "cw_immolator");
	end;
end;

-- Called at an interval while a player is connected.
function PLUGIN:PlayerThink(player, curTime, infoTable)
	local CrematorSound = "npc/cremator/amb_loop.wav"
	local sound = CreateSound(player, "npc/cremator/amb_loop.wav");
	local faction = player:GetFaction();

	if (player:Alive() and !player:IsRagdolled()) then
		if ( faction == FACTION_CREMATOR ) then
			sound:Play();
		else
			sound:Stop();
		end;
	end;

	if faction == FACTION_CREMATOR then
		infoTable.walkSpeed = 80
	end;
end;

function PLUGIN:EntityTakeDamage(entity, damageInfo)

	if entity:IsPlayer() then
		if entity:GetFaction() == FACTION_CREMATOR && damageInfo:IsDamageType( 8 ) then
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
	local faction = player:GetFaction();
			
	if ( faction == FACTION_CREMATOR ) then
		local crmsound = "npc/cremator/crem_die.wav";
		for k, v in ipairs( _player.GetAll() ) do
			if (v:HasInitialized()) then
				 if	( faction == FACTION_CREMATOR or faction == FACTION_MPF or faction == FACTION_OTA ) then
					v:EmitSound(crmsound);
					Schema:AddCombineDisplayLine( "Биосигнал крематора потерян...", Color(255, 0, 0, 255) );
				end;
			end;
		end;
	end;		
	return crmsound;
end;

-- Called when a player's default inventory is needed.
function PLUGIN:GetPlayerDefaultInventory(player, character, inventory)
	if (character.faction == FACTION_CREMATOR) then
		Clockwork.inventory:AddInstance(
			inventory, Clockwork.item:CreateInstance("handheld_radio")
		);
	end;
end;
		
-- Called when a player's footstep sound should be played.
function PLUGIN:PlayerFootstep(player, position, foot, sound, volume, recipientFilter)
	local model = string.lower( player:GetModel() );

	if (string.find(model, "cremator")) then
		local randomNumber = math.random(1, 3);
				
		sound = "npc/cremator/foot"..randomNumber..".wav";
	end;
	
	player:EmitSound(sound);
	
end;

-- Called just after a player spawns.
function PLUGIN:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)
	local faction = player:GetFaction();

		if (player:GetFaction() == FACTION_CREMATOR) then
			player:SetMaxHealth(600);
			player:SetMaxArmor(0);
			player:SetHealth(600);
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