local PLUGIN = PLUGIN;

local hurtID, bleedID = "HurtTimer", "BleedTimer"
function HurtsFunction()
	local players = player.GetAll()

	for i = 1, #players do
		local player = players[i];
		local char = player:GetCharacter();
		if IsValid(player) && player:Alive() && char then
			local bio = player:GetBio()
			if bio then
				local injs, shock, wounded, cons = player:GetLimbs(), player:GetShock(), player:IsWounded(), char:GetData("UnCons")
				player:AddHurt(-1);

				if wounded && math.random(100) > 90 then

					print(!player:GetNetVar("actEnterAngle"))
					if !player:GetNetVar("actEnterAngle") then 
						player:Confuse(true, cons) 
					end
					if !cons then 
						player:EmitPainSound() 
					end;
					if shock < LIMB.SHOCK_AMOUNT && !player:CheckBlood() && wounded then 
						player:Confuse(false) 
					end;

				elseif !wounded && shock >= LIMB.SHOCK_AMOUNT then
					player:Confuse(true, true)
				end

				player:AddShock(-1);
			end
		end
	end;
end;

function BleedFunction()
	for k, v in pairs( LIMB.BLEEDS ) do
		local target = v.player
		local char = target:GetCharacter()

		if IsValid(target) && char && char:GetID() == k then
			local bio = v:GetData("Biology");
			if bio then
				if !target:Alive() || bio.bleeding == 0 then
					target:BloodDrop( nil )
				else
					target:SetBlood( bio.bleeding )
					target:ViewPunch( Angle( -0.5, 0, 0 ) )
				end;			
			end;
		end
	end
end

timer.Create(hurtID, 1, 0, HurtsFunction)
timer.Create(bleedID, LIMB.TICK_BLOOD, 0, BleedFunction)