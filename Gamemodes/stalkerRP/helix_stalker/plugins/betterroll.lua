PLUGIN.name = "New Roll"
PLUGIN.author = "Ross"
PLUGIN.description = ""

ix.chat.Register("modroll", {
	color = Color(255, 255, 255),
	format = "",
	GetColor = function(self, speaker, text)
		return self.color
	end,
	CanHear = function(self, speaker, listener)
		local chatRange = ix.config.Get("chatRange", 280)
		return (speaker:GetPos() - listener:GetPos()):LengthSqr() <= (chatRange * chatRange)
	end,
	OnChatAdd = function(self, speaker, text)
		chat.AddText(self.color, text)
	end
})

ix.chat.Register("modroll_eavsDrop", {
	color = Color(255, 255, 175),
	format = "",
	GetColor = function(self, speaker, text)
		return self.color
	end,
	CanHear = function(self, speaker, listener)
		local chatRange = ix.config.Get("chatRange", 280)
		return (speaker:GetPos() - listener:GetPos()):LengthSqr() <= (chatRange * chatRange) && speaker != listener
	end,
	OnChatAdd = function(self, speaker, text)
		chat.AddText(self.color, text)
	end
})

local function Roll_GetDistance(player)
	-- Высчитывается расстояние до цели и выдается число от 1(близко) до 10(очень далеко) в зависимости от расстояния.
	-- Добавляется несколько очков расстояния, если в руках у человека дробовик.
	local active = player:GetActiveWeapon():GetClass()
	local trace = player:GetEyeTraceNoCursor()
	local type = GetWeaponTFAtype(active)
	local shotPos = player:GetShootPos()
	local d0 = shotPos:Distance(trace.HitPos);
	local d1 = math.Round(math.Clamp(d0/100, 1, 1000));

	if type == "shotgun" then
		d1 = d1 + 3
	elseif type == 'bolt_sniper' then
		d1 = d1 - 5
	end;

	return d1
end;

local function Roll_GetAttackerWeaponInfo(player)
	-- Высчитывается качество оружия.
	local weapon = player:GetActiveWeapon();
	local weaponItem = player:GetCharacter():GetInventory():HasItem( weapon:GetClass() )

	if IsWeaponTFA(weapon) && weapon && weaponItem then
		local countUp = math.Round(weaponItem:GetData("WeaponQuality"));
		if IsWeaponTFA(weapon) && weapon:GetIronSights() then countUp = countUp + 2 end;
		return countUp;
	end;

	return 0;
end;

local function Roll_GetAttackerAttributes(player)
	-- Вычисляется число атрибута в зависимости от оружия в руках у человека.
	local weapon = player:GetActiveWeapon()

	if IsWeaponTFA(weapon) && weapon then
		local weptype = GetWeaponTFAtype(weapon:GetClass());
		return player:GetCharacter():GetAttribute( weptype );
	end;

	return 0;
end;

local function Roll_GetAttackerNeeds(player)
	-- Вычисляются потребности атакующего, чтобы сделать его атаку более зависящей от потебностей.

	return math.Round((player:GetLocalVar("hunger") + player:GetLocalVar("thirst") + player:GetLocalVar("sleep"))/100)
end;

local function Roll_GetAttackerTraceInfo(player)
	-- Вычисялется место, куда атакует человек и в зависимости от сложности выдается число
	local trace = player:GetEyeTraceNoCursor()
	local bone = GetHitGroupBone(trace)
	local distance = Roll_GetDistance(player);
	local HitNumber, ResultHit = 0, "в пустоту"

	local hitBone = {
		"в голову", "в тело", "в руки", "в ноги"
	}
	if distance < 10 then
		if bone == 1 then HitNumber = 4 ResultHit = hitBone[1]
		elseif bone == 2 || bone == 3 then HitNumber = 2 ResultHit = hitBone[2]
		elseif bone == 4 || bone == 5 then HitNumber = 2 ResultHit = hitBone[3]
		elseif bone == 6 || bone == 7 then HitNumber = 2 ResultHit = hitBone[4]
		end;
	elseif distance >= 10 then
		HitNumber = 4
		ResultHit = hitBone[math.random(1, 4)]
	end;

	return HitNumber, ResultHit
end;

local function Roll_GetVictimAttributes(player)
	-- Вычисляется, может ли увернуться жертва.
	local trace = player:GetEyeTraceNoCursor()
	local Entity = trace.Entity;

	if Entity && Entity:IsPlayer() then
		local countDex = Entity:GetCharacter():GetAttribute("dexterity");
		if Roll_GetAttackerAttributes(player) > countDex then countDex = countDex - 2 end;
		local needs = math.Round((Entity:GetLocalVar("hunger") + Entity:GetLocalVar("thirst") + Entity:GetLocalVar("sleep"))/100);

		return countDex + math.random(1, 3) + needs
	end;

	return 0;
end;

local function Roll_GetVictimArmorInfo(player)
	-- Вычисляются показатели брони.
	local trace = player:GetEyeTraceNoCursor()
	local Entity = trace.Entity;

	if Entity && Entity:IsPlayer() then
		return player:GetLocalVar('ProtectionTable')["Гашение урона"]
	end;
	return 0;
end;

local function Roll_GetVictimTrace(player)
	-- Вычисляется дебаф или баф в зависимости от направления взгляда человека.
	local trace = player:GetEyeTraceNoCursor()
	local Entity = trace.Entity;

	if Entity && Entity:IsPlayer() then
		if Entity:GetAimVector():DotProduct(player:GetAimVector()) > 0 then
			return 4
		end;
	end;

	return 0;
end;

local function Roll_CountReult(player, result)
	local resultHit = "не попал"
	if result == 20 then
		resultHit = "нанес точное попадание"
	elseif result >= 15 then
		resultHit = "нанес тяжелое ранение"
	elseif result >= 10 then
		resultHit = "нанес среднее ранение"
	elseif result >= 5 then
		resultHit = "нанес ранение"
	elseif result >= 1 then
		resultHit = "слегка задел"
	elseif result == 0 then
		resultHit = resultHit;
	end;

	return resultHit
end;

ix.command.Add("ModRoll", {
	description = "",
	OnRun = function(self, client)
		local trace = client:GetEyeTraceNoCursor();
		local ent = trace.Entity
		local weapon = client:GetActiveWeapon();

		if !ent:IsPlayer() then
			client:Notify("Я не могу атаковать!")
			return;
		elseif (client.cooldowned && CurTime() < client.cooldowned) then
			local needToWait = client.cooldowned - CurTime();
			client:Notify("Я не могу атаковать еще "..math.Round(needToWait).." секунд!")
			return;
		end;

		local name, traceName = client:GetName(), ent:GetName()

		local distance = Roll_GetDistance(client);
		local weaponQuality = Roll_GetAttackerWeaponInfo(client)/10;
		local weaponAttribute = Roll_GetAttackerAttributes(client);
		local attackerNeeds = Roll_GetAttackerNeeds(client)
		local HitNumber, HitResult = Roll_GetAttackerTraceInfo(client)
		local VictimAttribute = Roll_GetVictimAttributes(client);
		local isTurnedAround = Roll_GetVictimTrace(client);

		local result = 0 - distance - HitNumber + weaponQuality + weaponAttribute + attackerNeeds
		local vresult = VictimAttribute - isTurnedAround

		local total = Roll_CountReult(client, 0);

		result = math.max( math.Round(result), 0 )
		
		vresult = math.max( math.Round(vresult), 0 )
		
		local anotherResult = result - vresult
		anotherResult = math.Round(anotherResult)

		if result > vresult then
			total = Roll_CountReult(client, math.max(anotherResult, 0))
		end;
		result = tostring(result);
		vresult = tostring(vresult)
		
		ix.chat.Send(client, "modroll", name.." атакует "..traceName.." "..HitResult.." с результатом "..result.." и возможностью жертвы увернуться: "..vresult.." в итоге: "..total.."["..tonumber(result) - tonumber(vresult).."]" )
		ix.chat.Send(ent, "modroll_eavsDrop", name.." атакует "..traceName.." "..HitResult.." с результатом "..result.." и возможностью жертвы увернуться: "..vresult.." в итоге: "..total.."["..tonumber(result) - tonumber(vresult).."]" )
		ent:Notify( name.." атакует вас "..HitResult.." с результатом "..result.." и вашей возможностью увернуться: "..vresult.." в итоге: "..total.."["..tonumber(result) - tonumber(vresult).."]" )
		local dmgInfo = {};
		
		if tonumber(result) > tonumber(vresult) then
			dmgInfo.nextDamage = weapon.Primary.Damage * anotherResult/10
			dmgInfo.nextVictim = ent;
			dmgInfo.nextHitPos = GetHitGroupBone(trace)

			client.cooldowned = CurTime() + 60;
			client:SetLocalVar("NextDamageInfo", dmgInfo);
				local bufferedShit = "ix_BetterRoll"..client:SteamID()
				timer.Create(bufferedShit, 60, 1, function()
					if client:Alive() && client:GetCharacter() then
						client:SetLocalVar("NextDamageInfo", {});
					else
						if (bufferedShit) then
							timer.Destroy(bufferedShit)
						end;
					end;
				end);

			return;
		end;


		client.cooldowned = CurTime() + 3
	end
})

if SERVER then

	function PLUGIN:OnCharacterCreated(client, character)
		character:SetData("NextDamageInfo", {})
	end
	
	function PLUGIN:PlayerLoadedCharacter(client, character)
		timer.Simple(0.25, function()
			client:SetLocalVar("NextDamageInfo", {})
			character:SetData("NextDamageInfo", {})
		end)
	end
	
	function PLUGIN:CharacterPreSave(character)
		local client = character:GetPlayer()
	
		if (IsValid(client)) then
			character:SetData("NextDamageInfo", client:GetLocalVar("NextDamageInfo", {}))
		end
	end

	function PLUGIN:PlayerShouldTakeDamage( victim, attacker )
		if attacker.startedDamage && CurTime() < attacker.startedDamage then
			return false;
		end;
	end;

	function PLUGIN:EntityTakeDamage(entity, damageInfo)
		local attacker = damageInfo:GetAttacker()
		if attacker:IsPlayer() && attacker:GetCharacter() && attacker:Alive() then
			local tbl = attacker:GetLocalVar('NextDamageInfo');
			if tbl.nextVictim == nil || tbl.nextHitPos == nil then return; end;

			if entity:GetName() == tbl.nextVictim:GetName() && GetHitGroupBone(attacker:GetEyeTraceNoCursor()) == tbl.nextHitPos then
				damageInfo:SetDamage( tonumber(tbl.nextDamage) )
				attacker:SetLocalVar('NextDamageInfo', {})
				timer.Create("ix_CoolDownExpire"..attacker:SteamID(), 3, 1, function()
					if attacker:Alive() && attacker:GetCharacter() then
						attacker.cooldowned = nil;
					else
						if ("ix_CoolDownExpire"..attacker:SteamID()) then
							timer.Destroy("ix_CoolDownExpire"..attacker:SteamID())
						end;
					end;
				end)
			else
				damageInfo:SetDamage( 0 )
			end;

			if attacker:GetEyeTraceNoCursor().HitWorld then
				attacker:SetLocalVar('NextDamageInfo', {})
			end;
		end;
	end;

else
	function PLUGIN:PreDrawHalos()
		local p = LocalPlayer()
		local exactPlayer = p:GetLocalVar("NextDamageInfo", {});
		if !p:Alive() or !p:GetCharacter() or !exactPlayer["nextVictim"] then
			return;
		end;
		local victim = {}
		for _, ply in ipairs( player.GetAll() ) do
			if ( ply == exactPlayer["nextVictim"] ) then
				victim[1] = ply
			end
		end
		if exactPlayer["nextVictim"] then
			halo.Add( victim, Color( 0, 255, 0 ), 0, 0, 2, true )		
		end;
	end;
end;