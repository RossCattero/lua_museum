local COMMAND = Clockwork.command:New("fRoll");
COMMAND.tip = "";
COMMAND.flags = CMD_DEFAULT;
COMMAND.alias = {"fr"};

local function CountDistance(player)
	local trace = player:GetEyeTrace();
	local weapon = player:GetActiveWeapon();
	local wepclass = weapon:GetClass();
	

	local irons, idontknow = weapon:IronSights();
	local multi = 0;

	if IsWeaponShotgun(wepclass) then
		decreace = 3
	else
		decreace = 0;
	end;

	if irons == true then
		multi = 1
	else
		multi = 0;
	end;

	local distance = math.Round(player:GetShootPos():Distance(trace.HitPos)/10)
	if distance <= 60 then
		return 0;
	end;

return math.Clamp(math.Round( (( ( (distance - 60) / 10) * 5) * 0.5) - multi + decreace ), 0, 100);
end;

local function TargetArmor(player, inflictor)
	local x = 0;
	local weapon = inflictor:GetActiveWeapon();
	local wep = Clockwork.item:GetByWeapon(weapon);
	local trace = inflictor:GetEyeTrace();
	local data = player:GetCharacterData("ClothesSlot");
	local hitgroup = trace.HitGroup;
	local irons, idontknow = weapon:IronSights();
	local hit = "";
	local random = math.random(1, 10)
	local hittext = "";
	local algebra = 0;
	local hardance = 0;

	if hitgroup == 1 && irons == true then
		if data["head"] == true || data["gasmask"] == true then
			hit = "head";
			x = GetClothesNumber(player, hit);
			hittext = "в голову(или противогаз)";
			hardance = 5;
		else
			hit = "head";
			x = GetClothesNumber(player, hit);
			hittext = "в голову(без защиты)";
			hardance = 4;
		end;
	end;
	if hitgroup == 2 || hitgroup == 3 || hitgroup == 10 && irons == true then
		hit = "body";
		x = GetClothesNumber(player, hit);
		hittext = "в тело";
		hardance = 2;
	end;
	if hitgroup == 4 || hitgroup == 5 && irons == true then
		hit = "body";
		x = GetClothesNumber(player, hit);
		hittext = "в руки";
		hardance = 2;
	end;
	if hitgroup == 6 || hitgroup == 7 && irons == true then
		hit = "legs";
		x = GetClothesNumber(player, hit);
		hittext = "в ноги";
		hardance = 3;
	end;
	if isnumber(hitgroup) && irons == false then
		if random == 1 then
			if data["head"] == true || data["gasmask"] == true then
				hit = "head";
				x = GetClothesNumber(player, hit);
				hittext = "в голову(или противогаз)";
				hardance = 6;
			else
				hit = "head";
				x = GetClothesNumber(player, hit);
				hittext = "в голову(без защиты)";
				hardance = 5;
			end;
		elseif random == 2 || random == 3 || random == 10 then
			hit = "body";
			x = GetClothesNumber(player, hit);
			hittext = "на подавление, но в тело.";
			hardance = 4;
		elseif random == 4 || random == 5 then
			hit = "legs";
			x = GetClothesNumber(player, hit);
			hittext = "на подавление, но в руки.";
			hardance = 4;
		elseif random == 6 || random == 7 then
			hit = "legs";
			x = GetClothesNumber(player, hit);
			hittext = "на подавление, но в ноги.";
			hardance = 4;
		end;
	end;

	algebra = (x / 10) + hardance;

	return hittext, math.Round(algebra);

end;

function GetClothesNumber(player, slot)
	local items = Clockwork.inventory:GetAsItemsList(player:GetInventory());
	local num = 0;

	for k, v in ipairs(items) do
		if v("clothesslot") == slot && v:GetData("Used") == true && v:GetData("Armor") then
		  num = tonumber(v:GetData("Armor")/10);
		end;
	end;
	return num;

end;

local function GetWeaponHandledInfo(player)
	local weapon = player:GetActiveWeapon();
	local weapon2 = player:GetActiveWeapon():GetClass();
	local wep = Clockwork.item:GetByWeapon(weapon);
	local skill = 0;
	local textskill = "";
	local damage = wep:GetData("RollDamage");
	local quality = wep:GetData("Quality");
	local shit = 0;
	
	if player:HoldingTFAweapon() == true then
		if IsWeaponAssault(weapon2) then
			skill = GetSkillValue(player, ATB_ASSAULT);
			textskill = "винтовки";
		end;
		if IsWeaponShotgun(weapon2) then
			skill = GetSkillValue(player, ATB_SHOTGUNS)
			textskill = "дробовика"
		end;
		if IsWeaponPistol(weapon2) then
			skill = GetSkillValue(player, ATB_PISTOLS)
			textskill = "пистолета"
		end;
	end;

	shit = math.floor((skill) + (quality + damage * 0.5));

	return shit, textskill;

end;

local function Result(player)
	local trace = player:GetEyeTrace();
	local target = trace.Entity;
	local text, armor = TargetArmor(trace.Entity, player);

	local weaponinfo, text2 = GetWeaponHandledInfo(player);

	return math.Clamp((weaponinfo - CountDistance(player) - armor), 0, 20);
end;

function COMMAND:OnRun(player, arguments)
	local trace = player:GetEyeTrace();
	local target = trace.Entity;
	local RollI = player:GetCharacterData("RollInfo")

	if !player:HoldingTFAweapon() then
		return;
	end;
	if !target:IsPlayer() then
		Clockwork.chatBox:SendColored(player, Color(255, 120, 120), "Вы не смотрите на игрока!");
		return;
	end;
	local hit = "";
	local result = Result(player);

	if result == 0 then
		hit = "промахнулся."
	elseif result <= 10 then
		hit = "попал и нанес легкий урон."
	elseif result <= 15 then
		hit = "попал и нанес средний урон."
	elseif result <= 20 then
		hit = "попал в то место, куда целится."
	end;	

	local weaponinfo, text2 = GetWeaponHandledInfo(player);
	local text, armor = TargetArmor(trace.Entity, player);

	if !player.cooldowned || player.cooldowned == false then

		if player:HoldingTFAweapon() then
			Clockwork.chatBox:AddInRadius(player, "roll", "атакует: "..text.." Из "..text2..". Итог: "..result.." / 20", player:GetPos(), Clockwork.config:Get("talk_radius"):Get());
			Clockwork.chatBox:AddInRadius(player, "roll", hit, player:GetPos(), Clockwork.config:Get("talk_radius"):Get());
		else
			Clockwork.chatBox:SendColored(player, Color(255, 120, 120), "Вы не держите оружие!");
		end;
		Clockwork.chatBox:SendColored(target, Color(200, 100, 100), "Вас атаковали из "..text2.." "..text.." с результатом"..result.." / 20. В итоге атакующий "..hit..".");
		
		player:PlayerSetRollData(hit, text)

		player.cooldowned = true;
	else
		Clockwork.chatBox:SendColored(player, Color(120, 120, 255), "Вам нужно подождать...");
	end;
end;

--[[ 
	Если игрок целится и находится на расстоянии более 250 метров, то автоматически берется подавление. [Додумать снайперские винтовки];
	Отрицательное расстояние прибавляет ролл.
	Удар в спину.
	
	Продумать снайперские винтовки.
	Если игрок держит дробовик, то чем ближе расстояние, тем больше прибавка. Чем дальше, тем меньше.
	Продумать холодное оружие.
]]
COMMAND:Register();