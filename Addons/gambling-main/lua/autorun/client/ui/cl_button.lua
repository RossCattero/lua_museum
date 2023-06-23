--[[
    Left panel styled buttons with images on it;
]]

local PANEL = {}

AccessorFunc(PANEL, "material", "Material")
AccessorFunc(PANEL, "text", "Text")
AccessorFunc(PANEL, "textAlpha", "TextAlpha")

local commonFont = "Gambling_7"
local text_offset = 20;

function PANEL:Init()
    self:SizeToContents()
    self:DockPadding(10, 10, 10, 10)

    self:SetCursor("hand")
    self:SetMouseInputEnabled(true)

    self.image = self:Add("DImage")
    self.image:Dock(LEFT)
    self.image:SetMaterial(Material("debug/debugempty"))

    self:SetTextAlpha(0)
end;

function PANEL:SetMaterial(material)
    self.material = material
    self.image:SetMaterial(material)
end;

function PANEL:SetText(text)
    self.text = text
end;

-- Get the real width combined of label width + image width;
---@return number (Real width)
function PANEL:GetRealWidth()
    surface.SetFont(commonFont)
    local textW, textH = surface.GetTextSize(self.text)

    -- return (math.ceil((70/1080) * ScrH())/2 - self.material:Width()/2) + textW + marginLeft + padding;

    return self.image:GetWide() + text_offset + textW;
end;

--- Add DoClick call on this button out of this code to make a callback;
function PANEL:OnMousePressed(keyCode)
    if keyCode ~= MOUSE_LEFT then
        return;
    end;

    if self.DoClick then
        self:DoClick(self)
    end;
end;

function PANEL:Paint(w, h)
    if Gambling.ui.left_hovered then
        self:SetTextAlpha(math.Approach(self:GetTextAlpha(), 255, FrameTime()*1000))
    elseif not Gambling.ui.left_hovered then
        self:SetTextAlpha(math.Approach(self:GetTextAlpha(), 0, FrameTime()*1000))
    end;

    if self:IsHovered() then
        draw.RoundedBox(0, 0, 0, w, h, Color(150, 150, 150, 100))
    end;

    draw.TextShadow( {
        text = self.text,
        font = commonFont,
        pos = {self.image:GetWide() + text_offset, h/2-self.material:Height()/2 + 13},
        yalign = TEXT_ALIGN_LEFT,
        color = Color(255, 255, 255, self:GetTextAlpha())
    }, 1, self:GetTextAlpha() )
end;

function PANEL:OnSizeChanged(w, h)
    self.image:SetWide(h - 10)
end;

vgui.Register("Gambling__button", PANEL, "EditablePanel")
