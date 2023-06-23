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

		if BankingAccounts[target:GetHash()] then client:notify("This target already have a banking account") return end;
		
		target:CreateHash()
		PLUGIN:MakeBankingAccount(target, status)
		client:notify("Banking account have been created succesfully.")

		BANKING_LOGS:AddLog(client:GetName(), "Account created for " .. target:GetName(), 1)
end;

PLUGIN.BankingActs.deleteAcc = function(client, data)
		local char = client:getChar();
		if !char:hasFlags(BANKING_BOOK_FLAG) then client:notify("You don't have permission to do it.") return end;

		PLUGIN:DeleteBankingAccount(data.id)
		client:notify("Account successfully removed")

		BANKING_LOGS:AddLog(client:GetName(), "Account deleted for " .. data.id, 1)
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
		PLUGIN:UpdateBankingAccount(data.id, "bankeer", loan > 0 && client:GetName() || "NaN")
		
		local accMoney = PLUGIN:CheckAcc(data.id)
		if loan > 0 then
			PLUGIN:UpdateBankingAccount(data.id, "money", accMoney.money + loan)
			BANKING_LOGS:AddLog(client:GetName(), "Loan set for " .. data.id .. " in amount of " .. loan)
		else
			BANKING_LOGS:AddLog(client:GetName(), "Loan remove for " .. data.id, 1)
		end;

		for k, v in pairs(player.GetAll()) do
				if v:GetHash() == data.id then
						PLUGIN.loaners[v:getChar()] = loan > 0 && os.time() + 60 * BANKING_LOAN_TIME || nil;
						return;
				end
		end
end;

PLUGIN.BankingActs.changeStatus = function(client, data)
		local char = client:getChar();
		if !char:hasFlags(BANKING_BOOK_FLAG) then client:notify("You don't have permission to do it.") return end;

		PLUGIN:UpdateBankingAccount(data.id, "status", data.status) 
		PLUGIN:UpdateBankingAccount(data.id, "depinterest", PLUGIN.loanInterest[data.status] || 1) 
		BANKING_LOGS:AddLog(client:GetName(), "Account status changed for " .. data.id .. " to " .. data.status, 1)
		for k, v in pairs(player.GetAll()) do
				if v:GetHash() == data.id then
						PLUGIN.depInterest[v:getChar()] = PLUGIN.depInterest[data.status] > 0 && os.time() + 60 * BANKING_DEP_TIME || nil;
						return;
				end
		end
end;

PLUGIN.BankingActs.itemsLook = function(client, data)
		local char = client:getChar();
		if !char:hasFlags(BANKING_BOOK_FLAG) then client:notify("You don't have permission to do it.") return end;
		local bank = PLUGIN:CheckAcc(data.id)

		if !bank then return end;

		local invID = bank.invID;
		nut.inventory.instances[invID]:sync(client)
		netstream.Start(client, 'Banking::OpenINV', invID)

		BANKING_LOGS:AddLog(client:GetName(), "Opened banking inventory for " .. data.id, 1)
end;
