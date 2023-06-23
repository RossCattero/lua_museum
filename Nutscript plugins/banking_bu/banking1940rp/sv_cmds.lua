local PLUGIN = PLUGIN;
PLUGIN.BankingActs = {}

PLUGIN.BankingActs.createAcc = function(client, data)
		local charID, status = data.id, data.status
		if !client then return end;
		local char = client:getChar();
		if !char:hasFlags(BANKING_WRITER_FLAG) then client:notify("You don't have permission to do it.") return end;

		local character = nut.char.loaded[charID];
		if !character then client:notify("Can't find character") return end;

		if !client:getChar():doesRecognize(character) then return end;
		
		local target = character.player;
		if !target:IsValid() then client:notify("Player is not valid") return end;

		if client == target then return end;

		if PLUGIN.bankingAccounts[target:GetHash()] then client:notify("This target already have a banking account") return end;
		
		target:CreateHash()
		PLUGIN:MakeBankingAccount(target, status)
		client:notify("Banking account have been created succesfully.")
end;

PLUGIN.BankingActs.deleteAcc = function(client, data)
		local char = client:getChar();
		if !char:hasFlags(BANKING_BOOK_FLAG) then client:notify("You don't have permission to do it.") return end;

		PLUGIN:DeleteBankingAccount(data.id)
		client:notify("Account successfully removed")
end;

PLUGIN.BankingActs.setLoan = function(client, data)
		local char = client:getChar();
		if !char:hasFlags(BANKING_BOOK_FLAG) then client:notify("You don't have permission to do it.") return end;
		local loan = tonumber(data.loan) or 0;

		if tonumber(PLUGIN.moneyFunds) < loan then
			client:notify("The bank can't afford such loan!")
			return;
		end

		PLUGIN.moneyFunds = math.max(PLUGIN.moneyFunds - loan, 0)

		PLUGIN:UpdateBankingAccount(data.id, "loan", loan)
		PLUGIN:UpdateBankingAccount(data.id, "actualLoan", loan)
		PLUGIN:UpdateBankingAccount(data.id, "loanStamp", os.time() + 60 * BANKING_LOAN_TIME) 
		PLUGIN:UpdateBankingAccount(data.id, "bankeer", loan > 0 && client:GetName() || "NaN")

		for k, v in pairs(player.GetAll()) do
				if v:GetHash() == data.id then
						PLUGIN.loaners[v:getChar()] = loan > 0 && os.time() * 60 * BANKING_LOAN_TIME || nil;
						return;
				end
		end
end;

PLUGIN.BankingActs.changeStatus = function(client, data)
		local char = client:getChar();
		if !char:hasFlags(BANKING_BOOK_FLAG) then client:notify("You don't have permission to do it.") return end;

		PLUGIN:UpdateBankingAccount(data.id, "status", data.status)
		for k, v in pairs(player.GetAll()) do
				if v:GetHash() == data.id then
						PLUGIN.loaners[v:getChar()] = PLUGIN.depInterest[data.status] > 0 && os.time() * 60 * BANKING_DEP_TIME || nil;
						return;
				end
		end
end;

-- local entity = Entity(2);
-- local bank = entity:HasBankingAccount()

-- local time = bank.loanStamp;

-- print(time < os.time())