local bankingLog = nut.meta.bankingLog or {}

bankingLog.__index = bankingLog

bankingLog.text = "";
bankingLog.time = "";

function bankingLog:__tostring()
	return "Banking log"
end

nut.meta.bankingLog = bankingLog