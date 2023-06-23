local PLUGIN = PLUGIN;

local function AccessBanking(inventory, action, context)
	if inventory then
		local user = context.client

		-- local client = context.client
		-- if (not IsValid(client)) then return end
		-- local storage = context.storage or client.nutStorageEntity
		-- if (not IsValid(storage)) then return end
		-- if (storage:getInv() ~= inventory) then return end

		-- -- If the player is too far away from storage, then ignore.
		-- local distance = storage:GetPos():Distance(client:GetPos())
		-- if (distance > MAX_ACTION_DISTANCE) then return false end

		-- -- Allow if the player is a receiver of the storage.
		-- if (storage.receivers[client]) then
		-- 	return true
		-- end

		local account = nut.banking.instances[ user:getChar():getID() ]
		if !account then return false end;
		
		local invID = tostring(account.invID);
		if !invID then return false end;

		return invID == tostring(inventory.id) && nut.inventory.instances[tonumber(invID)]
	end

	return false;
end;

function PLUGIN:BankingAccess(inventory)
	if inventory then
		inventory:addAccessRule(AccessBanking);
	end;
end