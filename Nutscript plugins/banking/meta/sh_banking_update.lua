local bankingStatus = nut.meta.bankingStatus or {}

bankingStatus.__index = bankingStatus

bankingStatus.name = "None";
bankingStatus.maxDeposit = 0;
bankingStatus.storageW = 0;
bankingStatus.storageH = 0;
bankingStatus.loanInterest = 0;
bankingStatus.maxLoan = 0;
bankingStatus.accountInterest = 0;

function bankingStatus:__tostring()
	return Format("Account Type: %s;\nMax. deposit: %s;\nStorage width: %s;\nStorage height: %s;\nLoan interest: %s%s;\nMax. loan: %s;\nAccount interest: %s%s;",
	self.name, self.maxDeposit, self.storageW, self.storageH, self.loanInterest, "%", self.maxLoan, self.accountInterest, "%")
end

function bankingStatus:CanBeUpgraded( client ) 
	return false;
end;

function bankingStatus:OnUpgrade( client ) end;

if CLIENT then
	function bankingStatus:Requirements()
		return "Requirements are not provided.";
	end;
end

nut.meta.bankingStatus = bankingStatus