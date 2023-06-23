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

		self:ReloadCalls()

		self.dataBG = self:Add("DPanel")
		self.dataBG:Dock(FILL)

		self.dataLbl = self.dataBG:Add("DLabel")
		self.dataLbl:SetText(TAXI_DATA.taken .. " / " .. TAXI_DATA.reward .. nut.currency.symbol)
		self.dataLbl:Dock(FILL)
		self.dataLbl:SetContentAlignment(5)
		self.dataLbl:SetFont("TaxiBtns")
end;

function PANEL:Paint( w, h )
		if PLUGIN.debug then self:DebugClose() end;
    
    Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
		surface.SetDrawColor(Color(30, 30, 30, 193))
    surface.DrawRect(0, 0, w, h)
end;

function PANEL:ReloadCalls()
		if self.tasksList then self.tasksList:Remove() end;
		if self.taskGrid then self.taskGrid:Remove() end;

		self.tasksList = self:Add("CompScroll")
		self.tasksList:Dock(TOP)
		self.tasksList:SetTall(sh * 0.4)
		self.tasksList:DockMargin(sw * 0.01, sh * 0, sw * 0.01, sh * 0)

		local i = #TAXI_DATA.jobs;

		if i == 0 then
				self.nLBL = self.tasksList:Add("DLabel")
				self.nLBL:SetText("There's no available orders yet")
				self.nLBL:Dock(FILL)
				self.nLBL:SetContentAlignment(5)
				self.nLBL:SetFont("TaxiBtns")

				return;
		else
				if self.nLBL then self.nLBL:Remove(); end
		end

		self.taskGrid = self.tasksList:Add("DGrid")
		self.taskGrid:Dock(FILL)		
		self.taskGrid:SetCols( 3 )
		self.taskGrid:SetColWide( sw * 0.063 )
		self.taskGrid:SetRowHeight( sh * 0.12 )

		while (i > 0) do
				local id = #TAXI_DATA.jobs - (i - 1);

				local but = vgui.Create( "TaxiJob" )
				but:SetSize( sw * 0.058, sh * 0.11 )
				but:SetIndex(i);
				but:Populate();
				self.taskGrid:AddItem( but )

				i = i - 1;
		end
end;

vgui.Register( "TaxiInfo", PANEL, "EditablePanel" )