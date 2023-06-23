local PLUGIN = PLUGIN;
local sw, sh = ScrW(), ScrH();
local PANEL = {}

function PANEL:Init()
		self:SetFocusTopLevel( true )
    self:MakePopup()
    self:Adaptate(400, 556, 0.38, 0.25)
    gui.EnableScreenClicker(true);
    self:SetAlpha(0)
    self:AlphaTo(255, .3, 0, function(alpha, pnl)
        pnl:SetAlpha(255)
        if PLUGIN.debug then
            self.debugClose = true;
        end;
    end);
end

function PANEL:Populate()
		local money = LocalPlayer():getChar():getMoney();
		local price = math.Round(TAXI.taxiBase + (PLUGIN:GetTaxistsAmount() * TAXI.taxiBonus), 2)
		self.title = self:Add("DPanel")
		self.title:Dock(TOP)
		self.title:SetTall(sh * 0.050)
		self.title.Paint = function(s, w, h) end;

		self.lTitle = self.title:Add("DLabel")
		self.lTitle:Dock(FILL)
		self.lTitle:SetText("TAXI")
		self.lTitle:SetContentAlignment(5)
		self.lTitle:SetFont("TaxiTitle")
		self.lTitle:DockMargin(sw * 0.025, 0, 0, 0)

		self.CloseButton = self.title:Add("TaxiCloseButton")

		self.dataPanel = self:Add("CompScroll")
		self.dataPanel:Dock(FILL)

		self.moneyAmount = self.dataPanel:Add("DLabel")
		self.moneyAmount:SetText("Your money amount: " .. nut.currency.get(money))
		self.moneyAmount:Dock(TOP)
		self.moneyAmount:SetContentAlignment(5)
		self.moneyAmount:SetFont("TaxiBtns")
		self.moneyAmount:DockMargin(0, sh * 0.15, 0, sh * 0.02)

		self.moneyAmount:SetTextColor( money < price && Color(200, 100, 100) || color_white )

		self.taxiPrice = self.dataPanel:Add("DLabel")
		self.taxiPrice:SetText("Price of taxi now: " .. nut.currency.get(price))
		self.taxiPrice:Dock(TOP)
		self.taxiPrice:SetContentAlignment(5)
		self.taxiPrice:SetFont("TaxiBtns")
		self.taxiPrice:DockMargin(0, 0, 0, sh * 0.02)

		self.taxiOnline = self.dataPanel:Add("DLabel")
		self.taxiOnline:SetText("Amount of taxi online: ")
		self.taxiOnline:Dock(TOP)
		self.taxiOnline:SetContentAlignment(5)
		self.taxiOnline:SetFont("TaxiBtns")

		self.orderTaxi = self.dataPanel:Add("TaxiUtilityButton")
		self.orderTaxi:SetDisabled( money < price )
		self.orderTaxi:SetText("Order")

		self.orderTaxi.DoClick = function(btn)
				if TAXI_COOLDOWN && TAXI_COOLDOWN > CurTime() then
						nut.util.notify("You can't send a new taxi order right now. Wait " .. math.Round(TAXI_COOLDOWN - CurTime()) .. " more seconds, please.")
						return;
				end

				TAXI_COOLDOWN = CurTime() + 60;
				netstream.Start('taxi::sendTaxiRequest')

				surface.PlaySound("buttons/button24.wav")
		end;
		local notify = "If your order will be taken - you'll pay a fee for taxi call in amount of " .. TAXI.taxiFee .. nut.currency.symbol;

		local x, y = surface.GetTextSize(notify)
		local minAmount = y + 5;
		local lineAmount = math.ceil(notify:len() / minAmount);
		local i = 1;
		local min, max;
		while (i <= lineAmount) do
			min = (i - 1) * minAmount;
			max = i * minAmount;

			local text = notify:sub(min, max-1)

			local stringLine = self.dataPanel:Add("DLabel")
			stringLine:SetFont("TaxiBtns")
			stringLine:Dock(TOP)
			stringLine:SetText( text .. (i == lineAmount && "" || "-") )
			stringLine:SetContentAlignment(5)

			i = i + 1;
		end

		self.dataPanel:Hide();

		self.nullLbl = self:Add("DLabel")
		self.nullLbl:SetText("Updaing...")
		self.nullLbl:Dock(FILL)
		self.nullLbl:SetContentAlignment(5)
		self.nullLbl:SetFont("TaxiBtns")

		local uniqueID = "checkTaxiAmount"
		timer.Create(uniqueID, 1, 0, function()
				if !timer.Exists(uniqueID) or !self:IsValid() then timer.Remove(uniqueID) return; end;
				local taxists = PLUGIN:GetTaxistsAmount();
				if taxists > 0 then
						self.dataPanel:Show()
						self.nullLbl:Hide()
				else
						self.nullLbl:SetText("No available taxi for now")
				end
				self.taxiOnline:SetText("Amount of taxi online: " .. taxists)
		end);
end;

function PANEL:Paint( w, h )
		if PLUGIN.debug then self:DebugClose() end;
    
    Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
		surface.SetDrawColor(Color(30, 30, 30, 193))
    surface.DrawRect(0, 0, w, h)
end;

vgui.Register( "TaxiCustomer", PANEL, "EditablePanel" )