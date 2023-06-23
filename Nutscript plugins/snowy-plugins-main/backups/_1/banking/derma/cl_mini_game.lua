local PANEL = {}

function PANEL:Init()
		self:SetFocusTopLevel( true )
    self:MakePopup()
		local w, h = 750, 385;
		local x, y = 0.30, 0.30
		if SCENARIO.BINARY == 15 then
			w, h = 1150, 715
			x, y = 0.22, 0.18
		end;
    self:Adaptate(w, h, x, y)
    gui.EnableScreenClicker(true);
    self:SetAlpha(0)
    self:AlphaTo(255, .3, 0, function(alpha, pnl)
        pnl:SetAlpha(255)
    end);
end

function PANEL:Populate()
		local sw, sh = ScrW(), ScrH()
		self.MiniGameBG = self:Add("Panel")
		self.MiniGameBG:Dock(LEFT)
		self.MiniGameBG:SetWide(SCENARIO.BINARY == 7 && sw * 0.24 || sw * 0.4)
		
		self.MiniGame = self.MiniGameBG:Add("DGrid")
		self.MiniGame:Dock(FILL)
		self.MiniGame:DockMargin(10, 10, 10, 10)
		self.MiniGame:SetCols( SCENARIO.BINARY + 3 )
		self.MiniGame:SetColWide( sw * 0.022 )
		self.MiniGame:SetRowHeight( sh * 0.038 )

		self:RefreshCache()

		self.INFO = self:Add("ModScroll")
		self.INFO:Dock(TOP)
		self.INFO:SetTall(sh * 0.5)

		pass_INT = 1;
		currPass = DIFF["positions"][pass_INT]

		self.Title = self.INFO:Add("ModLabel")
    self.Title:Dock(TOP)
		self.Title:DockMargin(0, 10, 10, 0)
    self.Title:SetText("The password fragment at: ")
    self.Title:SetFont("Banking id")

		self.TAGBG = self.INFO:Add("Panel")
		self.TAGBG:Dock(TOP)
		self.TAGBG:SetTall(sh * 0.03)
		self.TAGBG:DockMargin(0, 0, 10, 10)
		self.TAGBG.Paint = function (s, w, h)
				surface.SetDrawColor(Color(70, 70, 70, 225))
    		surface.DrawRect(0, 0, w, h)
    		surface.SetDrawColor(Color(0, 99, 191))
    		surface.DrawOutlinedRect( 0, 0, w, h, 1 )	
		end

		self.TAG = self.TAGBG:Add("ModLabel")
		self.TAG:SetAutoStretchVertical(false)
		self.TAG:SetContentAlignment(5)
    self.TAG:Dock(TOP)
		self.TAG:DockMargin(0, 10, 10, 0)
    self.TAG:SetText(currPass)
    self.TAG:SetFont("Banking id")

		self.plbl = self.INFO:Add("ModLabel")
    self.plbl:Dock(TOP)
		self.plbl:DockMargin(0, 10, 10, 0)
    self.plbl:SetText("Decoded password:")
    self.plbl:SetFont("Banking id")

		self.passBG = self.INFO:Add("Panel")
		self.passBG:Dock(TOP)
		self.passBG:SetTall(sh * 0.03)
		self.passBG:DockMargin(0, 0, 10, 10)
		self.passBG.Paint = function (s, w, h)
				surface.SetDrawColor(Color(70, 70, 70, 225))
    		surface.DrawRect(0, 0, w, h)
    		surface.SetDrawColor(Color(0, 99, 191))
    		surface.DrawOutlinedRect( 0, 0, w, h, 1 )	
		end

		self.pword = self.passBG:Add("ModLabel")
		self.pword:SetAutoStretchVertical(false)
		self.pword:SetContentAlignment(5)
    self.pword:Dock(TOP)
		self.pword:DockMargin(0, 10, 10, 0)
    self.pword:SetText("NONE")
    self.pword:SetFont("Banking id")

		self.time_left_lbl = self.INFO:Add("ModLabel")
    self.time_left_lbl:Dock(TOP)
		self.time_left_lbl:DockMargin(0, 10, 10, 0)
    self.time_left_lbl:SetText("Time left: ")
    self.time_left_lbl:SetFont("Banking id")

		self.timeLeft = self.INFO:Add("Panel")
		self.timeLeft:Dock(TOP)
		self.timeLeft:SetTall(sh * 0.037)
		self.timeLeft:DockMargin(0, 0, 10, 10)
		self.timeLeft.Paint = function (s, w, h)
				surface.SetDrawColor(Color(70, 70, 70, 225))
    		surface.DrawRect(0, 0, w, h)
    		surface.SetDrawColor(Color(0, 99, 191))
    		surface.DrawOutlinedRect( 0, 0, w, h, 1 )	
		end

		self.time = self.timeLeft:Add("ModLabel")
		self.time:SetAutoStretchVertical(true)
		self.time:SetContentAlignment(5)
    self.time:Dock(TOP)
		self.time:DockMargin(0, 10, 10, 0)
		self.time:SetText("Pending...")
    self.time:SetFont("Banking id")

		self.attempts = self.INFO:Add("Panel")
		self.attempts:Dock(TOP)
		self.attempts:SetTall(sh * 0.037)
		self.attempts:DockMargin(0, 0, 10, 10)
		self.attempts.Paint = function (s, w, h)
				surface.SetDrawColor(Color(70, 70, 70, 225))
    		surface.DrawRect(0, 0, w, h)
    		surface.SetDrawColor(Color(0, 99, 191))
    		surface.DrawOutlinedRect( 0, 0, w, h, 1 )	
		end

		self.att = self.attempts:Add("ModLabel")
		self.att:SetAutoStretchVertical(true)
		self.att:SetContentAlignment(5)
    self.att:Dock(TOP)
		self.att:DockMargin(0, 10, 10, 0)
		self.att:SetText("Attempts: " .. ATTEMPTS .. "/" .. SCENARIO.ATTEMPTS)
    self.att:SetFont("Banking id")

		self.rewardAmount = self.INFO:Add("Panel")
		self.rewardAmount:Dock(TOP)
		self.rewardAmount:SetTall(sh * 0.037)
		self.rewardAmount:DockMargin(0, 0, 10, 10)
		self.rewardAmount.Paint = function (s, w, h)
				surface.SetDrawColor(Color(70, 70, 70, 225))
    		surface.DrawRect(0, 0, w, h)
    		surface.SetDrawColor(Color(0, 99, 191))
    		surface.DrawOutlinedRect( 0, 0, w, h, 1 )	
		end

		self.rew = self.rewardAmount:Add("ModLabel")
		self.rew:SetAutoStretchVertical(true)
		self.rew:SetContentAlignment(5)
    self.rew:Dock(TOP)
		self.rew:DockMargin(0, 10, 10, 0)
		self.rew:SetText("Vault contains: " .. math.min(SCENARIO.REWARD, FUND) .. nut.currency.symbol)
    self.rew:SetFont("Banking id")

		self.ExitHack = self.INFO:Add("MButt")
		self.ExitHack:Dock(TOP)
		self.ExitHack:SetFont("Banking id")
		self.ExitHack:SetText("[EXIT]")
		self.ExitHack:SetTall(sh * 0.02)
		self.ExitHack:DockMargin(0, 10, 10, 0)
		self.ExitHack.DoClick = function(btn)
				self:Close()
		end;
	end;

function PANEL:Paint( w, h )
    Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
		surface.SetDrawColor(Color(70, 70, 70, 225))
    surface.DrawRect(0, 0, w, h)
    surface.SetDrawColor(Color(0, 99, 191))
    surface.DrawOutlinedRect( 0, 0, w, h, 1 )	
end;

function PANEL:RefreshCache()
		local sw, sh = ScrW(), ScrH()

		for row, rowData in pairs(DIFF["stack"]) do
				local num = vgui.Create("DIGIT")
				num:SetSize(sw * 0.02, sh * 0.035)
				num:SetText(row)
				num:DISABLE(true)
				self.MiniGame:AddItem(num)

				for tagName, tagData in pairs(rowData) do
						local tag = vgui.Create("DIGIT")
						tag:SetSize(sw * 0.02, sh * 0.035)
						tag:SetText(tagName)
						tag:DISABLE(true)
						self.MiniGame:AddItem(tag)
						for column = 0, #tagData do
								local digit = vgui.Create("DIGIT")
								digit:SetSize(sw * 0.02, sh * 0.035)
								digit:SetText(tagData[column])
								digit.InRow = row;
								digit.InColumn = column;
								digit.TAG = tagName;
								self.MiniGame:AddItem(digit)
						end
				end
		end

		for i = 1, SCENARIO.BINARY + 3 do
				if i == 1 then 
						local id = vgui.Create("DIGIT")
						id:SetSize(sw * 0.02, sh * 0.035)
						id:SetText("ID")
						id:DISABLE(true)
						self.MiniGame:AddItem(id)
						continue;
				elseif i == 2 then
						local tag = vgui.Create("DIGIT")
						tag:SetSize(sw * 0.02, sh * 0.035)
						tag:SetText("TAG")
						tag:DISABLE(true)
						self.MiniGame:AddItem(tag)
						continue;
				end;
				local numLine = vgui.Create("DIGIT")
				numLine:SetSize(sw * 0.02, sh * 0.035)
				numLine:SetText(i - 3)
				numLine:DISABLE(true)
				self.MiniGame:AddItem(numLine)
		end
end;

function PANEL:OnRemove()
		netstream.Start('bank::PnlRemoved')
end;

function PANEL:GenerateCode()
		for k, v in pairs(DIGITSLIST) do
				if math.random(0, 1) == 1 then
						TAG = k
						break;
				end
		end
		local subTag = math.IntToBin("0x" .. TAG);
		for i = 0, 1 do
				local bb = math.IntToBin(math.random(0, SCENARIO.BINARY));
				subTag = subTag .. bb
		end

		return subTag;
end;

vgui.Register( "Mini_game_SW", PANEL, "EditablePanel" )