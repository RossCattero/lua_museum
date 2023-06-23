local sw, sh = ScrW(), ScrH();

local PANEL = {}

function PANEL:Init()
    gui.EnableScreenClicker(true);

	self:Place(400, 600)

	self:SetFocusTopLevel( true )
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, .3, 0, function(alpha, pnl)
        pnl:SetAlpha(255)
    end);

	self.wrapper = self:Add("Panel")
	self.wrapper:Dock(FILL)
	self.wrapper:DockMargin(20, 10, 20, 0)

	self.BankName = self.wrapper:Add("DLabel")
	self.BankName:Dock(TOP)
	self.BankName:SetFont("BankingTitle")
	self.BankName:SetText(nut.banking.bankTitle)
	self.BankName:SetTall(sh * .03)
	self.BankName:SetContentAlignment(5)
	self.BankName:SetTextColor( Color(255, 255, 255) )
	self.BankName:SizeToContents()

	self.BankNameSmall = self.wrapper:Add("DLabel")
	self.BankNameSmall:Dock(TOP)
	self.BankNameSmall:SetFont("BankingTitleSmaller")
	self.BankNameSmall:SetText(nut.banking.bankSubTitle)
	self.BankNameSmall:SetContentAlignment(5)
	self.BankNameSmall:SetTextColor( Color(255, 255, 255) )
	self.BankNameSmall:DockMargin(0, 0, 0, 20)
	self.BankNameSmall:SizeToContents()

	self.body = self.wrapper:Add("Panel")
	self.body:Dock(FILL)
end

function PANEL:Paint(w, h)
	draw.RoundedBox(8, 0, 0, w, h, Color(50, 50, 50, 250))
end;

vgui.Register("BankingBaseUI", PANEL, "EditablePanel")