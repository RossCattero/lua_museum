local PLUGIN = PLUGIN;

HASH_MASSIVE = HASH_MASSIVE || {}
BANKING_INFORMATION = BANKING_INFORMATION || {}

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

netstream.Hook('Banking::SyncBankInfo', function(data)
		BANKING_INFORMATION = data;
end);

netstream.Hook('Banking::SyncBanking', function(banking, money)
			BankingAccounts = banking;
			PLUGIN.moneyFunds = money;
			HASH_MASSIVE = {}

			for k, v in pairs(banking) do
					HASH_MASSIVE[#HASH_MASSIVE + 1] = k;
			end
			
			if INT_BOOK && INT_BOOK:IsValid() then
					INT_BOOK:ReloadItems()
			end
end);

netstream.Hook('Banking::Check', function(check)
		CHECK = check;

		if INT_CHECK && INT_CHECK:IsValid() then
				INT_CHECK:Close();
		end
		INT_CHECK = vgui.Create("CheckPanel")
		INT_CHECK:Populate()
end);

netstream.Hook('Banking::OpenINV', function(id)
		if nut.inventory.instances[id] then
				_BankStorage(nut.inventory.instances[id])
		end;
end);

function _BankStorage(storage)
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