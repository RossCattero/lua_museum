local PLUGIN = PLUGIN
PLUGIN.name = "Banking plugin"
PLUGIN.author = "Ross Cattero"
PLUGIN.desc = "Banking plugin done by Ross."

nut.flag.add("B", "Access to banking")

PLUGIN.TalkBacks 	= {}
PLUGIN.Answers 		= {}
PLUGIN.vaultScenario = {
		[1] = { // Easy
			NAME = "Easy",
			BINARY = 7,
			INTER = 4,
			ATTEMPTS = 10,
			TIME = 720,
			REWARD = 550,
		},
		[2] = { // Medium
			NAME = "Medium",
			BINARY = 7,
			INTER = 4,
			ATTEMPTS = 5,
			TIME = 300,
			REWARD = 6000,
		},
		[3] = { // Hard
			NAME = "Hard",
			BINARY = 15,
			INTER = 8,
			ATTEMPTS = 3,
			TIME = 120,
			REWARD = 10000,
		}
}

nut.util.include("sh_meta.lua")
nut.util.include("cl_hooks.lua")
nut.util.include("sv_meta.lua")
nut.util.include("sv_hooks.lua")
nut.util.include("sv_plugin.lua")
nut.util.include("sv_access_rules.lua")

// Talkbacks of NPC;
function PLUGIN:AddTalkback(name, data)
		self.TalkBacks[name] = data;
end;

// Answers of NPC;
function PLUGIN:AddAnswer(name, data)
		self.Answers[name] = data;
end;

PLUGIN:AddTalkback("hello", {
	text = "Hello! I'm a bank manager and I can help you with some banking things.",
	OnOpen = true,
})
PLUGIN:AddTalkback("bank_acc_open", {
	text = "Good to hear. Do you really want to open a bank account?",
})
PLUGIN:AddTalkback("bank_acc_open_succ", {
	text = "Good, I'm going to open the bank account for you. Have a nice day!",
})
PLUGIN:AddTalkback("bank_acc_open_failed", {
	text = "I'm understand. Return when you want to open an account!",
})
PLUGIN:AddTalkback("bank_deposit", {
	text = "Tell me the amount of how much you want to deposit.",
})
PLUGIN:AddTalkback("bank_withdraw", {
	text = "Tell me the amount of how much you want to withdraw.",
	format = function(text)
			return string.format(text .. "\nYou can withdraw: %d", LocalPlayer():BankData().money)
	end;
})
PLUGIN:AddTalkback("bank_loaned", {
	text = "How much of loan do you want to pay?",
	format = function(text)
			return string.format(text .. "\nYou should repay: %d", LocalPlayer():BankData().loan)
	end;
})
PLUGIN:AddTalkback("bank_acc_money_amount", {
	text = "Let me check...",
	format = function(text)
			return string.format(text .. "\nYou have: %d", LocalPlayer():BankData().money)
	end;
})
PLUGIN:AddTalkback("check_depo", {
	text = "Type here check ID you want to deposit.",
})

-- <><><><><><><><><><> Default answers <><><><><><><><><><> --
PLUGIN:AddAnswer("bank_openacc", {
	text = "I want to open an account",
	callClick = {"bank_yes", "bank_no"},
	remClick = {"bank_openacc", "_bank_ex", "bank_depositcheck"},
	talkBack = "bank_acc_open",
	OnOpen = true,
	CanShow = function(act) 
			local char = act:getChar();
			
			return char:getData("banking_account") == 0
	end;
})
PLUGIN:AddAnswer("bank_openitembox", {
	text = "I want to access itembox",
	CanShow = function(act) 
			local char = act:getChar();
			local acc = char:getData("banking_account")
			
			return acc != 0
	end,
	Execute = function(client)
			local bank = client:BankingAccount()

			if bank then
					local bankID = client:GetBankingID();
					local invID = bank.invID

					nut.inventory.instances[invID]:sync(client)
					netstream.Start(client, 'bank::openCollector', invID)
					PLUGIN:BankingLog("Bank itembox access", client:Name());
			end
	end
})
PLUGIN:AddAnswer("bank_depositmoney", {
	text = "I want to deposit money",
	callClick = {"bank_withdrawmoney", "bank_saymemoney", "bank_openitembox", "bank_depositcheck", "bank_repayLoan", "bank_depositmoney", "_bank_ex"},
	EntryCreate = true,
	talkBack = "bank_deposit",
	CanShow = function(act) 
			local char = act:getChar();
			local money = act:getMoney();
			local acc = char:getData("banking_account")
			
			return acc != 0 && PLUGIN.bankINFO["money"] && money > 0;
	end,
	Execute = function(act, val)
			val = tonumber(val)

			if act.execCD && CurTime() < act.execCD then
				act:notify("You need to wait "..math.Round(act.execCD - CurTime()).." seconds to do an another procedure!")
				return;
			end;
			
			if val then
					act:BankingOperation("Deposit", val)
					act.execCD = CurTime() + 4;
			end
	end
})
PLUGIN:AddAnswer("bank_withdrawmoney", {
	text = "I want to withdraw money",
	callClick = {"bank_withdrawmoney", "bank_saymemoney", "bank_openitembox", "bank_depositcheck", "bank_repayLoan", "bank_depositmoney", "_bank_ex"},
	EntryCreate = true,
	talkBack = "bank_withdraw",
	CanShow = function(act) 
			local char = act:getChar();
			local acc = char:getData("banking_account")

			return acc != 0 && PLUGIN.bankINFO["money"] && PLUGIN.bankINFO["money"] > 0
	end,
	Execute = function(act, val)
			val = tonumber(val)
			
			if act.execCD && CurTime() < act.execCD then
				act:notify("You need to wait "..math.Round(act.execCD - CurTime()).." seconds to do an another procedure!")
				return;
			end;
			
			if val then
					act:BankingOperation("Withdraw", val)
					act.execCD = CurTime() + 4;
			end
	end
})
PLUGIN:AddAnswer("bank_depositcheck", {
	text = "Deposit a check",
	callClick = {"bank_openacc", "bank_saymemoney", "bank_withdrawmoney", "bank_openitembox", "bank_depositcheck", "bank_repayLoan", "bank_depositmoney", "_bank_ex"},
	EntryCreate = true,
	talkBack = "check_depo",
	CanShow = function(act) 
			local char = act:getChar();
			local acc = char:getData("banking_account")

			return acc != 0
	end,
	Execute = function(act, val)
			local char = act:getChar();
			local acc = char:getData("banking_account")
			if acc == 0 then
					act:notify("You don't have a banking account.")
					return;
			end
			local check = char:getInv():getItemsOfType("check")
			val = tonumber(val)
			if !val then return; end;
		
			for id, item in pairs(check) do
					local info = pon.decode(item:getData("checkData"))
					local find = nut.command.findPlayer(act, info.whoIs);
					local check = info.checkID;
					local amount = info.amount;
					if check == val then
						if find then
								local bankID = find:GetBankingID()
								if bankID != 0 then
										local banking = PLUGIN:BankingAccount(bankID)
										if banking["money"] >= amount then
												banking.money = banking.money - amount;
												PLUGIN:BankingSaveData(bankID, banking);										
												banking = PLUGIN:BankingAccount(acc);
												banking.money = banking.money + amount;
												PLUGIN:BankingSaveData(acc, banking);
												item:remove()	
												act:notify("Check is successfully deposited.")
												PLUGIN:BankingLog("Successfull check deposit with amount of "..amount, act:Name(), 2);
												return;
										else
												act:notify("The owner of check don't have this amount of money on account.")
												PLUGIN:BankingLog("Check deposit attempt: FAILURE. Reason: the owner don't have enough money on account", act:Name(), 1);
										end;
								else
										act:notify("The owner of this check don't have a banking account.")
										PLUGIN:BankingLog("Check deposit attempt: FAILURE. Reason: Invalid owner", act:Name(), 1);
								end
						else
								act:notify("Can't find bank account owner named " .. info.whoIs)
								PLUGIN:BankingLog("Check deposit attempt: FAILURE. Reason: Invalid owner", act:Name(), 1);
						end;
					else
							act:notify("You don't have a check with such ID: " .. val)
					end
			return;
			end;
			act:notify("You don't have a check with such ID: " .. val)
	end
})
PLUGIN:AddAnswer("bank_repayLoan", {
	text = "Repay loan",
	callClick = {"bank_withdrawmoney", "bank_saymemoney", "bank_openitembox", "bank_depositcheck", "bank_repayLoan", "bank_depositmoney", "_bank_ex"},
	EntryCreate = true,
	talkBack = "bank_loaned",
	CanShow = function(act) 
			local char = act:getChar();
			local acc = char:getData("banking_account")

			return acc != 0 && PLUGIN.bankINFO["loan"] && PLUGIN.bankINFO["loan"] > 0
	end,
	Execute = function(client, val)
			local bank = client:BankingAccount()
			local char = client:getChar();
			local money = char:getMoney()
			val = tonumber(val)
			if val && bank then
				if money >= val then
					char:takeMoney(val)
					bank.loan = math.max(bank.loan - val, 0);
					PLUGIN.generalFund = PLUGIN.generalFund + val
					if bank.loan == 0 then
							bank.startloan = 0;
							bank.bankeer = "None"
							bank.interest = 1
							bank.loanUpdate = ""
					end
					client:notify("You repaid " .. bank.startloan - bank.loan .. " out of " .. bank.startloan)
					PLUGIN:BankingLog("Loan repay with amount of "..val, client:Name(), 2);
					client:BankingSaveData(bank)
				else
					client:notify("You don't have that amount of money to pay.")
				end;
			end
	end
})
PLUGIN:AddAnswer("bank_saymemoney", {
	text = "How much money do I have on a account?",
	OnOpen = true,
	CanShow = function(act) 
			local char = act:getChar();
			local acc = char:getData("banking_account")

			return acc != 0
	end,
	talkBack = "bank_acc_money_amount",
})
-- <><><><><><><><><><> Default answers <><><><><><><><><><> --

-- <><><><><><><><><><> Do's <><><><><><><><><><> --
PLUGIN:AddAnswer("bank_yes", {
	text = "Yes",
	callClick = {"bank_withdrawmoney", "bank_saymemoney", "bank_depositcheck", "bank_openitembox", "bank_repayLoan", "bank_depositmoney", "_bank_ex"},
	remClick = {"bank_yes", "bank_no"},
	talkBack = "bank_acc_open_succ",
	Execute = function(client)
			local char = client:getChar();
			
			timer.Simple(0, function()
				char:setData("banking_account", os.time() + 32)
				client:RegisterBanking(char:getData("banking_account"));
			end);
	end,
})
PLUGIN:AddAnswer("bank_no", {
	text = "No",
	callClick = {"bank_openacc", "bank_regitembox", "bank_depositcheck", "_bank_ex"},
	remClick = {"bank_yes", "bank_no"},
	talkBack = "bank_acc_open_failed",
})
-- <><><><><><><><><><> Do's <><><><><><><><><><> --

-- <><><><><><><><><><> Functionality <><><><><><><><><><> --
PLUGIN:AddAnswer("_bank_ex", {
	text = "Exit",
	close = true,
	OnOpen = true,
})
-- <><><><><><><><><><> Functionality <><><><><><><><><><> --

// Model list for banking NPCs
PLUGIN.modelList = {}
for i = 1, 9 do
	PLUGIN.modelList[i] = "models/suits/male_0"..i.."_closed_tie.mdl"
end

nut.command.add("setFunds", {
	adminOnly = true,
	syntax = "<string amount>",
	onRun = function(client, arguments)
			local value = tonumber(arguments[1]) or 0;

			PLUGIN.generalFund = value;
			client:notify("The amount of general fund is set to: "..value .. nut.currency.symbol)
			PLUGIN:BankingLog("Global banking fund changed to "..value, client:Name(), 1);
	end
})

nut.command.add("bank", {
	adminOnly = true,
	onCheckAccess = function(client)
			return client:getChar():hasFlags("B")
	end,
	syntax = "",
	onRun = function(client, arguments)
			if client:getChar():hasFlags("B") then
				local data = pon.encode({PLUGIN.bankingAccounts, PLUGIN.generalFund})
				netstream.Start(client, "bank::openBanking", data)
				PLUGIN:BankingLog("Access to banking data", client:Name(), 1);
			else
					client:notify("You don't know the password to access to the banking database.")
			end
	end
})

nut.command.add("bankLogs", {
	adminOnly = true,
	onCheckAccess = function(client)
			return client:getChar():hasFlags("B")
	end,
	syntax = "",
	onRun = function(client, arguments)
			if client:getChar():hasFlags("B") then
				local data = pon.encode(PLUGIN.bankingLogs);
				netstream.Start(client, "bank::OpenLogsList", data)
			else
					client:notify("You don't know the password to access to the banking database.")
			end
	end
})