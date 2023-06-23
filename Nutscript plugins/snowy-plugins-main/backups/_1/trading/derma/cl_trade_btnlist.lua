local PANEL = {}
local PLUGIN = PLUGIN;
local sw, sh = ScrW(), ScrH()
local math = math;
local appr = math.Approach
local frameTime = FrameTime() * 50

function PANEL:Init()
    self:Dock(FILL)

    self.btnBG = self:Add("Panel")
    self.btnBG:CenterVertical(sh * 0.01)
    self.btnBG:SetTall(sh * 0.8)
    self.btnBG:SetWide(sw * 0.095)

    self.AcceptTrade = self.btnBG:Add("TradeButton")
	self.AcceptTrade:Dock(TOP)
	self.AcceptTrade:SetText("ACCEPT")
    self.AcceptTrade:SetTextColor(Color(100, 200, 100))
	self.AcceptTrade:SetTall(sh * 0.02)
    self.AcceptTrade:InitHover(nil, Color(50, 110, 50), 1)

    self.DeclineTrade = self.btnBG:Add("TradeButton")
	self.DeclineTrade:Dock(TOP)
	self.DeclineTrade:SetText("DECLINE")
    self.DeclineTrade:SetTextColor(Color(200, 100, 100))
	self.DeclineTrade:SetTall(sh * 0.02)
    self.DeclineTrade:InitHover(nil, Color(100, 50, 50), 1)

    self.AcceptTrade.DoClick = function(btn)
        if btn.AcceptCD && btn.AcceptCD > CurTime() then
            return;
        end
        btn.AcceptCD = CurTime() + 1;
        local items = PLUGIN:CompactItems()

        netstream.Start('trade::accept', items)
    end;

    self.DeclineTrade.DoClick = function(btn)
        if btn.DeclineCD && btn.DeclineCD > CurTime() then
            return;
        end
        btn.DeclineCD = CurTime() + 1;
        netstream.Start('trade::decline')
    end;

    self.tLabel = self.btnBG:Add("DLabel")
    self.tLabel:SetText("Accepting trade in: ")
    self.tLabel:SetAlpha(0)
    self.tLabel:SetFont("ButtonStyle")
	self.tLabel:Dock(TOP)
    self.tLabel:SetContentAlignment(5)
    self.tLabel:SizeToContents()

    self.tLabel.Think = function(lbl)
        local tmer = timer.Exists("Timer for trade")
        if tmer then
            lbl:SetText("Accepting trade in: ".. math.Round(timer.TimeLeft("Timer for trade")))
        end
    end;
end

vgui.Register( "BtnListTrade", PANEL, "Panel" )

local PANEL = {}

function PANEL:Init()
    self:Dock(TOP)
    self:SizeToContents()
	self:SetMouseInputEnabled( true )
    self:SetContentAlignment(5)
	self:DockMargin(10, 10, 10, 10)
    self:SetCursor("hand")
    self:SetFont("ButtonStyle")

    self:SetMouseInputEnabled(true)
end

function PANEL:InitHover(defaultColor, incrementTo, colorSpeed, borderColor)
    self.dColor = !defaultColor && Color(60, 60, 60) || defaultColor
    self.IncTo = !incrementTo && Color(70, 70, 70) || incrementTo
    self.cSpeed = !colorSpeed && 7 * 100 || colorSpeed * 700;
    self.cCopy = self.dColor // color copy to decrement
    self.bColor = !borderColor && Color(90, 90, 90) || borderColor
end;

function PANEL:Paint( w, h )
    local incTo = self.IncTo; // Increment color to;
    local cCopy = self.cCopy;
    local dis = self.Disable
    local hov = self:IsHovered()
    if dis then
        surface.SetDrawColor(Color(cCopy.r, cCopy.g, cCopy.b, 100));
        surface.DrawRect(0, 0, w, h)
        return;
    end
    local red, green, blue = self.dColor.r, self.dColor.g, self.dColor.b
    self.dColor = {
        r = appr(red, hov && incTo.r || cCopy.r, FrameTime() * self.cSpeed),
        g = appr(green, hov && incTo.g || cCopy.g, FrameTime() * self.cSpeed),
        b = appr(blue, hov && incTo.b || cCopy.b, FrameTime() * self.cSpeed)
    }
    surface.SetDrawColor(self.dColor)
    surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(Color(40, 40, 40))
    surface.DrawOutlinedRect( 0, 0, w, h, 1 )
end;

function PANEL:OnMousePressed()
    if (self.DoClick && !self.Disable) then
        surface.PlaySound("buttons/button18.wav")
        self:DoClick()
    end
end

vgui.Register( "TradeButton", PANEL, "DLabel" )