local PANEL = {}
local PLUGIN = PLUGIN;

function PANEL:Init()
		self:SetFocusTopLevel( true )
    self:MakePopup()
    self:Adaptate(900, 500, 0.27, 0.25)
    gui.EnableScreenClicker(true);
    self:SetAlpha(0)
    self:AlphaTo(255, 0.3, 0, function(alpha, pnl)
        pnl:SetAlpha(255)
    end);
end

function PANEL:Populate()
		local sw, sh = ScrW(), ScrH()
		self.SubPanel = self:Add("Panel")
		self.SubPanel:Dock(FILL)
		self.SubPanel:DockMargin(4, 4, 4, 4)
		self.SubPanel.Paint = function(s, w, h)
				surface.SetDrawColor(Color(0, 255, 255))
    		surface.DrawOutlinedRect( 0, 0, w, h, 2 )
		end;

		self.SearchResults = self.SubPanel:Add('TermEntry')
		self.SearchResults:SetUpdateOnType(true);
		self.SearchResults.OnValueChange = function(entry, val)
				local data = PLUGIN.accsList
				local buffer = {}
				for k, v in pairs(data) do
						sub = pon.decode(v)
						if sub.name:match(val) then
								buffer[k] = v;
						end
				end
				self.Database:Refresh(buffer)
		end;

		self.CloseBG = self.SubPanel:Add("Panel")
		self.CloseBG:Dock(TOP)
		self.CloseBG:DockMargin(0, 7, 7, 0)

		self.CloseButton = self.CloseBG:Add("MButt")
		self.CloseButton:Dock(RIGHT)
		self.CloseButton:SetWide(sw * 0.02)
		self.CloseButton:SetText("X")
		self.CloseButton.Paint = function(s, w, h)
			if s:IsHovered() then
					draw.RoundedBox(0, 0, 0, w, h, Color(0, 128, 128))
			end;
		end;
		self.CloseButton.DoClick = function(btn)
				self:Close()
		end;

		self.Footer = self.SubPanel:Add('Panel')
		self.Footer:Dock(BOTTOM)

		local date = os.date( "%d.%m.%y %H:%M" , os.time() )
		self.DateLabel = self.Footer:Add("DLabel")
		self.DateLabel:SetTextColor(Color(0, 255, 255))
		self.DateLabel:Dock(RIGHT)
		self.DateLabel:SetWide(sw * 0.070)
		self.DateLabel:SetFont("Banking info smaller")
		self.DateLabel:SetText(date)

		self.GeneralFund = self.Footer:Add("DLabel")
		self.GeneralFund:SetTextColor(Color(0, 255, 255))
		self.GeneralFund:Dock(FILL)
		self.GeneralFund:SetFont("Banking info smaller")
		self.GeneralFund:SetText("General fund: " .. PLUGIN.fund .. nut.currency.symbol)
		self.GeneralFund:DockMargin(7, 0, 0, 0)

		self.Database = self.SubPanel:Add("DatabaseList")
		self.Database:Dock(FILL)
		self.Database:ADDColumn( "Name" )
		self.Database:ADDColumn( "Account ID" )
		self.Database:ADDColumn( "Money" )
		self.Database:ADDColumn( "Given loan" )
		self.Database:ADDColumn( "Bankeer" )
		self.Database:ADDColumn( "Actual loan" )
		self.Database:ADDColumn( "Interest" )

		self.Database:Refresh(PLUGIN.accsList)
end;

function PANEL:Paint( w, h )
    Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
		surface.SetDrawColor(Color(0, 0, 128))
    surface.DrawRect(0, 0, w, h)
    surface.SetDrawColor(Color(0, 255, 255))
    surface.DrawOutlinedRect( 0, 0, w, h, 2 )
end;

vgui.Register( "Bank_Database", PANEL, "EditablePanel" )