bankingOption.position = 1;
bankingOption.name = "Deposit"
bankingOption.icon = "icon16/money_add.png"
bankingOption.Callback = function(button)
	local account = nut.banking.instances[ LocalPlayer():getChar():getID() ];
				
	if LocalPlayer():getChar():getMoney() > 0 then
		Derma_StringRequest("Deposit money", "Type amount to deposit:", "0.00", 
		function(stringText)
			local floatAmount = tonumber(stringText);
			
			if floatAmount && floatAmount > 0 && LocalPlayer():getChar():hasMoney(math.Round(floatAmount)) then
				net.Start("nut.banking.option.deposit")
					net.WriteFloat(math.Round(floatAmount))
				net.SendToServer()
			else
				nut.util.notify("You don't have enough money to do this.")
			end
		end);
	end	
end;
bankingOption.CanRun = function(button)
	return LocalPlayer():getChar():getMoney() > 0;
end;
