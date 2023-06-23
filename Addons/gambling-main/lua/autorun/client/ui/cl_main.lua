--[[
    Main gambling panel.
]]
local PANEL = {}

-- Base left panel width.
local left_panel_width = 100;

function PANEL:Init()
    self.left_hovered = false;

    gui.EnableScreenClicker(true);

	Gambling.Adaptate(self, 1000, 700)

	self:SetFocusTopLevel( true )
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, .3, 0, function(alpha, pnl)
        pnl:SetAlpha(255)
    end);
end

function PANEL:Populate()
    ---------------- header ----------------
    self.header = self:Add("Panel")
    self.header:Dock(TOP)
    self.header:SetTall(50)
    self.header.Paint = function(s, w, h)
        draw.RoundedBoxEx( 8, 0, 0, w, h, Gambling.colors.top_panel, true, true )
    end;

    self.label_background = self.header:Add("Panel")
    self.label_background:Dock(FILL)
    self.label_background:DockPadding(10, 0, 0, 0)

    self.label = self.label_background:Add("DLabel")
    self.label:Dock(FILL)
    self.label:SetTextColor(color_white)
    self.label:SetFont("Gambling_title")
    self.label:SetText("gamblert")
    self.label:SizeToContents()

    self.close_button = self.header:Add("DButton")
    self.close_button:Dock(RIGHT)
    self.close_button:SetText("")
    self.close_button:SetWide(50)

    self.close_button.Paint = function(s, w, h)
        if s:IsHovered() then
            draw.RoundedBoxEx( 8, 0, 0, w, h, Gambling.colors.cross, false, true )
        end;
        
        draw.SimpleText("⨯", "Gambling_cross", w/2, h/2-13, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    self.close_button.DoClick = function(button)
        -- $ close button callback;
        
        self:Close()
    end;
    ---------------- header ----------------

    ---------------- body ----------------
    self.body = self:Add("Panel")
    self.body:Dock(FILL)

    self.left_panel = self.body:Add("Gambling__left")
    self.left_panel:SetPos(0, 0)
    self.left_panel:SetZPos(32)
    self.left_panel:SetTall(self:GetTall())

    self.content = self.body:Add("Panel")
    self.content:Dock(FILL)
    self.content:SetZPos(8)
    self.content:DockMargin(left_panel_width, 0, 0, 0)

    self.dimming = self.body:Add("Panel")
    self.dimming:Dock(FILL)
    self.dimming:SetZPos(16)
    self.dimming:SetVisible(false)
    self.dimming:SetAlpha(0)
    self.dimming.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(35, 35, 35, 200))
    end;
    ---------------- body ----------------
end;

function PANEL:Paint(w, h)
    draw.RoundedBoxEx( 8, 0, 0, w, h, Gambling.colors.main, true, true )
end;

function PANEL:Close()
    gui.EnableScreenClicker(false);
	self:AlphaTo(0, .2, 0, function()
        self:SetVisible(false);
        self:Remove()
    end)
end;

vgui.Register("Gambling", PANEL, "EditablePanel")