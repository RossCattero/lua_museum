--[[
    Input re-stilization.
]]

DEFINE_BASECLASS("DTextEntry")
local PANEL = {}

local border_width = 2;
local border_length = 20;

function PANEL:Init()
    self:DockMargin(0, 5, 0, 0)
    
    self.input_title = self:Add("DLabel")
    self.input_title:Dock(TOP)
    self.input_title:SetText("Input here:")
    self.input_title:SetContentAlignment(4)
    self.input_title:SetFont("Datapad_data_text")
    self.input_title:SizeToContents()
    self.input_title:DockMargin(border_width + 5, border_width, 0, border_width)

    self.input = self:Add("DTextEntry")
    self.input:Dock(FILL)
    self.input:SetUpdateOnType(true)
    self.input:SetMultiline(true)
    self.input:DockMargin(border_width, border_width, border_width, border_width)
    self.input:SetFont("Datapad_data_text")
    self.input.Paint = function(s, w, h)
        s:DrawTextEntryText(ix.datapad.colors.text, Color(100, 100, 255, 150), Color(255, 255, 255))
    end;

    self.input:SizeToContents()
end

function PANEL:SetTitle(title)
    self.input_title:SetText(title)
    self.input_title:SizeToContents()
end;

function PANEL:SetTitleColor(color)
    self.input_title:SetTextColor(color or ix.datapad.colors.text)
end;

function PANEL:SetText(text)
    self.input:SetText( text )
    self.input:SizeToContents()
end;

function PANEL:GetText()
    return self.input:GetText()
end;

function PANEL:SetEnabled(bool)
    BaseClass.SetEnabled(self, bool)
    self.input:SetEnabled(bool)
end;

function PANEL:SetMultiline(bMultiline)
    self.input:SetMultiline(bMultiline)
end;

function PANEL:Paint(w, h)
    -- Some stilization
    surface.SetDrawColor(ix.datapad.colors.border)

    -- Left top corner
    surface.DrawRect(0, 0, border_width, h * (border_length/h))
    surface.DrawRect(0, 0, w * (border_length/w), border_width)

    -- Left bottom corner
    surface.DrawRect(0, h - border_length, border_width, h * (border_length/h))
    surface.DrawRect(0, h - border_width, w * (border_length/w), border_width)

    -- Right top corner
    surface.DrawRect(w - border_width, 0, border_width, h * (border_length/h))
    surface.DrawRect(w - border_length, 0, w * (border_length/w), border_width)

    -- Right bottom corner
    surface.DrawRect(w - border_width, h - border_length, border_width, border_length)
    surface.DrawRect(w - border_length, h - border_width, border_length, border_width)
end;

vgui.Register("Datapad_character_input", PANEL, "EditablePanel")