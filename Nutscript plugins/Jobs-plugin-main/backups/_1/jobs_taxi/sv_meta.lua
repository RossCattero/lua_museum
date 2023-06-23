local PLUGIN = PLUGIN;

local user = FindMetaTable("Player")
function user:SetTaxi(index, value)
		local data = self:getChar():getData("TAXI")

		data[index] = value;

		self:getChar():setData("TAXI", data);
		self:setLocalVar("TAXI", data);
end;

function user:GetTaxi()
		local taxi = self:getChar():getData("TAXI")
		return IsValid(taxi.entity) && taxi.entity;
end

// Same as for player;
function nut.meta.character:CalledTaxi()
		if !self.player then return end;

		local hash = self:getData("TAXI").hash;
		local data = TAXI.orders

		local i = #data;
		while (i > 0) do
			local order = data[i];

			if order.id == hash then
					return i;
			end
			i = i - 1;
		end
end;

function nut.meta.character:RemoveTaxiOrder()
		if !self.player then return end;

		local data = self:getData("TAXI");
		local taxiNum = self:CalledTaxi()
		
		if taxiNum then
				TAXI.orders[taxiNum] = nil;
		end

		local taxist = data.orderTaken;
		local orderer = data.id;

		// Taxist declines;
		if orderer && orderer:IsValid() && orderer:IsPlayer() then
				data.id = NULL;
				orderer:SetTaxi("orderTaken", NULL);

				orderer:notify("[TAXI]: Driver declined the order. You received back a fee for call.");

				local taxiNum = orderer:getChar():CalledTaxi()
		
				if taxiNum then
						TAXI.orders[taxiNum] = nil;
				end

				self:setData("TAXI", data);
				return;
		end;

		// Customer declines;
		if taxist && taxist:IsValid() && taxist:IsPlayer() then	
				data.orderTaken = NULL;
				taxist:SetTaxi("id", NULL);

				taxist:notify("[TAXI]: Customer decided to not to drive with you. You received a call fee.")

				self:setData("TAXI", data);
				return;
		end;
end;

function nut.meta.character:DisconnectHandle()
		if !self.player then return end;
		local data = self:getData("TAXI")

		if data.hasCar then
				if data.entity then data.entity:Remove(); end;

				data.hasCar = false;
				data.entity = NULL;
		end;

		if self:CalledTaxi() then
				self:RemoveTaxiOrder()
				PLUGIN:SortTaxiData()
				PLUGIN:SyncTaxiData()
				netstream.Start(self.player, 'taxi::clearClientside')
		end

		if data.id && data.id:IsValid() then
				self:RemoveTaxiOrder()
				PLUGIN:SortTaxiData()
				PLUGIN:SyncTaxiData()
		end

		self:setData("TAXI", data);
end;