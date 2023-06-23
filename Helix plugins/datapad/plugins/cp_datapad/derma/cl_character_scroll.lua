--[[
	Scroll panel re-stilization;
]]

local PANEL = {}

function PANEL:Init()
    local _, ScrollBar = self:GetCanvas(), self:GetVBar()
    ScrollBar:SetWidth(1)
	ScrollBar:SetHideButtons( true )
	function ScrollBar.btnGrip:Paint(w, h) 
		draw.RoundedBox(0, 0, 0, w, h, Color(200, 200, 200, 255))
	end
end;

vgui.Register("Datapad_scroll", PANEL, "DScrollPanel")
