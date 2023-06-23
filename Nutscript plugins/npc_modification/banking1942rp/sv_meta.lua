local PLUGIN = PLUGIN;

local user = FindMetaTable("Player")

function user:CreateHash()
		local character = self:getChar();
		local hash = PLUGIN:MakeHashID(8);

		character:setData("Hash", character:getData("Hash", hash))
		self:setLocalVar("Hash", character:getData("Hash", hash))
end;

function user:GetHash()
		return self:getChar():getData("Hash")
end;

function user:ReceiveBankingData()
		if self:getChar():hasFlags(BANKING_BOOK_FLAG) then
			netstream.Start(self, 'Banking::SyncBanking', BankingAccounts, PLUGIN.moneyFunds)
		end;
end;

function user:HasBankingAccount()
		local hash = self:GetHash()

		return BankingAccounts[hash]
end;

function user:ReceiveBankingInfo()
		netstream.Start(self, 'Banking::SyncBankInfo', self:HasBankingAccount())
end;

function user:HasLoan()
		local bank = self:HasBankingAccount();

		return bank && bank.loan && bank.loan > 0
end;

function user:CanIncreaseDeposit()
		local bank = self:HasBankingAccount();
		local statuses = PLUGIN.depInterest;

		return bank && bank.status && statuses[bank.status] && statuses[bank.status] > 0;
end;

function user:FindValidCheck(id)
		local char = self:getChar();
		local check = char:getInv():getItemsOfType("check")
		if #check == 0 then return end;

		for _, item in pairs(check) do
				if item:getData("check").checkID == id then
						return item
				end
		end		
end;