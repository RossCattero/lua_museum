local PLUGIN = PLUGIN;
PLUGIN.bankINFO = PLUGIN.bankINFO or {}
Answers = Answers or {}

netstream.Hook('Bank::StartTalk', function()
		if PLUGIN.interface && PLUGIN.interface:IsValid() then
				PLUGIN.interface:Close();
		end
		PLUGIN.interface = vgui.Create("Talking")
		PLUGIN.interface:Populate()
end);

netstream.Hook('bank::showCheck', function(check)
		checkItem = pon.decode(check)

		if PLUGIN.interface && PLUGIN.interface:IsValid() then
				PLUGIN.interface:Close();
		end
		PLUGIN.interface = vgui.Create("CheckPanel")
		PLUGIN.interface:Populate()
end);

netstream.Hook('Bank::OpenATM', function()
		if PLUGIN.atm && PLUGIN.atm:IsValid() then
				PLUGIN.atm:Close();
		end
		PLUGIN.atm = vgui.Create("ATMUI")
		PLUGIN.atm:Populate()
end);

netstream.Hook('bank::sendAccInfo', function(data)
		PLUGIN.bankINFO = pon.decode(data);
		if PLUGIN.atm && PLUGIN.atm:IsValid() then
				PLUGIN.atm.MoneyAmount:SetText("Money: " .. PLUGIN.bankINFO["money"] .. nut.currency.symbol)
				PLUGIN.atm.Loan:SetText("Loan: " .. PLUGIN.bankINFO["loan"] .. nut.currency.symbol)
		end
end);

netstream.Hook('bank::openBanking', function(data)
		data = pon.decode(data)

		PLUGIN.accsList = data[1];
		PLUGIN.fund = data[2]

		if PLUGIN.dbOpened && PLUGIN.dbOpened:IsValid() then
				PLUGIN.dbOpened:Close()
		end

		PLUGIN.dbOpened = vgui.Create("Bank_Database")
		PLUGIN.dbOpened:Populate()
end);

netstream.Hook('bank::openCollector', function(id)
		if nut.inventory.instances[id] then
				PLUGIN:BankStorage(nut.inventory.instances[id])
		end;
end);

netstream.Hook('bank::hackVault', function(data, scenario, timeLeft, fund)
		SCENARIO = PLUGIN.vaultScenario[scenario]
		if !SCENARIO then return end;
		
		DIFF = pon.decode(data);
		DIFF["stack"] 		= pon.decode(DIFF["stack"])
		DIFF["positions"] = pon.decode(DIFF["positions"])
		PASSWD = "";
		FUND = fund;
		ATTEMPTS = SCENARIO.ATTEMPTS

		if PLUGIN.vaultInterface && PLUGIN.vaultInterface:IsValid() then
				PLUGIN.vaultInterface:Close()
		end

		PLUGIN.vaultInterface = vgui.Create("Mini_game_SW")
		PLUGIN.vaultInterface:Populate()

		timer.Create("LocalVaultTimer", 1, timeLeft, function()
				if !PLUGIN.vaultInterface || !PLUGIN.vaultInterface:IsValid() then
						timer.Remove("LocalVaultTimer")
						return; 
				end

				if PLUGIN.vaultInterface:IsValid() then
						local time = timer.RepsLeft("LocalVaultTimer");
						if time > 60 then
							local lTime = math.floor(time / 60);
							if lTime > 9 then
								formatTime = math.floor(time / 60) .. ":"
							else
								formatTime = "0" .. math.floor(time / 60) .. ":"
							end;
							if time % 60 < 10 then
								formatTime = formatTime .. "0" .. time % 60
							else
								formatTime = formatTime .. time % 60
							end
						else
							formatTime = "00:" .. time
						end
						PLUGIN.vaultInterface.time:SetText(formatTime)
						if time <= 0 then
								PLUGIN.vaultInterface:Close()
						end
				end
		end)
end);

netstream.Hook('bank::CloseVaultClientside', function()
		if PLUGIN.vaultInterface && PLUGIN.vaultInterface:IsValid() then
				PLUGIN.vaultInterface:Close()
		end
end);

netstream.Hook('bank::SyncAttempts', function(atts)
		if PLUGIN.vaultInterface && PLUGIN.vaultInterface:IsValid() then
				PLUGIN.vaultInterface.att:SetText("Attempts: " .. math.max(atts, 0) .. "/" .. SCENARIO.ATTEMPTS)
				if atts <= 0 then
						PLUGIN.vaultInterface:Close()
				end
		end
end);

netstream.Hook('bank::OpenLogsList', function(data)
		if PLUGIN.bankingLogs && PLUGIN.bankingLogs:IsValid() then
				PLUGIN.bankingLogs:Close()
		end

		BankingLogs = pon.decode(data)
		
		PLUGIN.bankingLogs = vgui.Create("Banking_logs")
		PLUGIN.bankingLogs:Populate()
end);