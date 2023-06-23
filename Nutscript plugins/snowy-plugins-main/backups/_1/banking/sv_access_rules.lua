local PLUGIN = PLUGIN;

local function AccessBanking(inventory, action, context)
		local user = context.client
		local bankID = user:GetBankingID()
		local invID = user:BankingAccount().invID;

		return user:BankingAccount() && invID == inventory.id && nut.inventory.instances[invID]
end;

function PLUGIN:BankingAccess(inventory)
	if inventory then
		inventory:addAccessRule(AccessBanking);
	end;
end