
Schema.CombineObjectives = Schema.CombineObjectives or {}

function Schema:AddCombineDisplayMessage(text, color, exclude, ...)
	color = color or color_white

	local arguments = {...}
	local receivers = {}

	-- we assume that exclude will be part of the argument list if we're using
	-- a phrase and exclude is a non-player argument
	if (type(exclude) != "Player") then
		table.insert(arguments, 1, exclude)
	end

	for _, v in ipairs(player.GetAll()) do
		if (v:IsCombine() and v != exclude) then
			receivers[#receivers + 1] = v
		end
	end

	netstream.Start(receivers, "CombineDisplayMessage", text, color, arguments)
end

-- data saving
function Schema:SaveRationDispensers()
	local data = {}

	for _, v in ipairs(ents.FindByClass("ix_rationdispenser")) do
		data[#data + 1] = {v:GetPos(), v:GetAngles(), v:GetEnabled()}
	end

	ix.data.Set("rationDispensers", data)
end

function Schema:SaveVendingMachines()
	local data = {}

	for _, v in ipairs(ents.FindByClass("ix_vendingmachine")) do
		data[#data + 1] = {v:GetPos(), v:GetAngles(), v:GetAllStock()}
	end

	ix.data.Set("vendingMachines", data)
end

function Schema:SaveCombineLocks()
	local data = {}
	local newData = {};

	for _, v in ipairs(ents.FindByClass("ix_combinelock")) do
		if (IsValid(v.door)) then
			data[#data + 1] = {
				v.door:MapCreationID(),
				v.door:WorldToLocal(v:GetPos()),
				v.door:WorldToLocalAngles(v:GetAngles()),
				v:GetLocked()
			}
		end
	end

	for _, v in ipairs(ents.FindByClass("ix_combinelock_union")) do
		if (IsValid(v.door)) then
			newData[#newData + 1] = {
				v.door:MapCreationID(),
				v.door:WorldToLocal(v:GetPos()),
				v.door:WorldToLocalAngles(v:GetAngles()),
				v:GetLocked()
			}
		end
	end

	ix.data.Set("combineUnionLocks", newData)
	ix.data.Set("combineLocks", data)
end

function Schema:SaveForceFields()
	local data = {}

	for _, v in ipairs(ents.FindByClass("ix_forcefield")) do
		data[#data + 1] = {v:GetPos(), v:GetAngles(), v:GetMode()}
	end

	ix.data.Set("forceFields", data)
end

-- data loading
function Schema:LoadRationDispensers()
	for _, v in ipairs(ix.data.Get("rationDispensers") or {}) do
		local dispenser = ents.Create("ix_rationdispenser")

		dispenser:SetPos(v[1])
		dispenser:SetAngles(v[2])
		dispenser:Spawn()
		dispenser:SetEnabled(v[3])
	end
end

function Schema:LoadVendingMachines()
	for _, v in ipairs(ix.data.Get("vendingMachines") or {}) do
		local vendor = ents.Create("ix_vendingmachine")

		vendor:SetPos(v[1])
		vendor:SetAngles(v[2])
		vendor:Spawn()
		vendor:SetStock(v[3])
	end
end

function Schema:LoadCombineLocks()
	for _, v in ipairs(ix.data.Get("combineLocks") or {}) do
		local door = ents.GetMapCreatedEntity(v[1])

		if (IsValid(door) and door:IsDoor()) then
			local lock = ents.Create("ix_combinelock")

			lock:SetPos(door:GetPos())
			lock:Spawn()
			lock:SetDoor(door, door:LocalToWorld(v[2]), door:LocalToWorldAngles(v[3]))
			lock:SetLocked(v[4])
		end
	end

	for _, v in ipairs(ix.data.Get("combineUnionLocks") or {}) do
		local door = ents.GetMapCreatedEntity(v[1])

		if (IsValid(door) and door:IsDoor()) then
			local lock = ents.Create("ix_combinelock_union")

			lock:SetPos(door:GetPos())
			lock:Spawn()
			lock:SetDoor(door, door:LocalToWorld(v[2]), door:LocalToWorldAngles(v[3]))
			lock:SetLocked(v[4])
		end
	end
end

function Schema:LoadForceFields()
	for _, v in ipairs(ix.data.Get("forceFields") or {}) do
		local field = ents.Create("ix_forcefield")

		field:SetPos(v[1])
		field:SetAngles(v[2])
		field:Spawn()
		field:SetMode(v[3])
	end
end

function Schema:CreateScanner(client, class)
	class = class or "npc_cscanner"

	local entity = ents.Create(class)

	if (!IsValid(entity)) then
		return
	end

	entity:SetPos(client:GetPos())
	entity:SetAngles(client:GetAngles())
	entity:SetColor(client:GetColor())
	entity:Spawn()
	entity:Activate()
	entity.ixPlayer = client
	entity:SetNetVar("player", client) -- Draw the player info when looking at the scanner.
	entity:CallOnRemove("ScannerRemove", function()
		if (IsValid(client)) then
			local position = entity.position or client:GetPos()

			client:UnSpectate()
			client:SetViewEntity(NULL)

			if (entity:Health() > 0) then
				client:Spawn()
			else
				client:KillSilent()
			end

			timer.Simple(0, function()
				client:SetPos(position)
			end)
		end
	end)

	local uniqueID = "ix_Scanner" .. client:UniqueID()
	entity.name = uniqueID
	entity.ixCharacterID = client:GetCharacter():GetID()

	local target = ents.Create("path_track")
	target:SetPos(entity:GetPos())
	target:Spawn()
	target:SetName(uniqueID)
	entity:CallOnRemove("RemoveTarget", function()
		if (IsValid(target)) then
			target:Remove()
		end
	end)

	entity:SetHealth(client:Health())
	entity:SetMaxHealth(client:GetMaxHealth())
	entity:Fire("setfollowtarget", uniqueID)
	entity:Fire("inputshouldinspect", false)
	entity:Fire("setdistanceoverride", "48")
	entity:SetKeyValue("spawnflags", 8208)

	client.ixScanner = entity
	client:Spectate(OBS_MODE_CHASE)
	client:SpectateEntity(entity)
	entity:CallOnRemove("RemoveThink", function()
		timer.Remove(uniqueID)
	end)

	timer.Create(uniqueID, 0.33, 0, function()
		if (!IsValid(client) or !IsValid(entity) or client:GetCharacter():GetID() != entity.ixCharacterID) then
			if (IsValid(entity)) then
				entity:Remove()
			end

			timer.Remove(uniqueID)
			return
		end

		local factor = 128

		if (client:KeyDown(IN_SPEED)) then
			factor = 64
		end

		if (client:KeyDown(IN_FORWARD)) then
			target:SetPos((entity:GetPos() + client:GetAimVector() * factor) - Vector(0, 0, 64))
			entity:Fire("setfollowtarget", uniqueID)
		elseif (client:KeyDown(IN_BACK)) then
			target:SetPos((entity:GetPos() + client:GetAimVector() * -factor) - Vector(0, 0, 64))
			entity:Fire("setfollowtarget", uniqueID)
		elseif (client:KeyDown(IN_JUMP)) then
			target:SetPos(entity:GetPos() + Vector(0, 0, factor))
			entity:Fire("setfollowtarget", uniqueID)
		elseif (client:KeyDown(IN_DUCK)) then
			target:SetPos(entity:GetPos() - Vector(0, 0, factor))
			entity:Fire("setfollowtarget", uniqueID)
		end

		client:SetPos(entity:GetPos())
	end)

	return entity
end

function Schema:SearchPlayer(client, target)
	if (!target:GetCharacter() or !target:GetCharacter():GetInventory()) then
		return false
	end

	local name = hook.Run("GetDisplayedName", target) or target:Name()
	local inventory = target:GetCharacter():GetInventory()

	ix.storage.Open(client, inventory, {
		entity = target,
		name = name
	})

	return true
end

Schema.white = {
	'STEAM_0:0:81566201', -- Ross
	'STEAM_0:1:186179639', -- SINDIKAT
	'STEAM_0:1:67452855', -- HOLY SANYA
	'STEAM_0:0:124212244', -- Куки
	'STEAM_0:0:53885742', -- Гендальф
	'STEAM_0:1:82036164', -- Оверлорд
	'STEAM_0:1:127415963', -- Михан
	'STEAM_0:1:63680115', -- Марки
	'STEAM_0:0:167308556', -- Голден 
	'STEAM_0:0:155388946', -- Генокрад
	'STEAM_0:0:191413333', -- Криег
	"STEAM_0:1:85812312", -- Ларнс
	'STEAM_0:1:71286927', -- Soil
	'STEAM_0:1:82306348', -- Колесо
	"STEAM_0:0:58180373", -- Вирус
	"STEAM_0:0:35425217", -- Frank Wilson
	"STEAM_0:0:66977479", -- Lost Weapon Master
	"STEAM_0:0:85893479", -- Авик
	"STEAM_0:0:51161687", -- Доки-доки
	"STEAM_0:1:73443421", -- Лекарь
	"STEAM_0:1:68252275", -- Оверлорд
	"STEAM_0:1:173269683", -- Воин спарты
	"STEAM_0:1:61017633", -- Террорист, глава офисного отдела
	"STEAM_0:1:85047323", -- Укр
	"STEAM_0:1:72475913", -- Вуки
	"STEAM_0:0:192587428", -- Харви
	"STEAM_0:1:174008244", -- Коля яблоко
	"STEAM_0:0:173897892", -- Свит чери
	"STEAM_0:0:172922889", -- Анархангел
	'STEAM_0:1:90693077', -- Ориклоун
	'STEAM_0:0:34010254', -- _quber
	'STEAM_0:0:122774378',
	'STEAM_0:0:176953057',
	'STEAM_0:0:146567781',
	"STEAM_0:1:19277003", -- Maloy
	"STEAM_0:1:210307927", -- Ubn
	"STEAM_0:1:30864007", -- Combiner
	"STEAM_0:1:108976924",
	'STEAM_0:1:101371823',
        "STEAM_0:0:182662404", -- ????
		"STEAM_0:1:121959743",  -- Zandronum
		"STEAM_0:0:171889129",
		"STEAM_0:0:68295467",
		'STEAM_0:0:85311313', -- analgen
		'STEAM_0:1:120921609', -- devils
		'STEAM_0:1:80579394', -- aloe
		'STEAM_0:1:59986909', -- icelysirus
		'STEAM_0:1:19566934', -- Аксиомка
		'STEAM_0:1:159159670', --  aksi
		'STEAM_0:0:74893846', -- Earl
		'STEAM_0:1:26573472', -- Baranka
		'STEAM_0:1:159970193',
		'STEAM_0:1:103505546',
		'STEAM_0:1:86388722',
		'STEAM_0:0:34008601'
}
function Schema:CheckPassword(steamID, ipAddress, svPassword, clPassword, name)
	steamID = util.SteamIDFrom64(steamID);
	local isfalse = table.HasValue(self.white, steamID)
	
	return isfalse, "Вы не в вайтлисте. Подтвердите свой статус: https://discord.gg/W9CR9y"
end;