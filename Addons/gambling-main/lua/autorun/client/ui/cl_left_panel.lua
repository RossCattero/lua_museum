--[[
    Left panel;
]]

local PANEL = {}

local base_width, base_width_offset = 0, 20;
local real_width, real_width_offset = 0, 150;

function PANEL:Init()
    -- Add all the buttons with functionality from the gambling buttons list;
    for index, button in SortedPairs(Gambling.buttons) do
        local panel_button = self:Add("Gambling__button")
        panel_button:Dock(TOP)
        panel_button:SetTall(80)
        panel_button:SetText(button.text)
        panel_button:SetMaterial(button.image)

        panel_button.DoClick = function(btn)
            -- $ callback for cl_buttons.lua
            -- Don't change it here, look at client/cl_buttons.lua

            surface.PlaySound(button.sound or Gambling.click_sound)

            button.onRun(btn)
        end;
    end;

    timer.Simple(0, function()
        for k, v in pairs(self:GetCanvas():GetChildren()) do
            if v.GetRealWidth and v:GetRealWidth() + real_width_offset > real_width then
                real_width = v:GetRealWidth() + real_width_offset;
            end;

            if v.image and v.image:GetWide() + base_width_offset > base_width then
                base_width = v.image:GetWide() + base_width_offset
            end;
        end;
        self:SetWide(base_width)
    end);
end;

function PANEL:Paint(w, h)
    surface.SetDrawColor(Gambling.colors.left_panel)
    surface.DrawRect(0, 0, w, h)

    if (self:IsHovered() or self:IsChildHovered()) and base_width < real_width then
        self:SetWide(math.Approach(self:GetWide(), real_width, FrameTime()*300))

        Gambling.ui.left_hovered = true;

        Gambling.ui.dimming:SetVisible(true)
        Gambling.ui.dimming:SetAlpha(
            math.Approach(Gambling.ui.dimming:GetAlpha(), 255, FrameTime()*700)
        )
    else
        self:SetWide(math.Approach(self:GetWide(), base_width, FrameTime()*300))

        Gambling.ui.left_hovered = false;

        Gambling.ui.dimming:SetAlpha(
            math.Approach(Gambling.ui.dimming:GetAlpha(), 0, FrameTime()*700)
        )
        if Gambling.ui.dimming:GetAlpha() <= 0 then
            Gambling.ui.dimming:SetVisible(false)
        end;
    end;
end;

-- function PANEL:OnSizeChanged( w )
--     if not base_width then
--         base_width = w;
--     end;
-- end;

vgui.Register("Gambling__left", PANEL, "Gambling__scroll")