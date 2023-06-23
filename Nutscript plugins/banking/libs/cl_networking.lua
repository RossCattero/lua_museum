net.Receive("nut.banking.account.open", function(len)
	if nut.banking.derma && nut.banking.derma:IsValid() then
		nut.banking.derma:Close()
	end

	nut.banking.derma = vgui.Create("Banking")
	nut.banking.derma:Populate()
end)

net.Receive("nut.banking.account.create", function(len)
	if nut.banking.requestCD && nut.banking.requestCD > CurTime() then
		return;
	end
	Derma_Query("Hello. Seems like you don't have a banking account, do you want to open it now?", "Banking account", 
	"Yes, I do.", function()
		net.Start("nut.banking.account.create.agree")
		net.SendToServer()
	end,
	"No, I don't", function()
		nut.banking.requestCD = CurTime() + 4;
	end)
end)

net.Receive("nut.banking.account.sync", function(len)
	local len = net.ReadUInt( 16 )
	local data = net.ReadData( len )
	data = util.Decompress( data );
	data = util.JSONToTable(data);
	
	nut.banking.Instance(data.charID, data)

	if nut.banking.derma && nut.banking.derma:IsValid() then
		nut.banking.derma:Refresh()
	end
end)

net.Receive("nut.banking.check.open", function(len)
	local itemID = net.ReadString();
	if !nut.banking.checks[ itemID ] then
		nut.banking.checks[ itemID ] = {
			itemID = itemID,
			sender = net.ReadString(),
			amount = net.ReadString(),
			orderFor = net.ReadString(),
			nameReceiver = net.ReadString(),
			submited = net.ReadBool()
		}
	end;

	if nut.banking.derma && nut.banking.derma:IsValid() then
		nut.banking.derma:Close()
	end

	nut.banking.derma = vgui.Create("BankingCheck")
	nut.banking.derma:Populate(itemID)
end)

net.Receive("nut.banking.bankeer.open", function(len)
	if nut.banking.derma && nut.banking.derma:IsValid() then
		nut.banking.derma:Close()
	end

	nut.banking.derma = vgui.Create("BankingBankeer")
end)

net.Receive("nut.banking.funds.sync", function(len)
	nut.banking.funds = tonumber(net.ReadString())
end)

net.Receive("nut.banking.logs.sync", function(len)
	local len = net.ReadUInt( 16 )
	local data = net.ReadData( len )
	data = util.Decompress( data );

	nut.banking.log.list = util.JSONToTable(data)
end)