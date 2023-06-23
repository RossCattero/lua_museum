local PLUGIN = PLUGIN;

PLUGIN.answers = {};
PLUGIN.questions = {};
PLUGIN.startAns = {}
PLUGIN.startQs = 0;

function PLUGIN:InsertAnswer(id, data, start)
		if !data.text then return end;

		if start then self.startAns[#self.startAns + 1] = id; end;
		self.answers[id] = data;
end;

function PLUGIN:InsertQs(id, data, start)
		if !data.text then return end;

		if start then self.startQs = id; end;
		self.questions[id] = data;
end;

PLUGIN:InsertQs(1, {
	text = "Hello, my name is test! I'm working at bank and can help you to deal with banking problems.",
}, true)
PLUGIN:InsertQs(2, {
	text = "Your money amount:",
	format = function(text)
			return string.format(text .. " %d " .. BANKING_REICHMARK, BANKING_INFORMATION && BANKING_INFORMATION.money || 0)
	end,
})
PLUGIN:InsertQs(3, {
	text = "Type money for deposit:",
})
PLUGIN:InsertQs(4, {
	text = "Type money for withdraw:",
})
PLUGIN:InsertQs(5, {
	text = "Type check ID (can be found on check):",
})
PLUGIN:InsertQs(6, {
	text = "Type loan amount (Your loan %s):",
	format = function(text)
		text = string.format(text, BANKING_INFORMATION.loan .. BANKING_REICHMARK)
		return text;
	end;
})

PLUGIN:InsertAnswer(1, {
		text = "I want to make a deposit",
		question = 1,
		canSee = function(client) return true; end,
		newAns = {[1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true, [7] = true},
		input = 3,
		callback = function(client, amount)
				amount = tonumber(amount)
				if !amount || amount <= 0 then return end;
				local bank = client:HasBankingAccount()
				if !bank then return end
				local char = client:getChar()

				if char:getMoney() >= amount then
					local bank = client:HasBankingAccount()
					if !bank then return end

					client:addMoney(-amount)
					bank.money = bank.money + amount
					client:notify("You transfered " .. amount .. " " .. BANKING_REICHMARK .. " to banking account.")
					client:ReceiveBankingInfo()

					BANKING_LOGS:AddLog(client:GetHash(), "Money deposit (+" .. amount..")")
				else
					client:notify("You don't have enough money.")
				end	
		end,
}, true)
PLUGIN:InsertAnswer(2, {
		text = "I want to make a withdraw",
		question = 1,
		canSee = function() return true; end,
		newAns = {[1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true, [7] = true},
		input = 4,
		callback = function(client, amount)
				amount = tonumber(amount)
				if !amount || amount <= 0 then return end;
				local bank = client:HasBankingAccount()
				if !bank then return end

				if bank.money >= amount then
					client:addMoney(amount)
					bank.money = bank.money - amount
					client:notify("You received " .. amount .. " " .. BANKING_REICHMARK)
					client:ReceiveBankingInfo()

					BANKING_LOGS:AddLog(client:GetHash(), "Money withdraw (-" .. amount..")")
				else
					client:notify("You don't have enough money on banking account.")
				end	
		end,
}, true)
PLUGIN:InsertAnswer(3, {
		text = "Money amount",
		question = 2,
		canSee = function() return true; end,
		newAns = {[1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true, [7] = true},
}, true)

PLUGIN:InsertAnswer(4, {
		text = "I want to access itembox",
		question = 1,
		canSee = function(client) return BANKING_INFORMATION && BANKING_INFORMATION.invID > 0; end,
		newAns = {[1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true, [7] = true},
		callback = function(client)
				local bank = client:HasBankingAccount()
				if !bank then return end
				
				if bank.invID > 0 then
					nut.inventory.instances[bank.invID]:sync(client)
					netstream.Start(client, 'Banking::OpenINV', bank.invID)

					BANKING_LOGS:AddLog(client:GetHash(), "Banking inventory opened")
				end;
		end,
}, true)

PLUGIN:InsertAnswer(5, {
		text = "Deposit a check",
		question = 1,
		canSee = function(client) return true; end,
		newAns = {[1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true, [7] = true},
		input = 5,
		callback = function(client, id)
				local cusAcc = client:HasBankingAccount()
				if !cusAcc then return end;

				if !id then return end;
				local item = client:FindValidCheck(tonumber(id));

				if item then
						local data = item:getData("check")
						local who = data.accountNumber;
						local name = data.whoIs;
						local amount = data.amount;
						local acc = BankingAccounts[who];

						if !who || who == 0 || !acc then
							client:notify("This account is not exists.")
							return;
						end;

						if acc.money >= amount then
								acc.money = acc.money - amount
								cusAcc.money = cusAcc.money + amount;
								client:notify("You received " .. amount .. " " .. BANKING_REICHMARK .. " from " .. name )
								client:ReceiveBankingInfo()

								BANKING_LOGS:AddLog(client:GetHash(), "Check deposit (+" .. amount..") from "..name, 1)
						else
								client:notify("The check's banking account don't have enough money")
								return;
						end;
						
						item:remove();
				else
					client:notify("You don't have a check with such ID.")
				end
		end,
}, true)

PLUGIN:InsertAnswer(6, {
		text = "Repay loan",
		question = 1,
		canSee = function(client) 
			return BANKING_INFORMATION && BANKING_INFORMATION.loan > 0;
		end,
		newAns = {[1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true, [7] = true},
		input = 6,
		callback = function(client, amount)
			amount = tonumber(amount)
			if !amount || amount <= 0 then return end;
			local cusAcc = client:HasBankingAccount()
			if !cusAcc then return end;
			local money = client:getChar():getMoney();

			if money >= amount then
				if cusAcc.loan - amount < 0 then amount = cusAcc.loan end
				cusAcc.loan = cusAcc.loan - amount;
				client:addMoney(-amount)
				if cusAcc.loan > 0 then
					client:notify("You paid off " .. amount .. " / " .. cusAcc.loan + amount)
					client:ReceiveBankingInfo()

					BANKING_LOGS:AddLog(client:GetHash(), "Loan pay off: (-" ..amount..")")
				else
					cusAcc.bankeer = "NaN";
					cusAcc.actualLoan = 0;
					client:notify("You don't have any loans now.")
					BANKING_LOGS:AddLog(client:GetHash(), "Fully paid off the loan")
				end;
			else
				client:notify("You don't have this amount of money.")
			end
			
		end,
}, true)

PLUGIN:InsertAnswer(7, {
		text = "Exit",
		service = "exit"
}, true)