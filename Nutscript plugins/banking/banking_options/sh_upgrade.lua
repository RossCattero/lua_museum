bankingOption.position = 4;
bankingOption.name = "Upgrade"
bankingOption.icon = "icon16/ruby.png"
bankingOption.Callback = function(button)
	local account = nut.banking.instances[ LocalPlayer():getChar():getID() ]
	local menu = DermaMenu()		
		for k, v in pairs( nut.banking.status.list ) do
			if account.status != k && !v.basic then
				local option = menu:AddOption(Format("Upgrade to '%s' account", v.name), 
				function()
					if v:CanBeUpgraded( LocalPlayer() ) then
						net.Start("nut.banking.account.status")
							net.WriteString( k );
						net.SendToServer();
					else
						Derma_Message("You don't meet all requirements.", "Message", "OK")	
					end
				end)

				option.nutToolTip = true;
				foundAcc = true;
				option:SetTooltip(Format("<font=BankingTitleSmaller>Requirements:\n%s</font>", v.Requirements && v:Requirements()))
			end;
		end
	menu:Open()
end;
bankingOption.CanRun = function(button)
	for num, data in pairs(nut.banking.status.list) do
		if data:CanBeUpgraded( LocalPlayer() ) then
			return true;
		end
	end
	return false;
end;
