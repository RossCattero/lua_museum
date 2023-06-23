bankingStatus.name = "Government";
bankingStatus.maxDeposit = 200000;
bankingStatus.storageW = 6;
bankingStatus.storageH = 12;
bankingStatus.loanInterest = 2.5;
bankingStatus.maxLoan = 50000;
bankingStatus.accountInterest = 1.2;

function bankingStatus:CanBeUpgraded( client )
	local account = nut.banking.instances[ client:getChar():getID() ];
	return client:getChar():getMoney() >= 5000 && account.loan == 0 && account.status != "premium"
	&& (client:hasWhitelist( FACTION_ssa ) || client:hasWhitelist( FACTION_NSDAP ))
end;

function bankingStatus:OnUpgrade(client)
	client:getChar():takeMoney( 5000 );
end;

if CLIENT then
	function bankingStatus:Requirements()
		return "* Money amount: 5000;\n* No debts;\n* Don't have status 'Premium'.\n* Being in 'SS' or 'NSDAP'.";
	end;
end
