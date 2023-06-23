local PLUGIN = PLUGIN;

TAXI = TAXI or {}
TAXI.orders = TAXI.orders or {};

function PLUGIN:PlayerLoadedChar(client, character, lastChar)
		timer.Simple(0.25, function()
			if lastChar then lastChar:DisconnectHandle() end;

			if client:IsTaxi() then
					netstream.Start(client, 'taxi::syncTaxiData', TAXI.orders)
			end

			character:setData("TAXI", 
					character:getData("TAXI", {
						hash = MakeHashID(15),
						entity = NULL,
						orderTaken = NULL,
						id = NULL,
						hasCar = false,
					})
			)
			client:setLocalVar("TAXI", character:getData("TAXI"))
		end);
end;

function PLUGIN:PlayerDisconnected(user)
		local char = user:getChar();
		if user:IsValid() && char then
				char:DisconnectHandle()
		end
end;

function PLUGIN:CharacterPreSave(character)
		local client = character:getPlayer()
    if (IsValid(client)) then
				character:setData("TAXI", 
					character:getData("TAXI", {
						hash = MakeHashID(15),
						entity = NULL,
						id = NULL,
						orderTaken = NULL,
						hasCar = false,
					})
			)
			client:setLocalVar("TAXI", character:getData("TAXI"))
		end;
end;

netstream.Hook('taxi::ApplyToTaxi', function(client)
		local taxi = FACTION_TAXI_WORKER;
		local defFaction = FACTION_DEFAULT
		local chFac = client:getChar():getFaction();
		if !nut.faction.indices[taxi] then return end;
		local result = chFac != taxi && !client:IsTaxi() && taxi || defFaction;

		client:getChar():setFaction(result)
		client:notify("You were transfered to faction " .. nut.faction.indices[result].name)
end);

netstream.Hook('taxi::ParentTaxi', function(client)
		if !client:IsTaxi() then return end;

		if client.taxiSpawnCD && client.taxiSpawnCD >= CurTime() then return end;
		client.taxiSpawnCD = CurTime() + 1;

		local taxi = client:HasTaxi()

		if taxi then
				if client:GetTaxi() then client:GetTaxi():Remove(); end;

				client:SetTaxi("hasCar", false)
				client:SetTaxi("entity", NULL)
				client:notify("Vendor: Taxi successfully removed.")
		else
			if PLUGIN:CanSpawnTaxi() then
					local vehicle = simfphys.SpawnVehicleSimple( TAXI_DATA.carName, TAXI_DATA.taxiSpawnPos, Angle(0, 0, 0) )
					client:SetTaxi("entity", vehicle)
					client:SetTaxi("hasCar", true)
					client:notify("Vendor: Taxi successfully spawned.")
			else
					client:notify("Vendor: I can't spawn a taxi here, because something is blocking position.")
			end
		end
end);

netstream.Hook('taxi:RequestTaxi', function(client, additional)
		if client:getChar():CalledTaxi() then return end;
		local char = client:getChar()
		local balance = char:getMoney();
		local price = TAXI_DATA.price
		additional = tonumber(additional) or 0;

		if balance < price + additional then return end;

		local data = char:getData("TAXI");
		PLUGIN:TaxiOrder({
				name = client:GetName(),
				id = data.hash,
				position = client:GetPos(),
				price = price + additional,
		})
end);

netstream.Hook('taxi:RemoveTaxiOrder', function(client)
		client:getChar():RemoveTaxiOrder()
		PLUGIN:SortTaxiData()
		PLUGIN:SyncTaxiData()
end);

netstream.Hook('taxi::AcceptCall', function(client, hash)
		if !client:IsTaxi() then return end;

		if client:IsTaxi() && !client:HasTaxi() then
			client:notify("[TAXI]: You should own a taxi car to apply to new orders.")
			return;
		end

		local data = client:getChar():getData("TAXI");
		local customer = data.id
		if customer && customer:IsValid() && customer:IsPlayer() then

				client:getChar():RemoveTaxiOrder()

				netstream.Start(client, 'taxi::syncTaxiData', TAXI.orders)
				netstream.Start(client, 'taxi::OrderSet', nil )
				return;
		end

		local percent = math.Round(TAXI_DATA.price * (1 - (math.Clamp(TAXI_DATA.fee, 0, 100) / 100)), 2)

		local users = player.GetAll();
		local i = #users;
		while (i > 0) do
			local user = users[i];
			local id = user:getChar():CalledTaxi();
			if user:IsValid() && user:getLocalVar("TAXI")["hash"] == hash && id then
					if TAXI.orders[ id ].taken then return end;

					user:notify("[TAXI]: Your order have been taken by driver " .. client:Name() .. ".")
					user:getChar():takeMoney( percent )

					client:SetTaxi("id", user);

					user:SetTaxi("orderTaken", client)
					TAXI.orders[ id ].taken = true;

					netstream.Start(user, 'taxi::clearClientside')
					netstream.Start(client, 'taxi::OrderSet', TAXI.orders[ id ] )
					return;
			end
			i = i - 1;
		end;
		
		PLUGIN:SortTaxiData()
		PLUGIN:SyncTaxiData()
end);

netstream.Hook('taxi::DeclineDriveCustomer', function(client)
		local data = client:getChar():getData("TAXI");
		local taxist = data.orderTaken;
		if taxist && taxist:IsValid() && taxist:IsPlayer() then	

			client:getChar():RemoveTaxiOrder()
			
			netstream.Start(taxist, 'taxi::syncTaxiData', TAXI.orders)
			netstream.Start(taxist, 'taxi::OrderSet', nil )
			return;
		end;
end);

function PLUGIN:CanSpawnTaxi()
		local pos = TAXI_DATA.taxiSpawnPos;
		local tr = {
			start = pos,
			endpos = pos,
			mins = TAXI_DATA.obbsM,
			maxs = TAXI_DATA.obbsMax
		}
		local hullTrace = util.TraceHull( tr )

		return !hullTrace.Hit;
end;

function PLUGIN:TaxiOrder(data)
		TAXI.orders[#TAXI.orders + 1] = data;
		self:SortTaxiData()
		self:SyncTaxiData()
end;

function PLUGIN:SortTaxiData()
		local orders = table.Copy(TAXI.orders)
		local buffer = {}

		local i = table.maxn(orders);
		while (i > 0) do
			local data = orders[i];
			if data then
					buffer[#buffer + 1] = data;
			end
			i = i - 1;
		end

		TAXI.orders = buffer;
end;

function PLUGIN:SyncTaxiData()
		local plys = player.GetAll();

		local i = #plys;
		while (i > 0) do
			local user = plys[i];
			if user:getChar():getFaction() == FACTION_TAXI_WORKER then
					local customer = user:getChar():getData("TAXI").id
					if !customer || !customer:IsValid() then
						netstream.Start(user, 'taxi::syncTaxiData', TAXI.orders)
					end
			end
			i = i - 1;
		end;
end;