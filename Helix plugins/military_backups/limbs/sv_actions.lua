local PLUGIN = PLUGIN

LIMB.ACTIONS = {}

LIMB.ACTIONS.infect = function(target, bone, inj)
	if !target:IsValid() then return end;
	local data = target:GetLimbs()

	local injury = data[bone][inj]
	if !injury then return end;

	local injData = LIMB.INJURIES[injury.index];
	if !injData then return end;

	if injData.canInfect then
		data[bone][inj].infected = CurTime() + LIMB.INFECT_TIME;
	end

	target:UpInfo("Limbs", data);
end;

LIMB.ACTIONS.remove = function(target, bone, inj)
	if !target:IsValid() then return end;
	local data = target:GetLimbs()

	local injury = data[bone][inj]	
	if !injury then return end;
	
	local info = LIMB.INJURIES[injury.index];
	local critical = info.stageCritical;

	if info && (!critical || (critical && injury.stage < critical)) then
		target:RemoveInjury(bone, inj)
	end
end;

LIMB.ACTIONS.spread = function(target, bone, inj)
	if !target:IsValid() then return end;
	local data = target:GetLimbs()

	local injury = data[bone][inj]
	if !injury then return end;

	local injData = LIMB.INJURIES[injury.index];
	if !injData then return end;

	if injury.infected && injury.infected <= CurTime() then
		target:Kill()
	end
end;

LIMB.ACTIONS.heal = function(target, bone, inj)
	if !target:IsValid() then return end;
	local data = target:GetLimbs()

	local injury = data[bone][inj]
	if !injury then return end;

	local heal = target:GetHealed(bone, inj);

	if heal == "" then return end;

	local injData = LIMB.INJURIES[injury.index];
	if !injData then return end;

	target:SetHeal(bone, inj, heal)
end;