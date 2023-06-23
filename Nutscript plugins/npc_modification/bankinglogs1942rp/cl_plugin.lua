local PLUGIN = PLUGIN;

netstream.Hook('Banking::OpenLogs', function()
		if INT_LOGS && INT_LOGS:IsValid() then INT_LOGS:Close() end;
		
		INT_LOGS = vgui.Create('BankingLogs')
		INT_LOGS:Populate()
end);

netstream.Hook('Banking::SyncLogs', function(data)
		BANKING_LOGS.logs = data;
end);

// Фикс лоанов и депозитов(?)