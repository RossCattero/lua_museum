bankingStatus.name = "Premium";
bankingStatus.maxDeposit = 1000000;
bankingStatus.storageW = 9;
bankingStatus.storageH = 14;
bankingStatus.loanInterest = 1.5;
bankingStatus.maxLoan = 100000;
bankingStatus.accountInterest = 1.2;

function bankingStatus:CanBeUpgraded( client )
	local account = nut.banking.instances[ client:getChar():getID() ];
	return client:getChar():getMoney() >= 10000 && account.loan == 0;
end;

function bankingStatus:OnUpgrade(client)
	client:getChar():takeMoney( 10000 );
end;

if CLIENT then
	function bankingStatus:Requirements()
		return "* Money amount: 10000;\n* No debts;";
	end;
end
