local sw, sh = ScrW(), ScrH()

local PANEL = {}

function PANEL:Init()
	gui.EnableScreenClicker(true);

	self:Place(600, 210)

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
	self.BankNameSmall:DockMargin(0, 0, 0, sh * 0.005)
	self.BankNameSmall:SizeToContents()

	self.body = self.wrapper:Add("Panel")
	self.body:Dock(FILL)
end

function PANEL:Populate(itemID)
	local check = nut.banking.checks[ tostring(itemID) ];
	if !check then
		ErrorNoHalt("Can't display check!")
		self:Close();
		return;
	end
	self.id = self.body:Add("DLabel")
	self.id:Dock(TOP)
	self.id:SetFont("BankingButtons")
	self.id:SetText(Format("ID: %s", check.itemID))
	self.id:SizeToContents()
	self.id:DockMargin(10, 0, 10, 0)

	if !check.submited then
		self.amount = self.body:Add("BankTextEntry")
		self.amount:Dock(TOP)
		self.amount:SetLabel("Amount:")
		self.amount.entry:SetPlaceholderText("Type number amount. Don't type letters here or check wont be succeed in bank.")
		self.amount.entry:SetValue(check.amount == "0" && "" || check.amount)
		
		self.orderFor = self.body:Add("BankTextEntry")
		self.orderFor:Dock(TOP)
		self.orderFor:SetLabel("Payment order:")
		self.orderFor.entry:SetPlaceholderText("Type any payment order")
		self.orderFor.entry:SetValue(check.orderFor == "" && "" || check.orderFor)

		self.nameReceiver = self.body:Add("BankTextEntry")
		self.nameReceiver:Dock(TOP)
		self.nameReceiver:SetLabel("Receiver name:")
		self.nameReceiver.entry:SetPlaceholderText("Type any receiver name here")
		self.nameReceiver.entry:SetValue(check.nameReceiver == "" && "" || check.nameReceiver)

		self.receiverFrom = self.body:Add("DLabel")
		self.receiverFrom:Dock(TOP)
		self.receiverFrom:SetFont("BankingButtons")
		self.receiverFrom:SetText(Format("Received from: %s", LocalPlayer():GetName()))
		self.receiverFrom:SizeToContents()
		self.receiverFrom:DockMargin(10, 0, 10, 0)
	else
		self.amount = self.body:Add("DLabel")
		self.amount:Dock(TOP)
		self.amount:SetFont("BankingButtons")
		self.amount:SetText(Format("Amount: %s%s", check.amount, nut.currency.symbol))
		self.amount:SizeToContents()
		self.amount:DockMargin(10, 0, 10, 0)

		self.orderFor = self.body:Add("DLabel")
		self.orderFor:Dock(TOP)
		self.orderFor:SetFont("BankingButtons")
		self.orderFor:SetText(Format("Payment order: %s", check.orderFor))
		self.orderFor:SizeToContents()
		self.orderFor:DockMargin(10, 0, 10, 0)

		self.nameReceiver = self.body:Add("DLabel")
		self.nameReceiver:Dock(TOP)
		self.nameReceiver:SetFont("BankingButtons")
		self.nameReceiver:SetText(Format("Receiver name: %s", check.nameReceiver))
		self.nameReceiver:SizeToContents()
		self.nameReceiver:DockMargin(10, 0, 10, 0)

		self.receiverFrom = self.body:Add("DLabel")
		self.receiverFrom:Dock(TOP)
		self.receiverFrom:SetFont("BankingButtons")
		self.receiverFrom:SetText(Format("Received from(ID): %s", check.sender))
		self.receiverFrom:SizeToContents()
		self.receiverFrom:DockMargin(10, 0, 10, 0)
	end;

	self.buttons = self.body:Add("Panel")
	self.buttons:Dock(TOP)
	self.buttons:DockMargin(0, 0, 0, sh * 0.02)
	self.buttons:DockPadding(200, 0, check.submited && 250 || 200, 0)

	if !check.submited then
		self.submit = self.buttons:Add("BankingButton")
		self.submit:SetText("Submit")
		self.submit:Dock(LEFT)
		self.submit.DoClick = function(btn)
			if self.amount.entry:GetValue() == "" || tonumber(self.amount.entry:GetValue()) == 0 then
				nut.util.notify("You need to type amount!")
				return;
			end

			if !check.submited then
				net.Start("nut.banking.check.submit")
					net.WriteString( check.itemID )
					net.WriteString( self.amount.entry:GetValue() )
					net.WriteString( self.orderFor.entry:GetText() )
					net.WriteString( self.nameReceiver.entry:GetText() )					
				net.SendToServer()

				nut.banking.checks[ itemID ] = nil;
				self:Close()
			end;
		end;		
	end
	self.exit = self.buttons:Add("BankingButton")
	self.exit:SetText("Exit")
	self.exit:Dock(RIGHT)
	self.exit.DoClick = function(btn)
		if !check.submited then
			nut.banking.checks[ itemID ] = {
				itemID = itemID,
				sender = check.sender,
				amount = tostring(self.amount.entry:GetText()),
				orderFor = self.orderFor.entry:GetText(),
				nameReceiver = self.nameReceiver.entry:GetText(),
				submited = false
			}
		end
		self:Close()
	end;

	self:InvalidateLayout( true )
	self:SizeToChildren( false, true )
end;

function PANEL:Paint(w, h)
	draw.RoundedBox(8, 0, 0, w, h, Color(50, 50, 50, 250))
end;

vgui.Register("BankingCheck", PANEL, "EditablePanel")