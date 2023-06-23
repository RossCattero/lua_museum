local PLUGIN = PLUGIN;

local function AccessBanking(inventory, action, context)
		if inventory then
				local user = context.client
				local bankingAccount = user:BankingAccount()

				if !bankingAccount then return false end;
				local invID = tostring(bankingAccount.invID);
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