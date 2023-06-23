--[[
    Main datapad panel;
]]
local PANEL = {}

function PANEL:Init()
    gui.EnableScreenClicker(true);

	ix.datapad.Adaptate(self, 650, 1000)

	self:SetFocusTopLevel( true )
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, .3, 0, function(alpha, pnl)
        pnl:SetAlpha(255)
    end);
end

function PANEL:Populate()
    self.body = self:Add("Panel")
    self.body:Dock(FILL)
    self.body:DockMargin(15, 5, 15, 0)

    self.character_list = self.body:Add("Datapad_character_list")
    self.character_list:Dock(LEFT)
    self.character_list:SetWide(300)

    self.character_data = self.body:Add("Datapad_character_data")
    self.character_data:Dock(FILL)
    self.character_data:SetVisible(false)

    self.footer = self:Add("Panel")
    self.footer:Dock(BOTTOM)
    self.footer:DockMargin(15, 5, 15, 10)

    self.close_button = self.footer:Add("DButton")
    self.close_button:Dock(RIGHT)
    self.close_button:SetText("")
    self.close_button:SetWide(25)
    self.close_button.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, ix.datapad.colors.border)
    end
    self.close_button.DoClick = function(button)
        self:Close()
    end;
end;

function PANEL:Paint(w, h)
    surface.SetDrawColor(ix.datapad.colors.main)
    surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(ix.datapad.colors.border)
	surface.DrawOutlinedRect(0, 0, w, h, 2)
end;

function PANEL:Close()
    gui.EnableScreenClicker(false);
	self:AlphaTo(0, .2, 0, function()
        self:SetVisible(false);
        self:Remove()
    end)
end;

function PANEL:OnRemove()
    ix.archive.logs.list = {}
    ix.archive.instances = {}
end;

vgui.Register("Datapad", PANEL, "EditablePanel")