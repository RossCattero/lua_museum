local PLUGIN = PLUGIN;

HASH_MASSIVE = HASH_MASSIVE || {}

netstream.Hook('Banking::OpenBook', function()
		if INT_BOOK && INT_BOOK:IsValid() then INT_BOOK:Close() end;

		INT_BOOK = vgui.Create('BankingBook')
		INT_BOOK:Populate()
end);

netstream.Hook('Banking::OpenWriter', function()
		if INT_TW && INT_TW:IsValid() then INT_TW:Close() end;

		INT_TW = vgui.Create('TypeWriter')
		INT_TW:Populate()
end);

netstream.Hook('Banking::SyncBanking', function(banking, money)
			PLUGIN.bankingAccounts = banking;
			PLUGIN.moneyFunds = money;
			HASH_MASSIVE = {}

			for k, v in pairs(banking) do
					HASH_MASSIVE[#HASH_MASSIVE + 1] = k;
			end
			
			if INT_BOOK && INT_BOOK:IsValid() then
					INT_BOOK:ReloadItems()
			end
end);