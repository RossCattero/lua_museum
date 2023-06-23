bankingOption.position = 3;
bankingOption.name = "Deposit check"
bankingOption.icon = "icon16/page.png"
bankingOption.Callback = function(button)
	local menu = DermaMenu()
		for k, v in ipairs(LocalPlayer():getChar():getInv():getItemsOfType("check")) do
			if v:getData("submited") then
				menu:AddOption(Format("ID: %s, Amount: %s, to '%s'", v.id, v:getData("amount"), v:getData("nameReceiver")), 
				function() 
					Derma_Query("Do you want to deposit this check?", "Deposit check", "Yes", 
					function()
						net.Start("nut.banking.check.deposit")
							net.WriteString(v.id)
						net.SendToServer()
					end,
					"No", 
					function() end)
				end)
			end;
		end;
	menu:Open()
end;
bankingOption.CanRun = function(button)
	for num, itemData in ipairs(LocalPlayer():getChar():getInv():getItemsOfType("check")) do
		if itemData:getData("submited") then
			return true;
		end
	end
	return false;
end;
