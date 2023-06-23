local PLUGIN = PLUGIN;

local id = "BonesRotting";
timer.Create(id, 1, 0, function()
	local ply = LocalPlayer();
	if !IsValid(ply) || !ply:GetCharacter() || !ply:Alive() then return end;
	
	local limbs = ply:GetLimbs()
	for k, v in pairs(limbs) do
		if #v > 0 then
			for i = 1, #v do
				local injury = limbs[k][i]
				local heal = injury.heal;
				
				if heal != "" && injury.healTime && injury.healTime > CurTime() then
					PLUGIN:SendLimbAction("heal", k, i)
				elseif heal == "" then
					local injIndex, critStage = injury.index, injury.stageCritical
					if !injury.infected && (injury.expires && injury.expires <= CurTime()) then
						local info = LIMB.INJURIES[injIndex]
						
						injury.expires = nil;
						if LIMB:CanRot(injIndex) then
							injury.infected = CurTime() + LIMB.INFECT_TIME;

							PLUGIN:SendLimbAction("infect", k, i)
						elseif info && (!critStage || (critStage && injury.stage < critStage)) then
							limbs[k][i] = nil;

							PLUGIN:SendLimbAction("remove", k, i)
						end
					end
				end
				
			end
		end;
	end
end);