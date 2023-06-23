local PLUGIN = PLUGIN;
local sw, sh = ScrW(), ScrH();
local PANEL = {}

function PANEL:Init()
    self:Adaptate(390, 700, 0.37, 0.16)
end
function PANEL:Populate()
    self.Body = self:Add("DPanel")
    self.Body:Dock(FILL)
    self.Body:DockMargin(sw * 0.008, sh * 0.015, sw * 0.008, sh * 0.015)
    self.Body.Paint = function(s, w, h)
        draw.OutlineRectangle(0, 0, w, h, Color(48, 48, 48, 255), Color(0, 0, 0, 255))
    end

    self.Header = self.Body:Add("PhoneHeader")
    
    self.Content = self.Body:Add("PhoneContent")

    self.Footer = self.Body:Add("PhoneFooter")
end;
function PANEL:Paint( w, h )
    if PLUGIN.debug then self:DebugClose() end;
    self:DrawBlur()
		
    draw.OutlineRectangle(0, 0, w, h, Color(65, 65, 65, 210), Color(0, 0, 0, 60))
end;

vgui.Register( "Taxi", PANEL, "SPanel" )

local PANEL = {}
function PANEL:Init()
    local money = LocalPlayer():getChar():getMoney()

    self:Dock(TOP)
    self:SetTall(sh * 0.03)

    self.Balance = self:Add("DLabel")
    self.Balance:SetText("Balance: "..money..nut.currency.symbol)
    self.Balance:Dock(LEFT)
    self.Balance:SetFont("FontSmall")
    self.Balance:DockMargin(sw * 0.005, 0, 0, 0)
    self.Balance:SizeToContents()

    self.Date = self:Add("DLabel")
    self.Date:Dock(RIGHT)
    self.Date:SetText(GetAmericanTime())
    self.Date:SetFont("FontSmall")
    self.Date:DockMargin(0, 0, sw * 0.005, 0)
    self.Date:SizeToContents()

    local uniqueID = "updatePanelData"
    timer.Create(uniqueID, 1, 0, function()
        if !timer.Exists(uniqueID) or !self:IsValid() then timer.Remove(uniqueID) return; end;
        self.Date:SetText(GetAmericanTime())
        self.Date:SizeToContents()
    end);
end
function PANEL:Paint( w, h )
    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 255))    
end;
vgui.Register( "PhoneHeader", PANEL, "DPanel" )

local PANEL = {}
function PANEL:Init()
    self:Dock(BOTTOM)
    self:SetTall(sh * 0.025)

    self.Exit = self:Add("CompButton")
    self.Exit:Dock(FILL)
    self.Exit:SetText("EXIT")
    self.Exit:SetFont("FontSmall")
    self.Exit:SizeToContents()
    self.Exit.clrPaintTo = Color(255, 199, 249)
    self.Exit.DoClick = function(btn)
        if TAXI.interface && TAXI.interface:IsValid() then
            TAXI.interface:Close()
        end
    end;
end
function PANEL:Paint( w, h )
    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
end;
vgui.Register( "PhoneFooter", PANEL, "DPanel" )

local PANEL = {}
function PANEL:Init()
    self:Dock(FILL)

    self.apps = self:Add('DGrid')
    self.apps:Dock(FILL)
    self.apps:SetCols( 5 )
	self.apps:SetColWide( sw * (0.031 + 0.005) )
	self.apps:SetRowHeight( sh * (0.062 + 0.008) )
    self.apps:DockMargin(sw * 0.005, sh * 0.008, sw * 0.005, sh * 0.008)

    local i = #APPS;
    while (i > 0) do
        local app = vgui.Create( "PhoneApp" )
        app.appIndex = #APPS - (i - 1)
        self.apps:AddItem( app )
        i = i - 1;
    end;
end
function PANEL:Paint( w, h ) end;
vgui.Register( "PhoneContent", PANEL, "DPanel" )

local PANEL = {}
function PANEL:Init()
    self:SetSize(sw * 0.034, sh * 0.065)
    self:SetCursor("hand")
    self:SetMouseInputEnabled(true)

    timer.Simple(0, function()
        self:InitApp()
    end);

	self:InitHover(Color(0, 0, 0, 125), Color(35, 35, 35, 255), 0.4, nil)
end;
function PANEL:InitApp()
    local app = APPS[self.appIndex];
    if !app then self:Remove() return end;

    self.text = self:Add('DLabel')
    self.text:Dock(FILL)
    self.text:SetText(app.name)
    self.text:SetFont("FontSmall")
    self.text:SizeToContents()
    self.text:SetContentAlignment(5)
end
function PANEL:Paint( w, h )
    self:HoverButton(w, h)
end;
function PANEL:OnMousePressed()
    local app = APPS[self.appIndex];
    
    if TAXI.interface then
        TAXI.interface.Content.apps:SetVisible(false)

        TAXI.interface.openedApp = TAXI.interface.Content:Add(app.open);
        TAXI.interface.openedApp:SetAppName(app.name)
    end
end;
vgui.Register( 'PhoneApp', PANEL, 'EditablePanel' )
