local PLUGIN = PLUGIN;

local function AccessCarBaggage(inventory, action, context)
	local client = context.client
	if (not IsValid(client)) then return end

	local car = nut.car_vendor.instances[ client:getChar():getID() ];
	if !car then return end;

	local invID = car.baggageID;
	if (invID == inventory:getID() && nut.inventory.instances[ invID ]) then 
		return true;
	end

	return false;
end;

function PLUGIN:CarBaggage(inventory)
	if inventory then
		inventory:addAccessRule(AccessCarBaggage);
	end;
end