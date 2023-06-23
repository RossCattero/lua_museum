bankingOption.position = 2;
bankingOption.name = "Withdraw"
bankingOption.icon = "icon16/money_delete.png"
bankingOption.Callback = function(button)
	local account = nut.banking.instances[ LocalPlayer():getChar():getID() ];
	if account.money > 0 then
		Derma_StringRequest("Withdraw money", "Type amount to withdraw(type 'all' to withdraw all):", "0.00", 
		function(stringText)
			local floatAmount = stringText == "all" && tonumber(account.money) || tonumber(math.Round(stringText, 2));
			
			if floatAmount && account.money >= floatAmount then
				net.Start("nut.banking.option.withdraw")
					net.WriteFloat(floatAmount)
				net.SendToServer()							
			else
				nut.util.notify("You don't have enough money on account to do this.")
			end
		end);
	end
end;
bankingOption.CanRun = function(button)
	local account = nut.banking.instances[ LocalPlayer():getChar():getID() ];

	return account.money > 0;
end;
