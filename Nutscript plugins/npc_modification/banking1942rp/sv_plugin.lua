local PLUGIN = PLUGIN;

BANKING_ENTS = BANKING_ENTS || {}

function PLUGIN:PlayerLoadedChar(client, character, prev)
		if prev then
			if self.depositers[prev] then self.depositers[prev] = nil; end;
			if self.loaners[prev] then self.loaners[prev] = nil; end
		end
		
		timer.Simple(0.25, function()
				client:ReceiveBankingData()
				client:setLocalVar("Hash", character:getData("Hash"))

				if client:CanIncreaseDeposit() then
						self.depositers[character] = os.time() + 60 * BANKING_DEP_TIME;
				end
				if client:HasLoan() then
						self.loaners[character] = os.time() + 60 * BANKING_LOAN_TIME;
				end

				local hash = client:GetHash()
				local acc = BankingAccounts[hash];

				if acc && acc.invID != 0 then
						nut.inventory.loadByID(acc.invID)
						:next(function(inventory) 				
								hook.Run("BankingAccess", inventory)
								inventory:sync(client)
						end)
				end;
		end);
end;
function PLUGIN:SaveData()
		nut.data.set("banking_accounts", BankingAccounts)
		nut.data.set("banking_id", self.bankID)
		nut.data.set("banking_funds", self.moneyFunds)
		nut.data.set("banking_logs", BANKING_LOGS.logs)

		local buffer = {}
		local tbl = table.Copy(BANKING_ENTS)
		for ent, info in pairs(tbl) do
			info.position = ent:GetPos();
			info.angles = ent:GetAngles();
			info.class = ent:GetClass()

			buffer[#buffer + 1] = info;
		end

		nut.data.set("banking_entities", buffer)
end;

function PLUGIN:LoadData()
		local bAccounts = nut.data.get("banking_accounts", {})
		local bID = nut.data.get("banking_id", 1)
		local money = nut.data.get("banking_funds", 0)
		local logs = nut.data.get("banking_logs", {})
		local sEnts = nut.data.get("banking_entities", {})
		BankingAccounts = bAccounts;
		self.bankID = bID
		self.moneyFunds = money
		BANKING_LOGS.logs = logs;

		if next(bAccounts) == nil then return end;
		
		for k, v in pairs(bAccounts) do
				if v.invID && v.invID != 0 then
					nut.inventory.loadByID(v.invID)
						:next(function(inventory) 				
							hook.Run("BankingAccess", inventory)
					end)
				end
		end

		if #sEnts > 0 then
				for i = 1, #sEnts do
					local spawn = sEnts[i]
					if spawn.class then
						local ent = ents.Create(spawn.class)
						ent:SetPos(spawn.position)
						ent:GetAngles(spawn.angles)
						ent:Spawn()
						ent:Activate()
					end;
				end
		end;
end;

netstream.Hook('Banking::BankingAction', function(client, action, data)
		local act = PLUGIN.BankingActs[action];
		
		if act && data.id then
				act( client, data )
		end
end);

netstream.Hook('Banking::submit', function(client, data)
		local char = client:getChar();
		local check = char:getInv():getItemsOfType("check")
		if #check == 0 || !data then return end;

		local item = client:FindValidCheck(data.checkID);
		if item then
			if data.orderFor:len() == 0 then
						data.orderFor = "-----------------"
			end
			data.whoIs = client:GetName();
			data.accountNumber = client:GetHash();
			item:setData("check", data)
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

		BankingAccounts[ hash ] = {
				id = PLUGIN.bankID,
				name = name,
				money = 0,
				loan = 0,
				actualLoan = 0,
				bankeer = "NaN",
				invID = 0,
				interest = self.loanInterest[status] or 1,
				depinterest = self.depInterest[status] or 0,
				status = status,
		}
		self.bankID = self.bankID + 1;

		nut.inventory.instance("grid", {w = 10, h = 10})
		:next(function(inventory)
				inventory.id = inventory:getID();
				hook.Run("BankingAccess", inventory)
				local data = BankingAccounts[ hash ];
				data.invID = inventory.id
				BankingAccounts[ hash ] = data;
				
				inventory:sync(target)
		end);

		if self.depInterest[status] != 0 then
				PLUGIN.depositers[target:getChar()] = os.time() + 60 * BANKING_DEP_TIME;
		end;

		self:SyncBankingAccounts()
end;

function PLUGIN:DeleteBankingAccount(hash)
		if !self:CheckAcc(hash) then return end;

		BankingAccounts[hash] = nil;
		
		self:SyncBankingAccounts()
end;

function PLUGIN:UpdateBankingAccount(hash, data, value, target)
		if !self:CheckAcc(hash) then return end;

		BankingAccounts[hash][data] = value;
		
		self:SyncBankingAccounts()
end;

function PLUGIN:CheckAcc(hash)
		return BankingAccounts[hash]
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
timer.Create(uniqueID, 60, 0, function() // Timer checks every 5 minutes;
	if next(PLUGIN.depositers) == nil then return end;

	for char, stamp in pairs(PLUGIN.depositers) do
			if IsValid(char.player) && stamp < os.time() then
					local bank = char.player:HasBankingAccount()
					local status = PLUGIN.depInterest[bank.status] or 0;
					PLUGIN.depositers[char] = os.time() + 60 * BANKING_DEP_TIME;
					if status <= 0 then
							PLUGIN.depositers[char] = nil;
					end
					if status && status > 0 then PLUGIN:UpdateBankingAccount( char.player:GetHash(), "money", bank.money * (1 - (status/100)) ) end;
			end;
	end
end);

local uniqueID = 'LoanMultiplication'
timer.Create(uniqueID, 60, 0, function()
	if next(PLUGIN.loaners) == nil then return end;

	for char, stamp in pairs(PLUGIN.loaners) do
			if IsValid(char.player) && stamp < os.time() then
					local bank = char.player:HasBankingAccount()
					PLUGIN.loaners[char] = os.time() + 60 * BANKING_LOAN_TIME;
					if !char.player:HasLoan() then PLUGIN.loaners[char] = nil; end
					if char.player:HasLoan() then 
						PLUGIN:UpdateBankingAccount(
							char.player:GetHash(), 
							"loan", 
							math.Round(bank.loan * (1 + (bank.interest/100)))
						) 
					end;
			end;
	end
end);