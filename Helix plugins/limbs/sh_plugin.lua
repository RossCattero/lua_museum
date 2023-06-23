local PLUGIN = PLUGIN

PLUGIN.name = "Limbs"
PLUGIN.author = "Ross Cattero"
PLUGIN.description = ""

ix.util.Include("cl_plugin.lua")
ix.util.Include("sv_plugin.lua")

ix.util.Include("timers/cl_timers.lua")
ix.util.Include("timers/sv_timers.lua")

ix.util.Include("meta/sh_meta.lua")
ix.util.Include("meta/sv_meta.lua")

ix.util.Include("sv_infection.lua")

function PLUGIN:Move(client, mov)
	if client:IsBot() then return end;
	local character = client:GetCharacter()
	if IsValid(client) && client:Alive() && character && !client:GetLocalVar("ragdoll") then
		if client:GetNoDraw() then return end;
		local limbs = character:GetData("Limbs")
		local rLeg = #limbs["right_leg"] + #limbs["right_foot"];
		local lLeg = #limbs["left_leg"] + #limbs["left_foot"];
		
		local mClientSpeed, mSpeed = mov:GetMaxClientSpeed(), mov:GetMaxSpeed()
		local jumpPower = client:GetJumpPower()
		local amount = ((rLeg + lLeg) * 15);
		local getAmount = math.Clamp(mClientSpeed - amount, 25, mClientSpeed);

		if amount > 25 then
				mov:SetButtons(bit.band(mov:GetButtons(), bit.bnot(IN_JUMP)))
				if (mov:KeyDown(IN_SPEED)) then
					mov:SetMaxClientSpeed(getAmount)
					mov:SetMaxSpeed(getAmount)
				end
		end;

		if rLeg && lLeg then
				mov:SetMaxClientSpeed(getAmount)
				mov:SetMaxSpeed(getAmount)
		end
	end;
end;