--[[
    Character information in characters list on the left;
]]

-- ix.datapad.ui:Close()

local PANEL = {}

function PANEL:Init()
    self:Dock(TOP)
    self:SetContentAlignment(5)
    self:DockMargin(5, 10, 5, 0)
    self:SetFont("Datapad_data_info")
    self:SetMouseInputEnabled(true)
    self:SetCursor("hand")

    self.defaultColor = Color(255, 255, 255)
    self.data = {}
end;

function PANEL:SetData( data )
    if not data then
        ErrorNoHalt("Data not specifiend for datapad info!")
        self:Remove()
        return;
    end;

    if data.cid then
        self:SetTextColor(ix.datapad.colors.citizen_color)
        self:SetText(Format("%s, #%s", data.name, data.cid))
    else
        self:SetTextColor(ix.datapad.colors.border)
        self:SetText(data.name)
    end;

    self:SizeToContents()
    
    self.default = table.Copy(self:GetTextColor())
    self.data = data;
end;

function PANEL:PaintOver(w, h)
    if self:IsHovered() then
        self:SetTextColor( 
            Color(
                self.default.r + 50,
                self.default.g + 50,
                self.default.b + 50
            )
        )
    else
        self:SetTextColor(self.default)
    end;
end;

function PANEL:OnMousePressed(keyCode)
    if not ix.datapad.ui or next(self.data) == nil then
        return;
    end;

    if keyCode == MOUSE_LEFT or keyCode == MOUSE_RIGHT then
        ix.datapad.ui.character_data:Load( self.data )
        surface.PlaySound("buttons/button14.wav")
    end;
end;

vgui.Register("Datapad_info", PANEL, "DLabel")