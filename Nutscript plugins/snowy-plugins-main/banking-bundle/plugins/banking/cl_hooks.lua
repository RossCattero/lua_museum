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

function PLUGIN:BankStorage(storage)
		-- Number of pixels between the local inventory and storage inventory.
		local PADDING = 4

		if !storage then return end

		-- Get the inventory for the player and storage.
		local localInv = LocalPlayer():getChar() and LocalPlayer():getChar():getInv()
		if (!localInv) then
			return
		end

		-- Show both the storage and inventory.
		local localInvPanel = nut.inventory.show(localInv)
		local storageInvPanel = nut.inventory.show(storage)
		storageInvPanel:SetTitle("Local storage")

		-- Allow the inventory panels to close.
		localInvPanel:ShowCloseButton(true)
		storageInvPanel:ShowCloseButton(true)

		-- Put the two panels, side by side, in the middle.
		local extraWidth = (storageInvPanel:GetWide() + PADDING) / 2
		localInvPanel:Center()
		storageInvPanel:Center()
		localInvPanel.x = localInvPanel.x + extraWidth
		storageInvPanel:MoveLeftOf(localInvPanel, PADDING)

		-- Signal that the user left the inventory if either closes.
		local firstToRemove = true
		localInvPanel.oldOnRemove = localInvPanel.OnRemove
		storageInvPanel.oldOnRemove = storageInvPanel.OnRemove

		local function exitStorageOnRemove(panel)
			if (firstToRemove) then
				firstToRemove = false
				nutStorageBase:exitStorage()
				local otherPanel =
					panel == localInvPanel and storageInvPanel or localInvPanel
				if (IsValid(otherPanel)) then otherPanel:Remove() end
			end
			panel:oldOnRemove()
		end

		hook.Run("OnCreateStoragePanel", localInvPanel, storageInvPanel, storage)

		localInvPanel.OnRemove = exitStorageOnRemove
		storageInvPanel.OnRemove = exitStorageOnRemove
	end