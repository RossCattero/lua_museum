local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

STAMINA_MAX = 100.0
STAMINA_COST_JUMP = 25.0
STAMINA_COST_FALL = 20.0
STAMINA_RECOVER_RATE = 19.0

function PLUGIN:PlayerBindPress( ply, bind, pressed )
	if string.find( bind, "+walk" ) then 
		if !IsValid(ply:GetVehicle()) then
			return true 
		end
	end
end

function ReduceTimers( ply )
	if !ply:GetNWFloat("jumpstamina") then ply:SetNWFloat("jumpstamina",0) end

	local frame_msec = 1000.0 * FrameTime()

	if ply:GetNWFloat("jumpstamina") > 0 then
		ply:SetNWFloat("jumpstamina", ply:GetNWFloat("jumpstamina") - frame_msec )

		if ply:GetNWFloat("jumpstamina") < 0 then
			ply:SetNWFloat("jumpstamina", 0 )
		end
	end
end
function CheckJump( ply, mv, velocity )
	if !ply:Alive() then
		local buttons = bit.bor( mv:GetOldButtons(), IN_JUMP )
		mv:SetOldButtons( buttons )
		return
	end
	if ply:WaterLevel() >= 2 then 
		return 
	end
	if ply:GetGroundEntity() == nil then
		local buttons = bit.bor( mv:GetOldButtons(), IN_JUMP )
		mv:SetOldButtons( buttons )
		return
	end
	if bit.band( mv:GetOldButtons(), IN_JUMP ) != 0 then
		return
	end

	if ply:GetNWFloat("jumpstamina") > 0 then
		local flRatio = ( STAMINA_MAX - ( ( ply:GetNWFloat("jumpstamina") / 1000.0 ) * STAMINA_RECOVER_RATE ) ) / STAMINA_MAX
		velocity.z = velocity.z * flRatio
	end
	ply:SetNWFloat("jumpstamina", ( STAMINA_COST_JUMP / STAMINA_RECOVER_RATE ) * 1000.0 )
	--[[
	local k = ply:GetCharacterData("Stamina") - 5
	if k < 0 then
		k = 0
	end
	ply:SetCharacterData("Stamina", k)
	]]

	return true
end
function PLUGIN:SetupMove( ply, mv, cmd )
	ReduceTimers( ply )

	local velocity = mv:GetVelocity()

	if bit.band( mv:GetButtons(), IN_JUMP ) != 0 then
		CheckJump( ply, mv, velocity )
	else
		local buttons = bit.band( mv:GetOldButtons(), bit.bnot( IN_JUMP ) )
		mv:SetOldButtons( buttons )
	end

	if ply:GetNWFloat("jumpstamina") > 0 and ply:IsOnGround() then
		local flRatio = ( STAMINA_MAX - ( ( ply:GetNWFloat("jumpstamina") / 1000.0 ) * STAMINA_RECOVER_RATE ) ) / STAMINA_MAX

		local flReferenceFrametime = 1.0 / 70.0
		local flFrametimeRatio = FrameTime() / flReferenceFrametime

		flRatio = math.pow( flRatio, flFrametimeRatio )

		velocity.x = velocity.x * flRatio
		velocity.y = velocity.y * flRatio
	end

	mv:SetVelocity( velocity )
end