local math = math;
local clamp = math.Clamp;
local mmax = math.max;
local rand = math.random;
local round = math.Round;

local min = 0;
local max = 100;

local ply = FindMetaTable("Player")

function ply:SetStamina(number)
    local char = self:GetCharacter()

    self:SetLocalVar('stamina', number);
    char:SetData('stamina', number);
end;

function PLUGIN:OnCharacterCreated(client, character)
    character:SetData("stamina", max)
end

function PLUGIN:PlayerLoadedCharacter(client, character)
    timer.Simple(0.25, function()
        client:SetLocalVar("stamina", character:GetData("stamina", max))
    end)
end

function PLUGIN:CharacterPreSave(character)
    local client = character:GetPlayer()

    if (IsValid(client)) then
        character:SetData("stamina", client:GetLocalVar("stamina", min))
    end
end

function PLUGIN:SetupMove(player, mv, cmd)
    local char = player:GetCharacter()
    if !char or player:GetMoveType() == MOVETYPE_NOCLIP then
        return;
    end;

    local stam, sleep, stamattrib = player:GetLocalVar('stamina', max), player:GetLocalVar("sleep", max), char:GetAttribute("stamina")
    local walkbutton = cmd:KeyDown(IN_MOVELEFT) or cmd:KeyDown(IN_MOVERIGHT) or cmd:KeyDown(IN_FORWARD) or cmd:KeyDown(IN_BACK);
    local jumpbutton = mv:KeyPressed(IN_JUMP);
    local crouchbutton = cmd:KeyDown(IN_DUCK)
    local keybuttons = walkbutton and cmd:KeyDown(IN_SPEED)
    local bufHealth = player:Health();
    local health = 4 - round(bufHealth/25);

    if keybuttons then
        player:SetStamina( clamp(stam - mmax(rand(6, 8)/max + stamattrib/max - health, 0.1), min, sleep) )
    else
        if stam >= 30 then
            player:SetStamina( clamp(stam + mmax(rand(13, 17)/max + stamattrib/max - health, 0.1), min, sleep) )
            if rand(max) > 95 then
                char:UpdateAttrib("stamina", 0.00001)
            end;
        else
            player:SetStamina( clamp(stam + mmax(rand(2, 5)/max + stamattrib/max - health, 0.1), min, sleep) )
        end;
    end;

    if char:Overweight() then
		mv:SetMaxClientSpeed( 5 )
        mv:SetMaxSpeed( 5 )
        player:SetJumpPower(25)
	end;
    
    if stam < 15 then
        mv:SetMaxClientSpeed( clamp(stam, 10, 225) )
        mv:SetMaxSpeed( clamp(stam, 10, 225) )

        player:SetJumpPower(25)
    elseif !char:Overweight() then
        player:SetJumpPower(150)
    end;

    if jumpbutton then 
        player:SetStamina( clamp(stam - 35, min, max) )
    end;

    if (stam < 35) then
        playBreathSound = true;
    elseif stam >= 35 then
        playBreathSound = false;
	end;
	
	if (!player.nextBreathingSound or CurTime() >= player.nextBreathingSound) then
		if (player:GetMoveType() != MOVETYPE_NOCLIP) then
			player.nextBreathingSound = CurTime() + 1;
            if (playBreathSound) then
				StartSound(player, "LowStamina", "player/breathe1.wav", 100);
			else
				StopSound(player, "LowStamina", 2);
			end;
		end;
    end;
    
end;

function PLUGIN:EntityTakeDamage(entity, dmgInfo)
    if entity:IsValid() && entity:IsPlayer() && entity:Alive() then
        local char = entity:GetCharacter()
        if rand(max) > 95 then
            char:UpdateAttrib("endurance", 0.003)
        end;
    end;
end;

function PLUGIN:PlayerDeath(client, inflictor, attacker)
    local char = client:GetCharacter()
    if char:GetAttribute('endurance') - 0.01 >= 0 then
        char:UpdateAttrib("endurance", -0.01);
    end;
end;

function PLUGIN:KeyPress(ply, key)
    local stam = ply:GetLocalVar('stamina', 100);
    if stam >= 30 && !ply:KeyDown(IN_DUCK) && key == IN_JUMP && ply:GetMoveType() != MOVETYPE_NOCLIP then
        if timer.Exists("ixJumpPlayer "..ply:SteamID()) then return end;
        timer.Create("ixJumpPlayer "..ply:SteamID(), 0.5, 1, function()
            if ply:IsOnGround() then
                ply:GetCharacter():UpdateAttrib("dexterity", 0.001)
            else
                ply:GetCharacter():UpdateAttrib("dexterity", 0.01)
                ply:SetStamina( math.Clamp(stam - 50, 0, 100) )
            end;
        end)
    end;
end;