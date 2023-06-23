nut.banking.log = nut.banking.log or {};
nut.banking.log.list = nut.banking.log.list or {}

function nut.banking.log.New(stringText, optionalTime)
	local bankingLog = setmetatable({}, nut.meta.bankingLog)

	if (bankingLog) then
		local bankingLog = setmetatable(
		{
			text = stringText or "",
			time = optionalTime || os.time()
		}, 
		{
			__index = bankingLog,
			__eq = bankingLog.__eq,
			__tostring = bankingLog.__tostring
		})

		return bankingLog
	end
end;

function nut.banking.log.Instance(stringText, optionalTime)
	local log = nut.banking.log.New( stringText, optionalTime )
	table.insert(nut.banking.log.list, log);
end;

function nut.banking.log.Sync( objectPlayer )
	local data = util.TableToJSON( nut.banking.log.list )
	data = util.Compress( data )

	net.Start("nut.banking.logs.sync")
		net.WriteUInt( #data, 16 )
		net.WriteData( data, #data )
	net.Send(objectPlayer)
end;