local PLUGIN = PLUGIN;
local f = Format

function PLUGIN:PlayerLoadedChar(client, character, prev)		
	local account = nut.banking.instances[ charID ];

	timer.Simple(.25, function()
		if account && account.invID != 0 then
			nut.inventory.loadByID(account.invID)
			:next(function(inventory) 				
				hook.Run("BankingAccess", inventory)
				inventory:sync(client)
			end)
		end;
	end);
end;

function PLUGIN:OnCharacterDelete(client, id)
	if nut.banking.instances[ id ] then
		nut.banking.instances[ id ] = nil;
		nut.banking.log.Instance( f("Account #%s is deleted.", id) )
	end;
end;

function PLUGIN:SaveData()
	nut.data.set("bankingFunds", nut.banking.funds);
	nut.data.set("bankingLogs", nut.banking.log.list)

	for accID, accData in pairs( nut.banking.instances ) do
		query = mysql:Delete("nut_banking")
			query:Where("uniqueID", accID)
		query:Execute()

		query = mysql:Insert("nut_banking")
			query:Insert("uniqueID", accID)
			query:Insert("data", util.TableToJSON(accData))
		query:Execute()
	end;
end;

function PLUGIN:LoadData()
	nut.banking.funds = nut.data.get("bankingFunds", 0)
	nut.banking.log.list = nut.data.get("bankingLogs", {})

	local query = mysql:Create("nut_banking")
		query:Create("uniqueID", "VARCHAR(255) NOT NULL")		
		query:Create("data", "TEXT NOT NULL")
		query:PrimaryKey("uniqueID")
	query:Execute()

	local query = mysql:Select("nut_banking")
		query:Select("uniqueID")
		query:Select("data")

		query:Callback(function(result)
			if result then
				for k, v in pairs(result) do
					nut.banking.Instance(tonumber( v.uniqueID ), util.JSONToTable(v.data))
				end
			end;
		end);
	query:Execute()
end;

timer.Create("DepositIncrease", 60 * 60, 0, function()
	for k, client in ipairs( player.GetAll() ) do
		local char = client:getChar();
		if char then
			local account = nut.banking.instances[ char:getID() ]

			if account && account.money > 0 && account:GetStatus().accountInterest > 0 then
				local newAmount = math.Round(account.money * account:GetStatus().accountInterest, 2)
				nut.banking.log.Instance(f("Account #%s received the deposit interest in amount of %s.", charID, newAmount - account.money))
				account.money = newAmount
				account:Sync(client)
				client:notify("You've received a deposit increase for your account.")
			end
		end;
	end
end)

timer.Create("LoanIncrease", 60 * 30, 0, function()
	for bankingID, account in pairs( nut.banking.instances ) do
		if account.loan > 0 && account.actualLoan > 0 then
			if account.lastIncreaseDate == "" then
				account.lastIncreaseDate = os.time();
			elseif os.time() >= account.lastIncreaseDate + ( 60 * 60 * 24 ) then
				account.lastIncreaseDate = os.time();
				account.loan = account.loan + ( account.actualLoan * account:GetStatus().loanInterest )
				nut.banking.log.Instance(f("Account #%s received the loan interest. New loan amount: %s.", charID, account.loan))
			end
		end
	end
end)