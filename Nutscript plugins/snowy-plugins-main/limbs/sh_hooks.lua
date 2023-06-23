local PLUGIN = PLUGIN;

function PLUGIN:SetupMove(ply, mov, cmd)
	if ply:IsBot() then return end;
	if IsValid(ply) && ply:Alive() && ply:IsPlayer() && ply:getChar() then
			local rl, ll;
			local maxClientSpeed, maxSpeed = mov:GetMaxClientSpeed(), mov:GetMaxSpeed()
			local rightLeg, leftLeg = ply:GetLimb(6), ply:GetLimb(7)
			local maxRight, maxLeft = DefaultLimb(6), DefaultLimb(7)
			local jumpPower = ply:GetJumpPower()

			if rightLeg && leftLeg then
					rl = math.Clamp(maxRight - rightLeg, 0, maxRight);
					ll = math.Clamp(maxLeft - leftLeg, 0, maxLeft)
			end

			local legs = (rl + ll)

			mov:SetMaxClientSpeed( 
				math.Clamp(maxClientSpeed - legs, 35, maxClientSpeed) 
			)
			mov:SetMaxSpeed( 
				math.Clamp(maxClientSpeed - legs, 35, maxClientSpeed) 
			)
			ply:SetJumpPower(200 - legs)

			if legs > 50 && !ply:GetNoDraw() then
					mov:SetButtons(bit.band(mov:GetButtons(), bit.bnot(IN_JUMP)))
			end;
	end;
end;