local sw, sh = ScrW(), ScrH()
local PANEL = {}

function PANEL:Init()
	gui.EnableScreenClicker(true);

	self:Place(1000, 600)

	self:SetFocusTopLevel( true )
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, .3, 0, function(alpha, pnl)
        pnl:SetAlpha(255)
    end);

	self.header = self:Add("DPanel")
	self.header:Dock(TOP)
	self.header:SetTall( sh * 0.035 )
	self.header:DockPadding(10, 5, 10, 5)
	self.header.Paint = function(s, w, h)
		draw.RoundedBoxEx(8, 0, 0, w, h, nut.config.get("color"), true, true, false, false)
	end;

	self.fundsTotal = self.header:Add("DLabel")
	self.fundsTotal:Dock(FILL)
	self.fundsTotal:SetFont("BankingTitleSmaller")
	self.fundsTotal:SetText("")
	self.fundsTotal:SetContentAlignment(5)
	self.fundsTotal:SetTextColor( Color(255, 255, 255) )
	self.fundsTotal:SizeToContents()
	
	self.body = self:Add("Panel")
	self.body:Dock(FILL)

	self.accountsListBG = self.body:Add("Panel")
	self.accountsListBG:Dock(LEFT)
	self.accountsListBG:SetWide(sw * 0.25)

	self.search = self.accountsListBG:Add("BankTextEntry")
	self.search:Dock(TOP)
	self.search:SetLabel("Account ID:")
	self.search:DockMargin( 5, 5, 5, 5 )
	self.search.entry:SetPlaceholderText("Type account ID to search in list below")
	self.search.entry.OnChange = function(entry)
		local textData = entry:GetText();
		if string.Trim(textData) != "" then 
			for k, v in pairs(self.accountsList:GetLines()) do
				if !string.find(v.charID, textData) then
					v:Hide()
				else
					v:Show()
				end;
			end;
		end;
	end;

	self.BEnableAutoUpdate = self.accountsListBG:Add("DCheckBoxLabel")
	self.BEnableAutoUpdate:Dock(TOP)
	self.BEnableAutoUpdate:SetText("Enable auto-update (automatically refreshed all data each 3 seconds)")
	self.BEnableAutoUpdate:SetValue(true)
	self.BEnableAutoUpdate:DockMargin( 12, 5, 5, 5 )

	self.accountsList = self.accountsListBG:Add("DListView")
	self.accountsList:Dock(FILL)
	self.accountsList:AddColumn("ID")
	self.accountsList:AddColumn("Money")
	self.accountsList:AddColumn("Loan")
	self.accountsList:AddColumn("Actual loan")
	self.accountsList:AddColumn("Type")	
	
	self.logsList = self.body:Add("DListView")
	self.logsList:Dock(FILL)
	self.logsList:AddColumn("ID")
	self.logsList:AddColumn("Text")
	self.logsList:AddColumn("Time")

	self.leaveButton = self:Add("BankingButton")
	self.leaveButton:Dock(BOTTOM)
	self.leaveButton:SetText("Exit menu")
	self.leaveButton:DockMargin( 10, 5, 10, 5 )
	self.leaveButton.DoClick = function( button )
		self:Close()
	end;
	
	self:Refresh()

	timer.Create("RequestUpdateBankeer", 3, 0, function()
		if self && self:IsValid() then
			if self.BEnableAutoUpdate:GetChecked() && string.Trim(self.search.entry:GetValue()) == "" then
				net.Start("nut.banking.bankeer.syncRequest")
				net.SendToServer()

				self:Refresh()
			end;
		else
			timer.Remove("RequestUpdateBankeer")
		end;
	end)
end

function PANEL:Refresh()
	self.accountsList:Clear();
	self.logsList:Clear();
	self.fundsTotal:SetText(
		Format("TOTAL FUNDS: %s%s; TOTAL ACCOUNTS: %s; TOTAL LOANS OUT: %s;", 
		math.Round(nut.banking.funds, 2), nut.currency.symbol, table.Count(nut.banking.instances), nut.banking.totalLoans()
	))
	for k, v in pairs( nut.banking.instances ) do
		local line = self.accountsList:AddLine( k, v.money, v.loan, v.actualLoan, v.status )
		line.charID = v.charID;

		line.OnSelect = function( button )
			local menu = DermaMenu()
				menu:AddOption("Set loan", function()
					Derma_StringRequest("Set loan", "Type number loan amount(0 to remove the loan):", "0", 
					function(stringText)
						local charID = v.charID
						local floatNumber = tonumber(stringText)
						
						if floatNumber then
							net.Start("nut.banking.option.setLoan")
								net.WriteString(charID)
								net.WriteFloat(floatNumber)
							net.SendToServer()
						end;
					end)
				end)
			menu:Open()
		end;
	end
	for k, v in pairs( nut.banking.log.list ) do
		local line = self.logsList:AddLine(k, v.text, os.date("%H:%M:%S - %d/%m/%Y", v.time))
	end
end;

function PANEL:OnRemove()
	for k, v in pairs(nut.banking.instances) do
		if v.charID != LocalPlayer():getChar():getID() then
			nut.banking.instances[k] = nil;
		end
	end
end;

function PANEL:Paint(w, h)
	draw.RoundedBox(8, 0, 0, w, h, Color(50, 50, 50, 250))
end;

vgui.Register("BankingBankeer", PANEL, "EditablePanel")