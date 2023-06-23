bankingOption.position = 7;
bankingOption.name = "Exit"
bankingOption.icon = "icon16/delete.png"
bankingOption.clr = Color(172, 90, 90)
bankingOption.isExit = true;
bankingOption.Callback = function(button)
	if nut.banking.derma && nut.banking.derma:IsValid() then
		nut.banking.derma:Close()
	end
end;