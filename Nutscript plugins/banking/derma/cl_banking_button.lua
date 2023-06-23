local sw, sh = ScrW(), ScrH();
local PANEL = {}

function PANEL:Init()
	self:SetFont('BankingButtons')
	self:SetTextColor(color_white)
end

function PANEL:Paint(w, h)
	local mainClr = self.clr || nut.config.get("color");
	local disClr = Color(mainClr.r - 35, mainClr.g - 35, mainClr.b - 35)
	if self:IsHovered() && self:IsEnabled() then
		local hoverClr = Color(mainClr.r + 35, mainClr.g + 35, mainClr.b + 35);
		draw.RoundedBox(8, 0, 0, w, h, hoverClr )
	else
		draw.RoundedBox(8, 0, 0, w, h, (self:IsEnabled() && mainClr or disClr) )
	end;
end;

vgui.Register("BankingButton", PANEL, "DButton")