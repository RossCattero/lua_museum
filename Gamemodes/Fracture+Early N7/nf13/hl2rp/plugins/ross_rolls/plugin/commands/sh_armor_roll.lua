local COMMAND = Clockwork.command:New("Aroll");
COMMAND.tip = "";
COMMAND.flags = CMD_DEFAULT;

function GetVictimPerkEndurance(endurance, hunger, thirst, sleep)
	local number = 0;

	number = 2 + endurance + hunger/100 + thirst/100 + sleep/100;
	return number;
end;

function GetTracedAttackInfo(trace, distance, irons)
	local hitBox = trace.HitGroup;
	local add = 0;
	local infoShoot = "на подавление";
	local dis = math.Round(math.Clamp(distance/100, 0.1, 1000));

	if dis < 15 then
		if hitBox == 1 then
			add = 4
			infoShoot = "в голову"
		elseif hitBox == 2 || hitBox == 3 then
			add = 2
			infoShoot = "в тело"
		elseif hitBox == 4 || hitBox == 5 then
			add = 2
			infoShoot = "в руки"
		elseif hitBox == 6 || hitBox == 7 then
			add = 2
			infoShoot = "в ноги"
		end;
	elseif dis >= 15 then
		add = 5
	end;

	return add, infoShoot

end;

function GetAttackerMisc(isIroned, distance, WepType)
	local add = 0;
	local dis = -5 + math.Round(math.Clamp(distance/100, 0.1, 1000))
	
	if wepType == 'shotgun' then
		dis = dis + (dis * 2);
	elseif wepType == 'melee' then
		dis = 500
	end;

	if isIroned then
		add = add + 2
	end;

	add = dis - add

	return add;
end;

function GetAttackerWeaponAdd(damage, quality)
	local add;
	
	add = damage + quality

	return add;
end;

function GetAttackerTraitPerkAdd(weaponAttribute, endurance)
	local add;
	
	add = (weaponAttribute*0.5) + (endurance*0.5)
	return math.Round( add );
end;

function Roll(player)
	local weapon = player:GetActiveWeapon();
	local trace = player:GetEyeTraceNoCursor();
	local getShootPos = player:GetShootPos();
	local distance = getShootPos:Distance(trace.HitPos);
	local wep = Clockwork.item:GetByWeapon(weapon);
	local enduranceAdd = GetSkillValue(player, ATB_ENDURANCE2);
	local victimEndurance = 0;
	local victimHunger = 0;
	local victimSleep = 0;
	local victimThirst = 0;
	local number = 0;
	local irons;
	local weaponAttribute;
	if wep == nil then
		return;
	end;
	local damage = wep:GetData("RollDamage");
	local quality = wep:GetData("Quality");
	if player:HoldingTFAweapon() then
		irons = weapon:GetIronSights();
	else
		irons = false;
	end;
	if IsWeaponAssault(weapon:GetClass()) then
		weaponAttribute = GetSkillValue(player, ATB_ASSAULT)
	elseif IsWeaponShotgun(weapon:GetClass()) then
		weaponAttribute = GetSkillValue(player, ATB_SHOTGUNS)
	elseif IsWeaponPistol(weapon:GetClass()) then
		weaponAttribute = GetSkillValue(player, ATB_PISTOLS)
	elseif IsWeaponMelee(weapon:GetClass()) then
		weaponAttribute = GetSkillValue(player, ATB_MELEE)
	end;
	if trace.Entity:IsPlayer() then
		victimEndurance = GetSkillValue(trace.Entity, ATB_ENDURANCE2)
		victimHunger = trace.Entity:GetNeed("hunger")
		victimThirst = trace.Entity:GetNeed("thirst")
		victimSleep = trace.Entity:GetNeed("sleep")
	end;

	local CountDistance = GetAttackerMisc(irons, distance, GetWeaponTFAtype( weapon:GetClass() ) );
	local TracedAttackInfo, where = GetTracedAttackInfo(trace, distance, irons);
	local addweaponInfo = GetAttackerWeaponAdd(damage, quality);
	local weaponAttributes = GetAttackerTraitPerkAdd(weaponAttribute, enduranceAdd);
	local victimAbilityToOff = GetVictimPerkEndurance(victimEndurance, victimHunger, victimThirst, victimSleep);

	number = addweaponInfo + weaponAttributes - CountDistance - TracedAttackInfo - victimAbilityToOff;
	number = math.Round(number);
	number = math.Clamp(number, -10, 20);

	return number, where;
end;

function COMMAND:OnRun(player, arguments)
	local trace = player:GetEyeTraceNoCursor();
	local weapon = player:GetActiveWeapon();
	local wep = Clockwork.item:GetByWeapon(weapon);
	local dI = player:GetCharacterData('NextDamageInfo');
	local getShootPos = player:GetShootPos();
	local distance = getShootPos:Distance(trace.HitPos);

	if wep == nil || dI.victimName != '' || trace.HitWorld || (player.cooldowned && CurTime() < player.cooldowned) || (IsWeaponMelee(weapon:GetClass()) && distance > 30) || player:GetFaction() == FACTION_VORTIGAUNT then
		Clockwork.player:Notify(player, 'Вы не можете сделать это сейчас!')
		return;
	end;

	if !player.cooldowned || CurTime() >= player.cooldowned then

	local number, where = Roll(player);
	local total;

	if number <= 5 then
		total = "промахивается"
	elseif number <= 10 then
		total = "слегка задевает"
	elseif number <= 15 then
		total = "наносит ранение"
	elseif number > 15 then
		total = "критически ранит"
	end;

	Clockwork.chatBox:AddInRadius(player, "roll", "получил значение: "..tostring(number).."/20. Он стреляет "..where..". Как итог: "..total..".", player:GetPos(), Clockwork.config:Get("talk_radius"):Get());
	if number > 0 then
		Clockwork.hint:SendCenter(player, "Следующий ваш выстрел в конкретную часть тела будет иметь модифицированный урон(Если это подавление, то урон наносится в любую часть тела).", 5, Color(100, 255, 100), true, true);
	end;
	if trace.Entity:IsPlayer() then
		Clockwork.chatBox:SendColored(trace.Entity, Color(255, 100, 100), player:GetName().." атакует вас в "..where.." с шансом "..tostring(number)..". Как итог: "..total..".")
	end;

	if number > 5 then
		if number >= 5 then
			dI.nextdamage = math.random(5, number)
		elseif number >= 10 then
			dI.nextdamage = math.random(10, number)
		elseif number >= 15 then
			dI.nextdamage = math.random(15, 20)
		end;
		dI.limbus = trace.HitGroup;
		if trace.Entity:IsPlayer() then
			dI.victimName = trace.Entity:GetName();
		else
			dI.victimName = trace.Entity:GetClass();
		end;
		dI.vic = trace.Entity
	end;

	player.CoolDownTillExpire = CurTime() + 60
	
	player.cooldowned = CurTime() + 5
	end;
end;

COMMAND:Register();