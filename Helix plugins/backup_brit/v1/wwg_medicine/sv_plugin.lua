local PLUGIN = PLUGIN

function PLUGIN:EntityTakeDamage(target, damage)
	local attacker, dmg, dmgType = damage:GetAttacker(), damage:GetDamage(), damage:GetDamageType()

	target = target:GetNetVar("player") || target;
	
	if dmg == 0 || !target:CanBeWounded() then return end;

	local trace = ix.medical.limbs.trace(attacker)

	if !trace then return end;

	local bone = ix.medical.limbs.FindBone(target, trace.PhysicsBone)
	if !bone then bone = "torso" end;

	local multDmg = ix.medical.cfg.multiply[bone] || 1;

	damage:ScaleDamage( multDmg )
end;