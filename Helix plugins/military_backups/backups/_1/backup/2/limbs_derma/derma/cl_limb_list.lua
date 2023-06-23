local PLUGIN = PLUGIN;
local sw, sh = ScrW(), ScrH();

local PANEL = {}

function PANEL:Init()
	self:Dock(TOP)
	self:DockMargin(0, 5, 0, 5)
end;
function PANEL:Populate()
	local info = self.data;

	self.titleBG = self:Add("DPanel")
	self.titleBG:Dock(TOP)
	self.titleBG.Paint = function(s, w, h) end;

	self.titleBG.title = self.titleBG:Add("DLabel")
	self.titleBG.title:SetText(info.name)
	self.titleBG.title:Dock(FILL)
	self.titleBG.title:SetFont("LIMB_SUBTEXT")
	self.titleBG.title:SetContentAlignment(5)
	self.titleBG.title:SizeToContents()

	self.limbList = self:Add("DListLayout")
	self.limbList:Dock(TOP)
end;

function PANEL:ReloadInjuries()
		self.limbList:Clear();
		local bone = LIMBS_DATA.Limbs[ self.data.index ]

		if !bone then return end;

		if #bone <= 0 then
			local noInj = self.limbList:Add("DLabel")
			noInj:SetFont("LIMB_EMPTY")
			noInj:Dock(TOP)
			noInj:SetText("~ Нет повреждений ~")
			noInj:SetTextColor( Color(150, 150, 150) )
			noInj:SetContentAlignment(5)
			noInj:SetTall(35)
		else
			for k, v in pairs(bone) do
				local limb = self.limbList:Add("LIMBSDraw")
				limb.data = v
				limb.bone = self.data.index 
				limb.index = k
				limb:Populate();
			end
		end;

		self.limbList:InvalidateLayout( true )
		self.limbList:SizeToChildren( false, true )
		self:InvalidateLayout( true )
		self:SizeToChildren( false, true )
end;
vgui.Register( 'LimbList', PANEL, 'EditablePanel' )