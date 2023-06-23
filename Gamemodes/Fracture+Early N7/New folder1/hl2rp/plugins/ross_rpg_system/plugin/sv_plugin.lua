
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


function PLUGIN:PlayerTakeDamage(player, inflictor, attacker, hitGroup, damageInfo)
	if player:Alive() then
		if (GetSkillValue(player, ATB_ENDURANCE2) || GetSkillValue(player, ATB_SUSPECTING) && !damageInfo:IsFallDamage()) then
			Clockwork.attributes:Update(player, ATB_ENDURANCE2, damageInfo:GetDamage()/100)
			Clockwork.attributes:Update(player, ATB_SUSPECTING, damageInfo:GetDamage()/100)
		end;
	end;
end;

function PLUGIN:PlayerPunchThrown(player)
	local random = math.random(100);
	if random < 50 then
		Clockwork.attributes:Update(player, ATB_ENDURANCE2, math.random(0.01, 0.02))
	end;
end;

-- Called when a player punches an entity.
function PLUGIN:PlayerPunchEntity(player, entity)
	local random = math.random(100);
	if random < 50 then
		Clockwork.attributes:Update(player, ATB_ENDURANCE2, math.random(0.01, 0.03))
	end;
end;

function p:GetSkillTable()
	return self:GetCharacterData("SkillsOfPlayer");
end;

function PLUGIN:EntityFireBullets(entity, bulletInfo) 
	local player = (entity:IsPlayer() && entity:IsValid());
	local random = math.random(100);
	local addition = 0
	
	local attributes = {
		assault = 1, shotgun = 1, pistol = 1, melee = 1
	}

	if player && random > 66 then
		local weapon = entity:GetActiveWeapon():GetClass();
		local wepType = GetWeaponTFAtype(weapon);
		if wepType == 'melee' then
			addition = addition + math.random(0.01, 0.1);
		end;

		Clockwork.attributes:Update(entity, wepType, 0.01 + addition);

		attributes[wepType] = nil;

		for k, v in pairs(attributes) do
			Clockwork.attributes:Update(entity, k, -0.02);
		end;

	end;
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