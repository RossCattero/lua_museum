local bankingAccount = nut.meta.banking or {}

bankingAccount.__index = bankingAccount

bankingAccount.charID = 0;
bankingAccount.money = 0;
bankingAccount.loan = 0;
bankingAccount.actualLoan = 0;
bankingAccount.lastIncreaseDate = "";
bankingAccount.invID = 0;
bankingAccount.status = "regular";

function bankingAccount:__tostring()
	return "Banking account => ["..self:GetID().."]"
end

function bankingAccount:__eq( objectOther )
	return self:GetID() == objectOther:GetID()
end

function bankingAccount:GetID()
	return self.charID or 0
end

function bankingAccount:CanDeposit( amount )
	return tonumber(self.money + amount) < tonumber(self:GetStatus().maxDeposit);
end;

function bankingAccount:SetLoan( amount )
	local status = self:GetStatus();

	self.actualLoan = amount * status.loanInterest;
	self.loan = amount * status.loanInterest;

	return true;
end;

function bankingAccount:Deposit( floatAmount )
	self.money = self.money + floatAmount;
end;

function bankingAccount:Withdraw( floatAmount )
	self.money = self.money - floatAmount
end;

function bankingAccount:GetMaxLoan()
	return tonumber(self:GetStatus().maxLoan)
end;

function bankingAccount:GetStatus()
	return nut.banking.status.list[ self.status ];
end;

function bankingAccount:GetData()
	local data = util.TableToJSON( self )
	data = util.Compress( data )
	return data, #data;
end;

function bankingAccount:Sync( objectPlayer )
	local data, len = self:GetData();
	net.Start("nut.banking.account.sync")
		net.WriteUInt( len, 16 )
		net.WriteData( data, len )
	net.Send( objectPlayer )

	return true;
end;

nut.meta.banking = bankingAccount