--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).

	Clockwork was created by Conna Wiles (also known as kurozael.)
	http://cloudsixteen.com/license/clockwork.html
--]]

local Clockwork = Clockwork;
local Color = Color;
local vgui = vgui;
local math = math;

local PANEL = {};
local ourMat = Material( "gui/gradient" )
local activePanel = Clockwork.menu:GetActivePanel();

function PANEL:Init()
	self.LabelButton = Clockwork.kernel:CreateMarkupToolTip(vgui.Create("cwLabelButton", self));
	self.ColorToShow = {
		red = 0,
		green = 0,
		blue = 0,
		alpha = 200,
		BorderColor = Color(100, 100, 100, 255);
	}
end;

function PANEL:SetIcon(iconPath, size)
	self.Icon = vgui.Create("DImage", self);
	self.Icon:SetImage(iconPath);
	self.Icon:SetSize(size, size);
	self.Icon:NoClipping(true);
	
	self:UpdatePositioning();
end;

function PANEL:SetupLabel(menuItem, panel)
	self.LabelButton:SetFont(Clockwork.option:GetFont("little_text"));
	self.LabelButton:SetText(string.upper(menuItem.text));
	
	if (CW_CONVAR_FADEPANEL:GetInt() == 1) then
		self.LabelButton:SetAlpha(0);
		self.LabelButton:FadeIn(0.5);
	else
		self.LabelButton:SetAlpha(255);
	end;
	
	self.LabelButton:SetToolTip(menuItem.tip);
	self.LabelButton:SetCallback(function(button)
		if (Clockwork.menu:GetActivePanel() != panel) then
			Clockwork.menu:GetPanel():OpenPanel(panel);
		end;
	end);
	self.LabelButton:SizeToContents();
	self.LabelButton:SetMouseInputEnabled(true);
	
	if (menuItem.iconData and menuItem.iconData.path and menuItem.iconData.path != "") then
		self:SetIcon(menuItem.iconData.path, menuItem.iconData.size or (self.LabelButton:GetTall() + 8));
	end;
	
	self.ContentPanel = panel;
	self:UpdatePositioning();
end;

-- A function to update the positioning of child items.
function PANEL:UpdatePositioning()
	if (not self.LabelButton) then
		return;
	end;

	-- self:SetSize(self.LabelButton.x + self.LabelButton:GetWide() + 0, self.LabelButton:GetTall() + math.max(30, self.Icon:GetTall() / 2));
	
	if (self.Icon) then
		self.Icon:SetSize(0, 0)
		self.Icon:SetPos(0, (self.LabelButton.y + (self.LabelButton:GetTall() / 2)) - (self.Icon:GetTall() / 2));
		self.LabelButton:SetPos(self.Icon:GetWide() + 8, self.LabelButton.y + 100);
		
		self:SetSize(
			self.LabelButton.x + self.LabelButton:GetWide() + 60,
			self.LabelButton:GetTall() + math.max(30, self.Icon:GetTall() / 2)
		);
	else
		self:SetSize(
			self.LabelButton.x + self.LabelButton:GetWide() + 15,
			self.LabelButton:GetTall() + 30
		);
	end;
end;

function PANEL:Paint(x, y)
	surface.SetDrawColor( self.ColorToShow.red, self.ColorToShow.green, self.ColorToShow.blue, self.ColorToShow.alpha )
	surface.SetMaterial( ourMat	)
	surface.DrawTexturedRect( -15, -10, x+100, y-20 )

	draw.RoundedBox( 0, -15, -10, 5, y-20, self.ColorToShow["BorderColor"] )

end

vgui.Register("cwMenuButton", PANEL, "DPanel");