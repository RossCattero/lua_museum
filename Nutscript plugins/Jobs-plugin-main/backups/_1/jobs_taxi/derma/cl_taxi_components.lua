local PLUGIN = PLUGIN;
local sw, sh = ScrW(), ScrH();
local PANEL = {}
function PANEL:Init()
    self:SetCursor("hand")
    self:SetMouseInputEnabled(true)
end;
function PANEL:Paint( w, h )
		draw.RoundedBox(8, 0, 0, w, h, Color(112, 112, 112, 255))
end;
function PANEL:OnMousePressed()
    if TAXI.interface then
				TAXI.interface.openedApp:Remove();
				TAXI.interface.Content.apps:SetVisible(true)
    end
end;
vgui.Register( 'AppCloseButton', PANEL, 'EditablePanel' )

local PANEL = {}
function PANEL:Init()
		self:Dock(FILL)
		self:DockMargin(sw * 0.01, sh * 0.05, sw * 0.01, sh * 0.05)

		timer.Simple(0, function()
				self:Populate()
		end)
end;
function PANEL:SetAppName(text)
	self.appName = text
end;
function PANEL:Populate()
		if !self.appName then
				self.appName = "Unknown"
		end

		self.Header = self:Add("DPanel")
		self.Header:Dock(TOP)
		self.Header:SetTall(sh * 0.03)

		self.title = self.Header:Add('DLabel')
    self.title:Dock(FILL)
    self.title:SetText(self.appName)
    self.title:SetFont("FontSmall")
    self.title:SizeToContents()
    self.title:SetContentAlignment(4)
		self.title:DockMargin(sw * 0.01, 0, 0, 0)
		
		self.closeButton = self.Header:Add("AppCloseButton")
		self.closeButton:Dock(RIGHT)
		self.closeButton:SetWide(sw * 0.012)
		self.closeButton:DockMargin(sw * 0.005, sh * 0.005, sw * 0.005, sh * 0.005)
end;
function PANEL:Paint( w, h )
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 120))
end;
vgui.Register( 'TaxiApp', PANEL, 'EditablePanel' )