--[[
  Scroll panel;
]]
local PANEL = {}

function PANEL:Init()
    -- Change the scrollbar view;
    local ScrollBar = self:GetVBar()
    ScrollBar:SetWidth(10)
	  ScrollBar:SetHideButtons( true )

    -- Scrollbar background;
    ScrollBar.Paint = function(s, w, h)
		  draw.RoundedBox(8, 0, 0, w, h, Color(35, 35, 35, 255))
    end;

    -- Scrollbar style itself;
    ScrollBar.btnGrip.Paint = function(s, w, h) 
      draw.RoundedBox(8, 0, 0, w, h, Color(68, 165, 228, 255))
    end
end;

vgui.Register("Gambling__scroll", PANEL, "DScrollPanel")
