function PLUGIN:SetupMove(player, mv, cmd)
    if !player:GetCharacter() or player:GetMoveType() == MOVETYPE_NOCLIP then
        return;
    end;
    local stam, sleep = player:GetLocalVar('stamina');
    local walkbutton = cmd:KeyDown(IN_MOVELEFT) or cmd:KeyDown(IN_MOVERIGHT) or cmd:KeyDown(IN_FORWARD) or cmd:KeyDown(IN_BACK);
    local jumpbutton = mv:KeyPressed(IN_JUMP);
    local crouchbutton = cmd:KeyDown(IN_DUCK)
    local keybuttons = walkbutton and cmd:KeyDown(IN_SPEED)

    if stam < 15 then
        mv:SetMaxClientSpeed( math.Clamp(stam, 10, 225) )
        mv:SetMaxSpeed( math.Clamp(stam, 10, 225) )
        player:SetJumpPower(25)
	elseif !player:GetCharacter():Overweight() then
        player:SetJumpPower(150)
	end;
	if player:GetCharacter():Overweight() then
		mv:SetMaxClientSpeed( 5 )
		mv:SetMaxSpeed( 5 )
		player:SetJumpPower(25)
	end;

end;

netstream.Hook("StartSound", function(data)
	if (IsValid(LocalPlayer())) then
		local uniqueID = data.uniqueID;
		local sound = data.sound;
		local volume = data.volume;
		
		if (!ixClientSounds) then
			ixClientSounds = {};
		end;
		
		if (ixClientSounds[uniqueID]) then
			ixClientSounds[uniqueID]:Stop();
		end;
		
		ixClientSounds[uniqueID] = CreateSound(LocalPlayer(), sound);
		ixClientSounds[uniqueID]:PlayEx(volume, 100);
	end;
end);

netstream.Hook("StopSound", function(data)
	local uniqueID = data.uniqueID;
	local fadeOut = data.fadeOut;
	
	if (!ixClientSounds) then
		ixClientSounds = {};
	end;
	
	if (ixClientSounds[uniqueID]) then
		if (fadeOut != 0) then
			ixClientSounds[uniqueID]:FadeOut(fadeOut);
		else
			ixClientSounds[uniqueID]:Stop();
		end;
		
		ixClientSounds[uniqueID] = nil;
	end;
end);