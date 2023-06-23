local PLUGIN = PLUGIN;

function PLUGIN:PlayerLoadedChar(client, character, prev)
		timer.Simple(0.25, function()
				client:ReceiveBankingData()

				if client:CanIncreaseDeposit() then
						self.depositers[character] = os.time() * 60 * BANKING_DEP_TIME;
				end
				if client:HasLoan() then
						self.loaners[character] = os.time() * 60 * BANKING_LOAN_TIME;
				end
		end);
end;
function PLUGIN:SaveData()
		nut.data.set("banking_accounts", self.bankingAccounts)
		nut.data.set("banking_id", self.bankID)
		nut.data.set("banking_funds", self.moneyFunds)
end;

function PLUGIN:LoadData()
		local bAccounts = nut.data.get("banking_accounts", {})
		local bID = nut.data.get("banking_id", 1)
		local money = nut.data.get("banking_funds", 0)
		self.bankingAccounts = bAccounts;
		self.bankID = bID
		self.moneyFunds = money
end;

netstream.Hook('Banking::BankingAction', function(client, action, data)
		local act = PLUGIN.BankingActs[action];
		
		if act && data.id then
				act( client, data )
		end
end);

function PLUGIN:MakeBankingAccount(target, status)
		local hash = target:GetHash();
		local name = target:GetName()
		if self:CheckAcc(hash) then return end;

		local i = #self.bankingStatuses;
		while (i > 0) do
				if self.bankingStatuses[i] then
					status = self.bankingStatuses[i]
				end;
				i = i - 1;
		end;
		if !status then status = "None" end;

		self.bankingAccounts[ hash ] = {
				id = PLUGIN.bankID,
				name = name,
				money = 0,
				loan = 0,
				actualLoan = 0,
				bankeer = "NaN",
				interest = self.loanInterest[status] or 1,
				depinterest = self.depInterest[status] or 0,
				status = status,
		}
		self.bankID = self.bankID + 1;

		if self.depInterest[status] != 0 then
				PLUGIN.depositers[target:getChar()] = os.time() + 60 * BANKING_DEP_TIME;
		end;

		self:SyncBankingAccounts()
end;

function PLUGIN:DeleteBankingAccount(hash)
		if !self:CheckAcc(hash) then return end;

		self.bankingAccounts[hash] = nil;
		
		self:SyncBankingAccounts()
end;

function PLUGIN:UpdateBankingAccount(hash, data, value, target)
		if !self:CheckAcc(hash) then return end;

		self.bankingAccounts[hash][data] = value;
		
		self:SyncBankingAccounts()
end;

function PLUGIN:CheckAcc(hash)
		return self.bankingAccounts[hash]
end;

function PLUGIN:SyncBankingAccounts()
		local plys = player.GetAll()
		local i = #plys;
		while (i > 0) do
				local ply = plys[i];
				local char = ply:getChar();
				if ply && char then
						ply:ReceiveBankingData();
				end
				i = i - 1;
		end;
end;

local uniqueID = 'DepositsMultipication'
timer.Create(uniqueID, 300, 0, function() // Timer checks every 5 minutes;
	if !timer.Exists(uniqueID) then timer.Remove(uniqueID) return; end;

	if next(PLUGIN.depositers) == nil then return end;

	for char, stamp in pairs(PLUGIN.depositers) do
			if IsValid(char.player) && stamp < os.time() then
					local bank = char.player:HasBankingAccount()
					local status = PLUGIN.depInterest[bank.status] or 0;
					PLUGIN.depositers[char] = os.time() * 60 * BANKING_DEP_TIME;
					if status <= 0 then
							PLUGIN.depositers[char] = nil;
					end
					if status && status > 0 then PLUGIN:UpdateBankingAccount( char.player:GetHash(), "money", bank.money * (1 - (status/100)) ) end;
			end;
	end
end);

local uniqueID = 'LoanMultiplication'
timer.Create(uniqueID, 300, 0, function()
	if !timer.Exists(uniqueID) then timer.Remove(uniqueID) return; end;
	
	if next(PLUGIN.loaners) == nil then return end;

	for char, stamp in pairs(PLUGIN.loaners) do
			if IsValid(char.player) && stamp < os.time() then
					local bank = char.player:HasBankingAccount()
					PLUGIN.loaners[char] = os.time() * 60 * BANKING_LOAN_TIME;
					if !char.player:HasLoan() then PLUGIN.loaners[char] = nil; end
					if char.player:HasLoan() then PLUGIN:UpdateBankingAccount(char.player:GetHash(), "loan", bank.loan * (1 + (bank.interest/100)) ) end;
			end;
	end
end);

-- PLUGIN.bankingAccounts = {}
-- PLUGIN:SyncBankingAccounts()