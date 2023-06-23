nut.banking = nut.banking or {};
nut.banking.instances = nut.banking.instances or {};
nut.banking.funds = nut.banking.funds or 0;
nut.banking.entities = nut.banking.entities or {};

function nut.banking.New(id, data)
	local banking = setmetatable({}, nut.meta.banking)
		banking.charID = id or 0
		for k, v in pairs(data) do
			if v != nil then
				banking[ k ] = v;
			end;
		end;
	return banking
end

function nut.banking.Instance(id, data)
	if !data then data = {} end;
	data.money = data.money or 0;
	data.loan = data.loan or 0;
	data.actualLoan = data.actualLoan or 0;
	data.lastIncreaseDate = data.lastIncreaseDate or "";
	data.invID = data.invID or 0;
	data.status = data.status or "regular";
	
	nut.banking.instances[ id ] = nut.banking.New(id, data)
end;

function nut.banking.sendData( client, onSynchronized )
	for id, account in pairs( nut.banking.instances ) do
		account:Sync( client )
	end
	
	net.Start("nut.banking.funds.sync")
		net.WriteString(nut.banking.funds)
	net.Send(client)

	nut.banking.log.Sync( client );

	return onSynchronized && onSynchronized()
end;

function nut.banking.totalLoans()
	local loans = 0;

	for k, v in pairs( nut.banking.instances ) do
		loans = loans + v.loan;
	end

	return loans
end;

if CLIENT then
	nut.banking.bankTitle = "BANK OF THE REICH"
	nut.banking.bankSubTitle = "REICHBANK"
	nut.banking.checks = nut.banking.checks || {}
end;