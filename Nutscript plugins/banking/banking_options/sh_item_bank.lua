bankingOption.position = 6;
bankingOption.name = "Item bank"
bankingOption.icon = "icon16/box.png"
bankingOption.Callback = function(button)
	local account = nut.banking.instances[ LocalPlayer():getChar():getID() ];

	if nut.inventory.instances[tonumber(account.invID)] then
		_BankStorage(nut.inventory.instances[tonumber(account.invID)])
	end;
end;

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