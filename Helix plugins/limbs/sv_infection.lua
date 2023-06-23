local PLUGIN = PLUGIN

INJ_ACTIONS = {}

-- target = player;
-- bone = string;
-- inj = number;
INJ_ACTIONS.infect = function(target, bone, inj)
	if !target:IsValid() then return end;
	local data = target:GetCharacter():GetData("Limbs");

	local injury = data[bone][inj]
	if !injury then return end;

	local injData = LIMB_INJURIES[injury.index];
	if !injData then return end;

	if injData.canInfect then
		data[bone][inj].infected = CurTime() + LIMB_INFECT_TIME;
	end

	target:UpInfo("Limbs", data);
end;

INJ_ACTIONS.remove = function(target, bone, inj)
	if !target:IsValid() then return end;
	local data = target:GetCharacter():GetData("Limbs");

	local injury = data[bone][inj]
	if !injury then return end;

	data[bone][inj] = nil;

	target:SortInjuries(bone)
end;

INJ_ACTIONS.spread = function(target, bone, inj)
	if !target:IsValid() then return end;
	local data = target:GetCharacter():GetData("Limbs");

	local injury = data[bone][inj]
	if !injury then return end;

	local injData = LIMB_INJURIES[injury.index];
	if !injData then return end;

	if injury.infected && injury.infected <= CurTime() then
		-- Вставить исполнение появления инфекции (!!!)
	end
end;