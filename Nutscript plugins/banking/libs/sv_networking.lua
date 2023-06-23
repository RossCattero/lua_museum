local f = Format

// Account
util.AddNetworkString("nut.banking.account.open")
util.AddNetworkString("nut.banking.account.create")
util.AddNetworkString("nut.banking.account.create.agree")
util.AddNetworkString("nut.banking.account.sync")
util.AddNetworkString("nut.banking.account.status")
// Check
util.AddNetworkString("nut.banking.check.open")
util.AddNetworkString("nut.banking.check.submit")
util.AddNetworkString("nut.banking.check.deposit")
// Banking money options;
util.AddNetworkString("nut.banking.option.deposit")
util.AddNetworkString("nut.banking.option.withdraw")
util.AddNetworkString("nut.banking.option.repay")
util.AddNetworkString("nut.banking.option.setLoan")
// Bankeer
util.AddNetworkString("nut.banking.bankeer.open")
util.AddNetworkString("nut.banking.bankeer.syncRequest")
// Funds
util.AddNetworkString("nut.banking.funds.sync")
// Logs
util.AddNetworkString("nut.banking.logs.sync")

net.Receive("nut.banking.account.create.agree", function(len, client)
	local charID = client:getChar():getID();
	local account = nut.banking.instances[ charID ];
	local regStatus = nut.banking.status.list[ "regular" ]

	if !account then
		nut.banking.Instance( charID );
		
		nut.inventory.instance("grid", {w = regStatus.storageW, h = regStatus.storageH})
		:next(function(inventory)
			inventory.id = inventory:getID();
			hook.Run("BankingAccess", inventory)
			nut.banking.instances[ charID ].invID = inventory.id;			
			inventory:sync( client )

			nut.banking.instances[ charID ]:Sync( client )
		end);
		
		nut.banking.log.Instance( f("Account #%s is opened", charID) )
		client:notify("Your banking account is successfully created!")
	end
end)

net.Receive("nut.banking.option.deposit", function(len, client)
	local charID = client:getChar():getID();
	local account = nut.banking.instances[ charID ];
	local floatAmount = net.ReadFloat();

	if floatAmount > 0 && client:getChar():hasMoney(floatAmount) && account:CanDeposit(floatAmount) then
		client:getChar():takeMoney(floatAmount)
		account:Deposit(floatAmount)
		account:Sync( client )

		nut.banking.log.Instance( f("Account #%s deposited %s", charID, floatAmount) )
		client:notify(f("You've sucessfully deposited %s%s to your bank account.", floatAmount, nut.currency.symbol))
	else
		client:notify("You can't to the deposit.")
	end
end)

net.Receive("nut.banking.option.withdraw", function(len, client)
	local charID = client:getChar():getID();
	local account = nut.banking.instances[ charID ];
	local floatAmount = math.Round(net.ReadFloat(), 2);

	if floatAmount > 0 && account.money > 0 && account.money >= floatAmount then
		account:Withdraw(floatAmount)
		client:getChar():giveMoney(floatAmount)
		account:Sync( client )

		nut.banking.log.Instance( f("Account #%s withdrawed %s", charID, floatAmount) )
		client:notify(f("You've sucessfully withdrawed %s%s from your bank account.", floatAmount, nut.currency.symbol))
	else
		client:notify("You can't withdraw this amount of money.")
	end
end)

net.Receive("nut.banking.option.repay", function(len, client)
	local charID = client:getChar():getID();
	local account = nut.banking.instances[ charID ];
	local floatAmount = math.Round(net.ReadFloat());

	if floatAmount && account.loan > 0 && client:getChar():hasMoney(floatAmount) then
		if account.loan - floatAmount < 0 then floatAmount = account.loan end
		account.loan = account.loan - floatAmount;
		client:addMoney(-floatAmount)
		nut.banking.funds = nut.banking.funds + floatAmount;
		if account.loan > 0 then
			nut.banking.log.Instance( f("Account #%s paid off debt %s / %s", charID, account.actualLoan - account.loan, account.actualLoan) )
			client:notify("You paid off " .. account.actualLoan - account.loan .. " / " .. account.actualLoan )			
		else
			account.actualLoan = 0;
			nut.banking.log.Instance(f("Account %s paid off debt", charID))
			client:notify("You don't have any loans now.")
		end;
		account:Sync( client )
	end
end)

net.Receive("nut.banking.check.submit", function(len, client)
	local itemID = net.ReadString();

	for k, check in pairs(client:getChar():getInv():getItemsOfType("check")) do
		if tostring(check.id) == itemID then
			if check.submited then
				return;
			end
			local amount = net.ReadString();
			local orderFor = net.ReadString();
			local receiverName = net.ReadString();

			local charID = client:getChar():getID();
			local account = nut.banking.instances[ charID ];

			check:setData("amount", tonumber(amount) or 0)
			check:setData("nameReceiver", string.Trim(receiverName) == "" && "Unknown" or receiverName)
			check:setData("orderFor", string.Trim(orderFor) == "" && "Null" or orderFor)			
			check:setData("accountSender", charID)
			check:setData("submited", true)

			client:notify("You've successfully submited the check.")
			return;
		end
	end

	client:notify("Can't find the valid check to submit.")
end)

net.Receive("nut.banking.check.deposit", function(len, client)
	local itemID = net.ReadString();
	local char = client:getChar()

	for k, check in pairs(client:getChar():getInv():getItemsOfType("check")) do
		if tostring(check.id) == itemID && check:getData("submited") then
			local sender = check:getData("accountSender");
			local ownerAccount = sender && nut.banking.instances[ tostring(sender) ]		
			if sender == "Government" || ownerAccount then
				local amount = math.Round(check:getData("amount"));
				if sender != "Government" then
					if ownerAccount.money >= amount then
						char:getInv():removeItem(check.id, true)
						ownerAccount:Withdraw(amount)
						char:giveMoney( amount );
						client:notify("You deposited the check.")
						nut.banking.log.Instance( f("Account #%s deposited check of amount %s from account #%s", client:getChar():getID(), amount, ownerAccount.charID ))
					else
						client:notify("This check's account don't have this amount of money.")
					end
				else
					char:getInv():removeItem(check.id, true)					
					char:giveMoney( amount );
					client:notify("You deposited the check.")
					nut.banking.log.Instance( f("Account #%s received amount %s from Government.", client:getChar():getID(), amount ))
				end;
			else
				client:notify("This check's account owner is not exists.")
			end
			return;
		end
	end

	client:notify("Can't find the valid check to submit.")
end)

net.Receive("nut.banking.account.status", function(len, client)
	local stringStatus = net.ReadString();
	local nextStatus = nut.banking.status.list[ stringStatus ]

	if nextStatus then
		local charID = client:getChar():getID()
		local account = nut.banking.instances[ charID ];
		if account && nextStatus:CanBeUpgraded( client ) then
			if nextStatus.OnUpgrade then
				nextStatus:OnUpgrade( client )
			end;
			
			local oldStatus = account:GetStatus()
			if oldStatus.storageW < nextStatus.storageW 
			or oldStatus.storageH < nextStatus.storageH then
				nut.inventory.instance("grid", {id = account.invID, w = nextStatus.storageW, h = nextStatus.storageH})
				:next(function(inventory)
					inventory.id = account.invID;
					hook.Run("BankingAccess", inventory)
					nut.banking.instances[ charID ].invID = inventory.id;			
					inventory:sync( client )

					nut.banking.instances[ charID ].status = stringStatus;
					account:Sync( client )
				end);
			else
				nut.banking.instances[ charID ].status = stringStatus;
				account:Sync( client )
			end
			nut.banking.log.Instance( f("Account #%s changed account status to '%s'", charID, stringStatus ))
			client:notify(f("You changed your account status to %s.", stringStatus))
		else
			client:notify("Your account status can't be changed.")
		end
	end
end)

net.Receive("nut.banking.option.setLoan", function(len, client)
	local charID = net.ReadString()
	local loanAmount = net.ReadFloat();
	local bankeerFlag = client:getChar():hasFlags("B");
	local account = nut.banking.instances[ tonumber(charID) ];
	
	if bankeerFlag then
		if nut.banking.funds < 0 || nut.banking.funds - loanAmount < 0 then
			client:notify("You can't give a loan to this character because of funds amount.")
			return;
		end;

		if loanAmount <= 0 then
			nut.banking.log.Instance( f("Account's #%s loan in amount of %s has been removed.", charID, account.loan, stringStatus ))
			account.actualLoan = 0;
			account.loan = 0;
			client:notify("You've removed the loan of this account.")
		elseif loanAmount > 0 then
			local status = account:GetStatus();
			if status.maxLoan > loanAmount then
				if account:SetLoan( loanAmount ) then
					account:Deposit(loanAmount)
					nut.banking.funds = nut.banking.funds - loanAmount;
				end;
				nut.banking.log.Instance(f("Account #%s received the loan in amount of %s.", charID, loanAmount))
				client:notify(f("You've set the loan in amount of %s(%s%s) to account %s",
				loanAmount * status.loanInterest, status.loanInterest, "%", charID))
			else
				client:notify("You can't give loan to this account because value is too high for it's status.")	
			end
		end
		nut.banking.sendData( client );
	else
		client:notify("You don't have permission to do this.")
	end
end)

net.Receive('nut.banking.bankeer.syncRequest', function(len, client)
	if client:getChar():hasFlags("B") then
		nut.banking.sendData(client)
	end
end);

netstream.Hook("nut.banking.useBankeer", function(client)
	local data = {}
		data.start = client:GetShootPos()
		data.endpos = data.start + client:GetAimVector()*96
		data.filter = client
	local trace = util.TraceLine(data)
	local entity = trace.Entity;

	if entity && entity:IsValid() && entity:GetClass() == "banking_npc" then
		entity:UseProxy( client )
	end
end)