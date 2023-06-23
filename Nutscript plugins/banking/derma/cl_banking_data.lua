local PANEL = {}

function PANEL:Init()
	self:DockPadding(0, 10, 0, 0)
	
	self.title = self:Add("DLabel")
	self.title:Dock(TOP)
	self.title:SetFont("BankingDataLabel")
	self.title:SetText("NO TITLE")
	self.title:SetContentAlignment(5)
	self.title:SetTextColor( Color(225, 225, 225) )
	self.title:SetAutoStretchVertical(true)
	self.title:SizeToContents()	

	self.body = self:Add("Panel")
	self.body:Dock(FILL)
end

function PANEL:SetTitle(stringTitle)
	self.title:SetText( tostring(stringTitle) )
end;

function PANEL:Paint(w, h)
	draw.RoundedBox(8, 0, 0, w, h, nut.config.get("color"))
end;

vgui.Register("BankingData", PANEL, "EditablePanel")

local PANEL = {}

function PANEL:Init()
	self.money = self:Add("DLabel")
	self.money:Dock(TOP)
	self.money:SetFont("BankingDataMoney")
	self.money:SetContentAlignment(5)
	self.money:SetTextColor( Color(255, 255, 255) )
	self.money:DockMargin(0, 18, 0, 0)

	self.bottomPanel = self:Add("Panel")
	self.bottomPanel:Dock(FILL)	
	self.bottomPanel:DockPadding(10, 0, 10, 10)
	self.bottomPanel.nutToolTip = true

	self.status = self.bottomPanel:Add("DLabel")
	self.status:Dock(LEFT)
	self.status:SetFont("BankingDataLabelSmaller")
	self.status:SetText("")
	self.status:SetContentAlignment(2)
	self.status:SetTextColor( Color(200, 200, 200) )

	self.loan = self.bottomPanel:Add("DLabel")
	self.loan:Dock(RIGHT)
	self.loan:SetFont("BankingDataLabelSmaller")
	self.loan:SetText("")
	self.loan:SetContentAlignment(2)
	self.loan:SetTextColor( Color(200, 200, 200) )
end

function PANEL:Populate()
	local bankingAccount = nut.banking.instances[ LocalPlayer():getChar():getID() ];
	local status = nut.banking.status.list[string.lower(bankingAccount.status)]

	self.money:SetText(Format("%s%s", math.Round(bankingAccount.money, 2), nut.currency.symbol))
	self.money:SizeToContents()
	self.status:SetText(Format("Type: %s", status.name))	
	self.status:SizeToContents()
	self.loan:SetText(Format("Loan: %s%s(%s%s)", bankingAccount.loan, nut.currency.symbol, status.loanInterest, "%"))
	self.loan:SizeToContents()

	self.bottomPanel:SetTooltip("<font=BankingTitleSmaller>"..tostring(status).."</font>")
end;

vgui.Register("BankingData__Account", PANEL, "BankingData")