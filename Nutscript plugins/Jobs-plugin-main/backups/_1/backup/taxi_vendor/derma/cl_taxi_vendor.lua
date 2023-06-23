local PLUGIN = PLUGIN;

local PANEL = {}
local sw, sh = ScrW(), ScrH();
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
		self.title = self:Add("DPanel")
		self.title:Dock(TOP)
		self.title:SetTall(sh * 0.085)
		self.title.Paint = function(s, w, h) end;

		self.lTitle = self.title:Add("DLabel")
		self.lTitle:Dock(FILL)
		self.lTitle:SetText("TAXI")
		self.lTitle:SetContentAlignment(5)
		self.lTitle:SetFont("TaxiTitle")
		self.lTitle:DockMargin(0, 0, 0, 0)

		self.description = self:Add("CompScroll")
		self.description:Dock(TOP)
		self.description:SetTall(sh * 0.38)

		self.lDesc = self.description:Add("DLabel")
		self.lDesc:SetText(TAXI.taxiRules)
		self.lDesc:Dock(FILL)
		self.lDesc:SetAutoStretchVertical(true)
		self.lDesc:SetWrap(true)
		self.lDesc:SetFont("TaxiRules")
		self.lDesc:DockMargin(sw * 0.02, sh * 0.0, sw * 0.008, 0)

		self.btnList = self:Add("DPanel")
		self.btnList:Dock(FILL)
		self.btnList.Paint = function(s, w, h) end;

		self.acceptBtn = self.btnList:Add("CompButton")
		self.acceptBtn:SetText("Accept")
		self.acceptBtn:Dock(LEFT)
		self.acceptBtn:SetWide(sw * 0.05)
		self.acceptBtn:DockMargin(sw * 0.04, 0, 0, 0)
		self.acceptBtn:SetFont("TaxiBtns")
		self.acceptBtn.clrPaintTo = Color(100, 200, 100)

		self.acceptBtn.DoClick = function(btn)
				netstream.Start('taxi::Accept')
				self:Close();
		end;

		self.declineBtn = self.btnList:Add("CompButton")
		self.declineBtn:SetText("Decline")
		self.declineBtn:Dock(LEFT)
		self.declineBtn:SetWide(sw * 0.05)
		self.declineBtn:SetFont("TaxiBtns")
		self.declineBtn:DockMargin(sw * 0.03, 0, 0, 0)
		self.declineBtn.clrPaintTo = Color(200, 100, 100)

		self.declineBtn.DoClick = function(btn)
				self:Close();
		end;
end;

function PANEL:Paint( w, h )
		if PLUGIN.debug then self:DebugClose() end;
    
    Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
		surface.SetDrawColor(Color(30, 30, 30, 193))
    surface.DrawRect(0, 0, w, h)
end;

vgui.Register( "BecameTaxi", PANEL, "EditablePanel" )