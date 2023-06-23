local PLUGIN = PLUGIN;

-- Called each tick.
function PLUGIN:PlayerThink(player, curtime, info)
	if self:PlayerIsAntlion(player) then
		self:AntlionFlying(player);
		if (!self.nextChatterEmit || curtime >= self.nextChatterEmit) then
			player:EmitSound( 'npc/antlion/idle'..math.random(1, 5)..'.wav', 60)
			self.nextChatterEmit = curtime + math.random(5, 15);
		end;
	end;
end;

-- Called when a player's weapons should be given.
function PLUGIN:PlayerGiveWeapons(player)
	if (player:GetFaction() == FACTION_ANTLION) then
		Clockwork.player:GiveSpawnWeapon(player, "cw_antlionleap");
	end;
end;


--Function to play a sound when the player is in midair.
function PLUGIN:AntlionFlying(player)

	if (!player:IsOnGround()) and (player:Alive()) and (player:GetMoveType()==MOVETYPE_WALK) then
		self.flySound = CreateSound(player, "npc/antlion/fly1.wav");
		self.flySound:Play();
	end;
	
	if (player:IsOnGround()) and (self.flySound) then
		self.flySound:Stop();
	end;
end;
-- Called when a player's death sound should be played.
function PLUGIN:PlayerPlayDeathSound(player, gender)
	local antlionsound = "npc/antlion/distract1.wav";
		
	for k, v in ipairs( _player.GetAll() ) do
		if (v:HasInitialized()) then
			 if	( PLUGIN:PlayerIsAntlion(v) ) then
				v:EmitSound(antlionsound);
			end;
		end;
	end;
		
	if ( self:PlayerIsAntlion(player) ) then
		return antlionsound;
	end;
end;

-- Called when a player's footstep sound should be played.
function PLUGIN:PlayerFootstep(player, position, foot, sound, volume, recipientFilter)
	local clothes = player:GetCharacterData("clothes");
	local model = string.lower( player:GetModel() );
	local soundNumber = math.random(1, 4);
	
	if (string.find(model, "antlion")) then	
		sound = "npc/antlion/foot"..soundNumber..".wav";
		player:EmitSound(sound, 60);
	end;
end;

-- Called when a player's pain sound should be played.
function PLUGIN:PlayerPlayPainSound(player, gender, damageInfo, hitGroup)
	if (self:PlayerIsAntlion(player)) then
		return "npc/antlion/pain"..math.random(1, 2)..".wav";
	end;
end;