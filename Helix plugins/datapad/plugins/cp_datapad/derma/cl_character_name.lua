--[[
    Special label for character name on the 'data panel' on the right;
]]
local PANEL = {}

-- Local box offset for text background
local box_offset = 10;

function PANEL:Init()
    self.text = self:Add("DLabel")
    self.text:Dock(FILL)
    self.text:SetText("")
    self.text:SetFont("Datapad_data_text")
    self.text:SetContentAlignment(5)
end

function PANEL:SetText(text)
    self.text:SetText( text )
end;

function PANEL:Paint(w, h)
    surface.SetDrawColor(ix.datapad.colors.border)
	surface.DrawRect(0, h/2, w, 1)

    surface.SetFont(self.text:GetFont())
    local text_w, text_h = surface.GetTextSize(self.text:GetText())
    surface.SetDrawColor(ix.datapad.colors.main)
    surface.DrawRect(w/2 - text_w/2 - box_offset, 0, text_w + box_offset * 2, text_h)
end;

vgui.Register("Datapad_character_name", PANEL, "EditablePanel")