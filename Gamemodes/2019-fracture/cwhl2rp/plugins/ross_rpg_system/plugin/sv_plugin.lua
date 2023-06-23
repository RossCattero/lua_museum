
local PLUGIN = PLUGIN;

local p = FindMetaTable( "Player" )
local math = math;
local mc = math.Clamp;


function p:Not(text)
	return Clockwork.chatBox:SendColored(self, Color(120, 255, 120), text)
end;

function PLUGIN:PlayerSaveCharacterData(player, data)
	if (data["SkillsOfPlayer"]) then
		data["SkillsOfPlayer"] = data["SkillsOfPlayer"];
	else
		data["SkillsOfPlayer"] = {
			skills = {},
			CanOpen = {}
		};
	end;

end;

function PLUGIN:PlayerRestoreCharacterData(player, data)
	if ( !data["SkillsOfPlayer"] ) then
		data["SkillsOfPlayer"] = {
			skills = {},
			CanOpen = {}
		};
	end;
	if (!data["UpdateTierPoints"]) then
		data["UpdateTierPoints"] = 0;
	end;
end;

function PLUGIN:EntityFireBullets(entity, bulletInfo) 
	local random = math.random(0, 101)

	/* Номера */
	local melee = 1;
	local assaulty = 1;
	local pistols = 1;
	local shotgun = 1;
	/* Номера */

	if random > 99 then
		if (entity:IsPlayer() && entity:IsValid() ) then
			local wep = entity:GetActiveWeapon():GetClass();

			if IsWeaponAssault( wep ) == true then
				Clockwork.attributes:Update(entity, ATB_ASSAULT, 0.01)
				if GetSkillValue(player, ATB_MELEE) > assaulty then
					Clockwork.attributes:Update(entity, ATB_MELEE, -0.01)
				end;
				if GetSkillValue(player, ATB_PISTOLS) > assaulty then
					Clockwork.attributes:Update(entity, ATB_PISTOLS, -0.01)
				end;
				if GetSkillValue(player, ATB_SHOTGUNS) > assaulty then
					Clockwork.attributes:Update(entity, ATB_SHOTGUNS, -0.01)
				end;
			elseif IsWeaponShotgun( wep ) == true then
				Clockwork.attributes:Update(entity, ATB_SHOTGUNS, 0.01)
				if GetSkillValue(player, ATB_MELEE) > shotgun then
					Clockwork.attributes:Update(entity, ATB_MELEE, -0.01)
				end;
				if GetSkillValue(player, ATB_PISTOLS) > shotgun then
					Clockwork.attributes:Update(entity, ATB_PISTOLS, -0.01)
				end;
				if GetSkillValue(player, ATB_ASSAULT) > shotgun then
					Clockwork.attributes:Update(entity, ATB_ASSAULT, -0.01)
				end;
			elseif IsWeaponPistol( wep ) == true then
				Clockwork.attributes:Update(entity, ATB_PISTOLS, 0.01)
				if GetSkillValue(player, ATB_MELEE) > pistols then
					Clockwork.attributes:Update(entity, ATB_MELEE, -0.01)
				end;
				if GetSkillValue(player, ATB_SHOTGUNS) > pistols then
					Clockwork.attributes:Update(entity, ATB_SHOTGUNS, -0.01)
				end;
				if GetSkillValue(player, ATB_ASSAULT) > pistols then
					Clockwork.attributes:Update(entity, ATB_ASSAULT, -0.01)
				end;
			elseif IsWeaponMelee( wep ) == true then
				Clockwork.attributes:Update(entity, ATB_MELEE, 0.01)
				if GetSkillValue(player, ATB_PISTOLS) > melee then
					Clockwork.attributes:Update(entity, ATB_PISTOLS, -0.01)
				end;
				if GetSkillValue(player, ATB_SHOTGUNS) > melee then
					Clockwork.attributes:Update(entity, ATB_SHOTGUNS, -0.01)
				end;
				if GetSkillValue(player, ATB_ASSAULT) > melee then
					Clockwork.attributes:Update(entity, ATB_ASSAULT, -0.01)
				end;				
			end;

		end;
	end;

end;

function PLUGIN:EntityTakeDamage(entity, damageInfo)
	local inflictor = damageInfo:GetInflictor(); -- Оружие.
	local player = damageInfo:GetAttacker(); -- Игрок.
	local npc = entity:IsNPC();
	local att_ply = entity:IsPlayer();
	local randomAssault = math.random(1, 100);
	local nolik = 0;

	/* Номера */
	local melee = 1;
	local assaulty = 1;
	local pistols = 1;
	local shotgun = 1;
	/* Номера */

	if player:IsPlayer() then
		local target = player:GetEyeTrace().Entity;
		local a = math.Round(player:GetPos():Distance(target:GetPos()));
		if a >= 250 && target == npc || target == att_ply then
			nolik = 5;
		else
			nolik = 0;
		end;
-- Холодное оружие.

	if npc && IsWeaponMelee(player:GetActiveWeapon():GetClass()) == true then
		Clockwork.attributes:Update(player, ATB_MELEE, 0.01)
		if GetSkillValue(player, ATB_ASSAULT) > melee then
			Clockwork.attributes:Update(player, ATB_ASSAULT, -0.01)
		end;
		if GetSkillValue(player, ATB_PISTOLS) > melee then
			Clockwork.attributes:Update(player, ATB_PISTOLS, -0.01)
		end;
		if GetSkillValue(player, ATB_SHOTGUNS) > melee then
			Clockwork.attributes:Update(player, ATB_SHOTGUNS, -0.01)
		end;
	elseif att_ply && IsWeaponMelee(player:GetActiveWeapon():GetClass()) == true then
		Clockwork.attributes:Update(player, ATB_MELEE, 0.04)
		if GetSkillValue(player, ATB_ASSAULT) > melee then
			Clockwork.attributes:Update(player, ATB_ASSAULT, -0.01)
		end;
		if GetSkillValue(player, ATB_PISTOLS) > melee then
			Clockwork.attributes:Update(player, ATB_PISTOLS, -0.01)
		end;
		if GetSkillValue(player, ATB_SHOTGUNS) > melee then
			Clockwork.attributes:Update(player, ATB_SHOTGUNS, -0.01)
		end;	
	end;

-- Штурмовое оружие.
	if npc && IsWeaponAssault(player:GetActiveWeapon():GetClass()) == true && randomAssault >= 90 then
		Clockwork.attributes:Update(player, ATB_ASSAULT, 0.1)
		if GetSkillValue(player, ATB_MELEE) > assaulty then
			Clockwork.attributes:Update(player, ATB_MELEE, -0.01)
		end;
		if GetSkillValue(player, ATB_PISTOLS) > assaulty then
			Clockwork.attributes:Update(player, ATB_PISTOLS, -0.01)
		end;
		if GetSkillValue(player, ATB_SHOTGUNS) > assaulty then
			Clockwork.attributes:Update(player, ATB_SHOTGUNS, -0.01)
		end;
	elseif att_ply && IsWeaponAssault(player:GetActiveWeapon():GetClass()) == true && randomAssault >= 95 then
		Clockwork.attributes:Update(player, ATB_ASSAULT, 0.2)
		if GetSkillValue(player, ATB_MELEE) > assaulty then
			Clockwork.attributes:Update(player, ATB_MELEE, -0.01)
		end;
		if GetSkillValue(player, ATB_PISTOLS) > assaulty then
			Clockwork.attributes:Update(player, ATB_PISTOLS, -0.01)
		end;
		if GetSkillValue(player, ATB_SHOTGUNS) > assaulty then
			Clockwork.attributes:Update(player, ATB_SHOTGUNS, -0.01)
		end;		
	end;

-- Пистолеты.
	if npc && IsWeaponPistol(player:GetActiveWeapon():GetClass()) == true && randomAssault >= 87 then
		Clockwork.attributes:Update(player, ATB_PISTOLS, 0.4)
		if GetSkillValue(player, ATB_MELEE) > pistols then
			Clockwork.attributes:Update(player, ATB_MELEE, -0.01)
		end;
		if GetSkillValue(player, ATB_ASSAULT) > pistols then
			Clockwork.attributes:Update(player, ATB_ASSAULT, -0.01)
		end;
		if GetSkillValue(player, ATB_SHOTGUNS) > pistols then
			Clockwork.attributes:Update(player, ATB_SHOTGUNS, -0.01)
		end;
	elseif att_ply && IsWeaponPistol(player:GetActiveWeapon():GetClass()) == true && randomAssault >= 92 then
		Clockwork.attributes:Update(player, ATB_PISTOLS, 0.2)
		if GetSkillValue(player, ATB_MELEE) > pistols then
			Clockwork.attributes:Update(player, ATB_MELEE, -0.01)
		end;
		if GetSkillValue(player, ATB_ASSAULT) > pistols then
			Clockwork.attributes:Update(player, ATB_ASSAULT, -0.01)
		end;
		if GetSkillValue(player, ATB_SHOTGUNS) > pistols then
			Clockwork.attributes:Update(player, ATB_SHOTGUNS, -0.01)
		end;		
	end;

-- Дробовики.
	if npc && IsWeaponShotgun(player:GetActiveWeapon():GetClass()) == true && randomAssault >= 87 + nolik then
		Clockwork.attributes:Update(player, ATB_SHOTGUNS, 0.4)
		if GetSkillValue(player, ATB_MELEE) > shotgun then
			Clockwork.attributes:Update(player, ATB_MELEE, -0.01)
		end;
		if GetSkillValue(player, ATB_ASSAULT) > shotgun then
			Clockwork.attributes:Update(player, ATB_ASSAULT, -0.01)
		end;
		if GetSkillValue(player, ATB_PISTOLS) > shotgun then
			Clockwork.attributes:Update(player, ATB_PISTOLS, -0.01)
		end;
	elseif att_ply && IsWeaponShotgun(player:GetActiveWeapon():GetClass()) == true && randomAssault >= 92 + nolik then
		Clockwork.attributes:Update(player, ATB_SHOTGUNS, 0.2)
		if GetSkillValue(player, ATB_MELEE) > shotgun then
			Clockwork.attributes:Update(player, ATB_MELEE, -0.01)
		end;
		if GetSkillValue(player, ATB_ASSAULT) > shotgun then
			Clockwork.attributes:Update(player, ATB_ASSAULT, -0.01)
		end;
		if GetSkillValue(player, ATB_PISTOLS) > shotgun then
			Clockwork.attributes:Update(player, ATB_PISTOLS, -0.01)
		end;	
	end;	
end;

end;

function PLUGIN:PlayerTakeDamage(player, inflictor, attacker, hitGroup, damageInfo)
	if player:Alive() then
		if GetSkillValue(player, ATB_ENDURANCE2) || GetSkillValue(player, ATB_SUSPECTING) then
			Clockwork.attributes:Update(player, ATB_ENDURANCE2, damageInfo:GetDamage()/100)
			Clockwork.attributes:Update(player, ATB_SUSPECTING, damageInfo:GetDamage()/100)
		end;
	end;
end;

function p:GetSkillTable()
	return self:GetCharacterData("SkillsOfPlayer");
end;

function p:HasSkill(id)
	local skills = self:GetSkillTable();

	if !skills["skills"][id] then
		return false;
	end;

	return true;
end;

function p:AddSkill(id, editTable)
	local skills = self:GetSkillTable();

	skills["skills"][id] = {};
	skills["skills"][id]["infliction"] = editTable.infliction;

	if editTable.tier + editTable.tiermax != 0 then
		skills["skills"][id]["tier"] = editTable.tier;
		skills["skills"][id]["tiermax"] = editTable.tiermax;
	end;

	if skills["skills"][id]["tier"] == skills["skills"][id]["tiermax"] then
		for k, v in pairs(editTable.opens) do
			table.insert(skills["CanOpen"], v)
		end;
	end;

	return;
end;

function p:GetInflictionSkill(id)
	local skills = self:GetSkillTable();

	if self:HasSkill(id) then
		return skills["skills"][id]["infliction"]
	end;

	return 1;
end;

cable.receive('SendToServerSKILLS', function(player)
	
	cable.send(player, 'CreateSkillPanel', player:GetSkillTable(), player:GetCharacterData("UpdateTierPoints"))

end)

cable.receive('EditQuestOfPlayer', function(player, nameKey, valueTable)
	
	local skills = player:GetSkillTable();

	if !player:HasSkill(nameKey) then
		player:AddSkill(nameKey, valueTable)

		print("Персонаж "..player:Name().." добавил себе навык "..nameKey..".")
	end;
end);

cable.receive('EditQuestTier', function(player, tp, name, valueTable, tierUpdated)
	
	local skills = player:GetSkillTable();
	local tierPoints = player:GetCharacterData("UpdateTierPoints");

	if !player:HasSkill(name) then
		skills["skills"][name] = {};
		skills["skills"][name]["infliction"] = valueTable.infliction;
		skills["skills"][name]["tier"] = tierUpdated;
		skills["skills"][name]["tiermax"] = valueTable.tiermax;

		print("Персонаж "..player:Name().." добавил себе навык "..name..".")
	end;
	player:SetCharacterData("UpdateTierPoints", tp)
	skills["skills"][name].tier = math.Clamp(tierUpdated, 0, skills["skills"][name].tiermax);

	print("Персонаж "..player:Name().." улучшил свой навык "..name.." до уровня "..skills["skills"][name].tier..".")
	for k, v in pairs(valueTable.infliction) do
		if isnumber(v) && skills["skills"][name].tier != 0 then
			skills["skills"][name].infliction[k] = v * skills["skills"][name].tier;
		end;
	end;

end)

function PLUGIN:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)

	player:SetCharacterData("UpdateTierPoints", 10)
	player:SetCharacterData("SkillsOfPlayer", {
		skills = {},
		CanOpen = {}
	})
end;