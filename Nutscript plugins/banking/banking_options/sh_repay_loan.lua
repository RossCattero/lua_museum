bankingOption.position = 5;
bankingOption.name = "Repay loan"
bankingOption.icon = "icon16/coins.png"
bankingOption.Callback = function(button)
	local account = nut.banking.instances[ LocalPlayer():getChar():getID() ];
	
	if account.loan > 0 && LocalPlayer():getChar():getMoney() > 0 then
		Derma_StringRequest("Repay loan", "Type amount to repay(type 'all' to repay all possible amount):", "0.00", 
		function(stringText)
			local floatAmount = stringText == "all" && tonumber(account.loan) || tonumber(stringText);
			
			if floatAmount && LocalPlayer():getChar():hasMoney(math.Round(floatAmount)) then
				if account.loan > 0 then
					net.Start("nut.banking.option.repay")
						net.WriteFloat(math.Round(floatAmount))
					net.SendToServer()
				else
					nut.util.notify("You don't have any loans.");
				end;
			else
				nut.util.notify("You don't have enough money to do this.")
			end
		end);					
	end
end;
bankingOption.CanRun = function(button)
	local account = nut.banking.instances[ LocalPlayer():getChar():getID() ];

	return account.loan > 0 && LocalPlayer():getChar():getMoney() > 0;
end;
