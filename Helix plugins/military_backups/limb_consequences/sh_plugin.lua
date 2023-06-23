local PLUGIN = PLUGIN

PLUGIN.name = "LIMBS: Consequences"
PLUGIN.author = "Ross Cattero"
PLUGIN.description = "Модуль к базе частей тела, в котором описываются последствия повреждений."

ix.util.Include("cl_plugin.lua")

function PLUGIN:Move(client, mov)
	if client:IsBot() then return end;
	local character = client:GetCharacter()
	if IsValid(client) && client:Alive() && character && !client:GetLocalVar("ragdoll") then
		if client:GetNoDraw() then return end;
		local limbs = character:GetData("Limbs")
		local rLeg = #limbs["right_leg"] + #limbs["right_foot"];
		local lLeg = #limbs["left_leg"] + #limbs["left_foot"];
		
		local usedAction = client:GetLocalVar("isHealing") && 100 || 0
		local mClientSpeed, mSpeed, jumpPower = mov:GetMaxClientSpeed(), mov:GetMaxSpeed(), client:GetJumpPower()
		local amount = ((rLeg + lLeg) * 15) + usedAction;
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