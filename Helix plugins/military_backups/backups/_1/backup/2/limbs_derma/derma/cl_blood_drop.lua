local PLUGIN = PLUGIN;
local sw, sh = ScrW(), ScrH();

local PANEL = {}
function PANEL:Init()

	local blood, bleed = math.Round(LIMBS_DATA.Blood, 2), math.Round(LIMBS_DATA.Bleeding, 2);

	self:Dock(TOP)
	self:SetTall( sh * 0.03 )

	self.text = self:Add("DLabel")
	self.text:Dock(FILL)
	self.text:SetFont("LIMB_TEXT")
	self.text:SetText("Кровь: " .. (blood .. " ml ") .. ( bleed > 0 && "(-"..bleed.." ml/sec)" || "" ) )
	self.text:SetContentAlignment(5)
	self.text:SetTextColor(Color(200, 50, 50))
	self.text:SizeToContents()
end;
function PANEL:Paint( w, h ) end;

vgui.Register( 'BloodDrop', PANEL, 'EditablePanel' )