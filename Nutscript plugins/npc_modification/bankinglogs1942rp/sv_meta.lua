local PLUGIN = PLUGIN;

local client = FindMetaTable("Player")

function client:SyncBankLogs()
		if self:getChar():hasFlags("B") then
			netstream.Start(self, 'Banking::SyncLogs', BANKING_LOGS.logs)
		end;
end;