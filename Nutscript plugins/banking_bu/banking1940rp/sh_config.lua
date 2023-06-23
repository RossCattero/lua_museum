local PLUGIN = PLUGIN;

PLUGIN.bankingAccounts = PLUGIN.bankingAccounts || {}; 
PLUGIN.bankID = PLUGIN.bankID or 1;
PLUGIN.enums = {
		{id="id", name="ID"},
		{id="name", name="Customer name"},
		{id="money", name="Account money", tomoney=true},
		{id="loan", name="Taken loan", tomoney=true},
		{id="actualLoan", name="Started loan", tomoney=true},
		{id="bankeer", name="Who given loan"},
		{id="interest", name="Loan interest", percents=true},
		{id="status", name="Account status"},
		{id="depinterest", name="Deposit interest", percents=true},
}
PLUGIN.moneyFunds = PLUGIN.moneyFunds or 0;
PLUGIN.depositers = PLUGIN.depositers or {};
PLUGIN.loaners = PLUGIN.loaners or {};
// Don't touch anything above;

BANKING_BOOK_FLAG = "B"; // Flag for access to banking functions, books, etc.
BANKING_WRITER_FLAG = "N" // Flag for access to creating an accounts;
BANKING_DEP_TIME = 60; // Minutes amount for deposit;
BANKING_LOAN_TIME = 6; // Minutes amount for loan check time;

// v Banking flag( default: B )
nut.flag.add(BANKING_BOOK_FLAG, "Access to banking book", function(client, isGiven)
		client:ReceiveBankingData();
end) 
// v Banking writer flag ( default: N )
nut.flag.add(BANKING_WRITER_FLAG, "Access to creating a banking accounts")

// Banking statuses list;
PLUGIN.bankingStatuses = {
	"Default", "Premium"
}

// Loan interests for statuses(%);
PLUGIN.loanInterest = {
	["Default"] = 4.5,
	["Premium"] = 2.5
}

// Deposit interests for statuses(%);
PLUGIN.depInterest = {
	["Default"] = 0,
	["Premium"] = 5
}