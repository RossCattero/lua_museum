local PLUGIN = PLUGIN;
local user = FindMetaTable("Player")

function user:IsTaxi()
		return self:getChar():getFaction() == FACTION_TAXI_WORKER;
end;

function user:HasTaxi()
		local taxi = self:getChar():getData("TAXI")
		return taxi.hasCar
end;

function user:TaxiCalled()
		return timer.Exists("TaxiCalled")
end;

function user:StopTaxiSearch()
		timer.Remove("TaxiCalled")
		TAXI_SECONDS = 0;
end;

function user:CanCallTaxi()
		local taxi = self:getChar():getData("TAXI")
		return !taxi.orderTaken || !taxi.orderTaken:IsValid()
end;

function user:GotCustomer()
		local taxi = self:getChar():getData("TAXI")
		return taxi.id != nil && taxi.id:IsValid() && taxi.id
end;