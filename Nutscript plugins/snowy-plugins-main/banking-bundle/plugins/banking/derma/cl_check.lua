local PANEL = {}

function PANEL:Init()
		self:SetFocusTopLevel( true )
    self:MakePopup()
    self:Adaptate(550, 200, 0.35, 0.35)
    gui.EnableScreenClicker(true);
    self:SetAlpha(0)
    self:AlphaTo(255, .3, 0, function(alpha, pnl)
        pnl:SetAlpha(255)
    end);
end

function PANEL:Populate()
		local sw, sh = ScrW(), ScrH()

		self.TopPanel = self:Add("Panel")
		self.TopPanel:Dock(TOP)
		self.TopPanel:SetTall(sh * 0.05)

		//
		self.nameBG = self.TopPanel:Add("Panel")
		self.nameBG:Dock(LEFT)
		self.nameBG:SetWide(sw * 0.08)
		
		self.nameSubtitle = self.nameBG:Add("Panel")
		self.nameSubtitle:Dock(FILL)

		self.name = self.nameSubtitle:Add("ModLabel")
		self.name:Dock(FILL)
		self.name:SetAutoStretchVertical(false)
		self.name:SetTextColor(Color(0, 0, 0))
		self.name:SetFont("Banking typo")
		if checkItem["whoIs"]:len() > 0 then
			local name = checkItem["whoIs"]
			self.name:SetText(name)
		else
			self.name:SetText("")
		end;
		//

		//
		self.bankBG = self.TopPanel:Add("Panel")
		self.bankBG:Dock(LEFT)
		self.bankBG:SetWide(sw * 0.12)
		self.bankBG:SetContentAlignment(5)

		self.bankSubtitle = self.bankBG:Add("Panel")
		self.bankSubtitle:Dock(FILL)

		self.bank = self.bankSubtitle:Add("ModLabel")
		self.bank:Dock(FILL)
		self.bank:SetAutoStretchVertical(false)
		self.bank:SetTextColor(Color(0,0,0))
		self.bank:SetFont("Banking info")
		self.bank:SetText("Gmod Bank")
		//

		//
		self.dateSubtitle = self.TopPanel:Add("Panel")
		self.dateSubtitle:Dock(FILL)

		self.date = self.dateSubtitle:Add("ModLabel")
		self.date:SetTextColor(Color(67, 126, 236))
		self.date:Dock(TOP)
		self.date:DockMargin(10, 10, 10, 10)
		self.date:SetText(os.date( "%b %d, %Y" , os.time() ))
		self.date:SetFont("Banking handly")
		self.date.Paint = function(s, w, h)
				local minus = 2.2
				surface.SetDrawColor(90, 90, 90)
				surface.DrawLine(0, h-minus, w, h-minus)
		end;

		self.Footer = self:Add("Panel")
		self.Footer:Dock(FILL)

		self.FooterSubtitle = self.Footer:Add("Panel")
		self.FooterSubtitle:Dock(TOP)
		self.FooterSubtitle:SetTall(sh * 0.05)
		self.FooterSubtitle.Paint = function(s, w, h)
			local minus = .1
			local offset = 27
			draw.SimpleText("PAY TO THE", "Banking typo little", offset, 12, Color(0, 0, 0, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
			draw.SimpleText("ORDER OF", "Banking typo little", offset-1, 25, Color(0, 0, 0, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
			surface.SetDrawColor(90, 90, 90)
			surface.DrawLine(offset, h-minus, w-(w*0.35), h-minus)
		end;

		self.FooterOffset = self.FooterSubtitle:Add("Panel")
		self.FooterOffset:Dock(LEFT)
		self.FooterOffset:SetWide(sw * 0.065)

		self.FooterBGEntry = self.FooterSubtitle:Add("Panel")
		self.FooterBGEntry:Dock(LEFT)
		self.FooterBGEntry:SetWide(sw * 0.12)

		self.FooterEntry = self.FooterBGEntry:Add("DTextEntry")
		if checkItem["orderFor"]:len() > 0 then self.FooterEntry:SetEnabled(false) end;
		self.FooterEntry:Dock(BOTTOM)
		self.FooterEntry:SetFont("Banking handly")
		self.FooterEntry:SetText(checkItem["orderFor"])
		self.FooterEntry:SetUpdateOnType( true )
		self.FooterEntry.Paint = function(s, w, h)
				s:DrawTextEntryText( Color(67, 126, 236), Color(67, 126, 236), Color(67, 126, 236) )
		end;
		self.FooterEntry.AllowInput = function( entry, val )
			return entry:GetValue():len() >= math.floor((sw * 0.12)/10)
		end
		//

		//
		self.FooterDollarSign = self.FooterSubtitle:Add("Panel")
		self.FooterDollarSign:Dock(LEFT)
		self.FooterDollarSign:SetWide(sw * 0.025)
		self.FooterDollarSign.Paint = function(s, w, h)
				draw.SimpleText("$", "Banking typo big", w * 0.35, h * 0.2, Color(0, 0, 0, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
		end;
		//

		self.MoneyAmount = self.FooterSubtitle:Add("Panel")
		self.MoneyAmount:Dock(LEFT)
		self.MoneyAmount:SetWide(sw * 0.07)

		self.ButtonType = self.MoneyAmount:Add("DTextEntry")
		if checkItem["amount"] > 0 then self.ButtonType:SetEnabled(false) end;
		self.ButtonType:SetText(checkItem["amount"] > 0 && checkItem["amount"] || "")
		self.ButtonType:Dock(FILL)
		self.ButtonType:SetFont("Banking handly big")
		self.ButtonType:DockMargin(5, 5, 5, 5)
		self.ButtonType.Paint = function(s, w, h)
				s:DrawTextEntryText( Color(67, 126, 236), Color(67, 126, 236), Color(67, 126, 236) )
    		surface.SetDrawColor(Color(10, 10, 10))
    		surface.DrawOutlinedRect( 0, 0, w, h, 1 )
		end;

		self.FooterInfo = self.Footer:Add("Panel")
		self.FooterInfo:Dock(TOP)
		self.FooterInfo:SetTall(sh * 0.05)
		
		self.OffsetMemo = self.FooterInfo:Add("Panel")
		self.OffsetMemo:Dock(LEFT)
		self.OffsetMemo:SetWide(sw * 0.015)

		self.Memo = self.FooterInfo:Add("Panel")
		self.Memo:Dock(LEFT)
		self.Memo:SetWide(sw * 0.1975)
		self.Memo.Paint = function(s, w, h)
			local minus = .1
			surface.SetDrawColor(90, 90, 90)
			surface.DrawLine(0, h-minus, w*0.9, h-minus)
			draw.SimpleText("MEMO", "Banking typo little", 0, h * 0.5, Color(0, 0, 0, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
		end;

		self.PlaceSub = self.FooterInfo:Add("Panel")
		self.PlaceSub:Dock(LEFT)
		self.PlaceSub:SetWide(sw * 0.065)

		self.SubScript = self.PlaceSub:Add("DTextEntry")
		if checkItem["sign"]:len() > 0 then self.SubScript:SetEnabled(false) end;
		self.SubScript:SetValue(checkItem["sign"]:len() > 0 && checkItem["sign"] || "")
		self.SubScript:Dock(BOTTOM)
		self.SubScript:SetFont("Banking handly")
		self.SubScript:SetUpdateOnType( true )
		self.SubScript.Paint = function(s, w, h)
				local minus = .1
				surface.SetDrawColor(90, 90, 90)
				surface.DrawLine(0, h-minus, w, h-minus)
				s:DrawTextEntryText( Color(67, 126, 236), Color(67, 126, 236), Color(67, 126, 236) )
		end;
		self.SubScript.AllowInput = function( entry, val )
			return entry:GetValue():len() >= LocalPlayer():Name():len()
		end

		self.FooterNum = self.Footer:Add("Panel")
		self.FooterNum:Dock(TOP)
		self.FooterNum:SetTall(sh * 0.025)
		
		self.OffsetMemo = self.FooterNum:Add("Panel")
		self.OffsetMemo:Dock(LEFT)
		self.OffsetMemo:SetWide(sw * 0.015)

		self.UniqueIDCheck = self.FooterNum:Add("ModLabel")
		self.UniqueIDCheck:Dock(LEFT)
		self.UniqueIDCheck:SetWide(sw * 0.03)
		self.UniqueIDCheck:SetText(checkItem["checkID"] or "0000")
		self.UniqueIDCheck:SetAutoStretchVertical(false)
		self.UniqueIDCheck:SetTextColor(Color(0, 0, 0))
		self.UniqueIDCheck:DockMargin(0, 10, 0, 0)
		self.UniqueIDCheck:SetFont("Banking typo")
		self.UniqueIDCheck.Paint = function(s, w, h)
			draw.RoundedBox(0,0,0, w, h, Color(216, 188, 31))
		end;

		self.CloseBTN = self.FooterNum:Add("ModLabel")
		self.CloseBTN:Dock(FILL)
		self.CloseBTN:SetTextColor(Color(0, 0, 0))
		self.CloseBTN:SetContentAlignment(2)
		self.CloseBTN:SetAutoStretchVertical(false)
		self.CloseBTN:SetText("SIGN / CLOSE")
		self.CloseBTN:SetCursor("hand")
		self.CloseBTN:SetFont("Banking typo")
		self.CloseBTN:SetWide(sw * 0.08)
		self.CloseBTN:SetMouseInputEnabled( true )
		self.CloseBTN.DoClick = function(btn)
				local amount = tonumber(self.ButtonType:GetValue());
				
				if amount && amount > 0 then
						checkItem.amount = amount;
						checkItem.orderFor = self.FooterEntry:GetValue();
						checkItem.sign = self.SubScript:GetValue();

						netstream.Start('bank::submitCheck', checkItem)
				end
				self:Close()
		end;

end;

function PANEL:Paint( w, h )
		surface.SetDrawColor(Color(170, 212, 205))
    surface.DrawRect(0, 0, w, h)
    surface.SetDrawColor(Color(150, 150, 150))
    surface.DrawOutlinedRect( 0, 0, w, h, 1 )

    surface.SetDrawColor(Color(0, 0, 0))
    surface.DrawOutlinedRect( 3, 3, w-6, h-6, 1 )

		surface.SetDrawColor(Color(0, 0, 0))
    surface.DrawOutlinedRect( 6, 6, w-12, h-12, 1 )

		draw.SimpleText("Payment", "Banking handly big", w * 0.17, h * 0.67, Color(67, 126, 236), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
end;

vgui.Register( "CheckPanel", PANEL, "EditablePanel" )
