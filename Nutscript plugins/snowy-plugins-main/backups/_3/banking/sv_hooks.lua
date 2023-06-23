local PLUGIN = PLUGIN;

netstream.Hook('bankeer::exec', function(client, index, val)
		if !client:ValidateNPC("banking_npc") && !client:ValidateNPC("banking_atm") then return end;
		local Answer = PLUGIN:AnswerExists(index);

		if Answer && Answer.Execute then
				Answer.Execute(client, val);
		end
end);

netstream.Hook('bank::submitCheck', function(client, data)
		if !client:IsValid() then return end;
		local char = client:getChar();
		local check = char:getInv():getItemsOfType("check")
		if #check == 0 || !data then return end;

		for id, item in pairs(check) do
				local info = pon.decode(item:getData("checkData"))
				if info.checkID == data.checkID then
						if data.orderFor:len() == 0 then
								data.orderFor = "-----------------"
						end
						data.whoIs = client:GetName();
						item:setData("checkData", pon.encode(data))
						return;
				end
		end		
end);

netstream.Hook('bank::bankAction', function(client, operation, id, value)
		local char = client:getChar();
		if !char:hasFlags("B") then return end;

		if operation == "loan" then
			local acc = PLUGIN:BankingAccount(id);
			if acc then
					if PLUGIN.generalFund - value < 0 then
							return;
					end

					PLUGIN.generalFund = PLUGIN.generalFund - value
					acc.loan = math.Round(tonumber(value + (value * acc.interest/100)));
					acc.startloan = acc.loan;
					acc.bankeer = client:Name()
					acc.money = acc.money + tonumber(value)
					acc.loanUpdate = os.date("%d.%m.%y %H:%M:%S", os.time()+24*60*60)
					PLUGIN:BankingSaveData(id, acc)

					PLUGIN:BankingLog("Set the loan amount of "..acc.startloan.." for account #"..id, client:Name(), 1)
			end
		elseif operation == "openInventory" then
			local bank = PLUGIN:BankingAccount(id)

			if bank then
					local invID = bank.invID;
					nut.inventory.instances[invID]:sync(client)
					netstream.Start(client, 'bank::openCollector', invID)

					PLUGIN:BankingLog("Opened inventory for account #"..id, client:Name(), 1)
			end
		elseif operation == "interest" then
			local acc = PLUGIN:BankingAccount(id);
			if acc then
					acc.interest = tonumber(value);
					PLUGIN:BankingSaveData(id, acc)

					PLUGIN:BankingLog("Interest change for account #"..id..". New interest: "..acc.interest.."%", client:Name(), 1)
			end
		elseif operation == "removeLoan" then
			local acc = PLUGIN:BankingAccount(id);
			if acc then
					acc.loan = math.max(acc.loan - tonumber(value), 0)
					acc.loanUpdate = ""
					if acc.loan == 0 then
						acc.startloan = 0;
						acc.bankeer = "NONE"
					end
					PLUGIN:BankingSaveData(id, acc)

					PLUGIN:BankingLog("Loan removed for account #"..id, client:Name(), 1)
			end
		elseif operation == "removeAcc" then
					PLUGIN:RemoveBanking(id)

					PLUGIN:BankingLog("Account #"..id.." have been removed.", client:Name(), 1)
		end
end);

netstream.Hook('bank::PnlRemoved', function(client)
		local ent = client.usedVault;
		if ent != "" then
			if IsEntity(ent) then
				client.usedVault.used = false;
				ent:CallShutDown()
			end;
			client.usedVault = "";
		end
end);

netstream.Hook('bank::ValidateVaultPassword', function(client, passwd)
	if !client:ValidateNPC("banking_vault") then 
		netstream.Start(client, 'bank::CloseVaultClientside')
		return 
	end;
	local ent = client.usedVault;

	if !ent:GetShutDown() then
			local scenario = PLUGIN.vaultScenario[ent.scenario];
			if ent.passwd == passwd then
					local mon = math.min(scenario.REWARD, PLUGIN.generalFund);
					client:getChar():giveMoney(mon)
					PLUGIN.generalFund = math.max(PLUGIN.generalFund - scenario.REWARD, 0)
					client:notify("You've robbed the vault for "..mon.."! The alarms is on!")
					PLUGIN:BankingLog("ACCESS ATTEMPT TO VAULT! PASS: CORRECT;", "NONE", 1)
					netstream.Start(client, 'bank::CloseVaultClientside')
			end
	end

end);

netstream.Hook('bank::SyncVaultAttempts', function(client)
	if !client:ValidateNPC("banking_vault") then 
		netstream.Start(client, 'bank::CloseVaultClientside')
		return
	end;
	local ent = client.usedVault;

	if !ent:GetShutDown() then
			local scenario = PLUGIN.vaultScenario[ent.scenario];
			client.attempts = client.attempts - 1;
			netstream.Start(client, 'bank::SyncAttempts', client.attempts)
			if client.attempts <= 0 then
					netstream.Start(client, 'bank::CloseVaultClientside')
					PLUGIN:BankingLog("ACCESS ATTEMPT TO VAULT! PASS: INCORRECT;", client:Name(), 1)
			end
	end

end);