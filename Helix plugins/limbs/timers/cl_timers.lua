local PLUGIN = PLUGIN;

local id = "BonesRotting";
timer.Create(id, 1, 0, function()
	local ply = LocalPlayer();
	if !IsValid(ply) || !ply:GetCharacter() || !ply:Alive() then return end;
	
	local limbs = ply:GetLocalVar("Limbs")
	for k, v in pairs(limbs) do
		if #v > 0 then
			for i = 1, #v do
				local injury = limbs[k][i];
				if !injury.infected && (injury.expires && injury.expires <= CurTime()) then
					injury.expires = nil;
					if LIMB_INJURIES:CanRot(injury.index) then
						injury.infected = CurTime() + LIMB_INFECT_TIME;

						netstream.Start("Limbs::InjAction", "infect", k, i);
					elseif LIMB_INJURIES[injury.index] then
						limbs[k][i] = nil;
						LocalPlayer():SortInjuries(k)

						netstream.Start("Limbs::InjAction", "remove", k, i);
					end
				elseif injury.infected && CurTime() >= injury.infected then
					netstream.Start("Limbs::InjAction", "spread", k, i);
				end
			end
		end;
	end
end);